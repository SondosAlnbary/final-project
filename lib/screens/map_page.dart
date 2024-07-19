import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final LatLng? initialLocation;
  final String documentId;
  final String assusise;

  const MapPage({
    Key? key,
    this.initialLocation,
    required this.documentId,
    required this.assusise,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng _currentp = LatLng(31.25181, 34.7913); // Default to Be'er Sheva
  LatLng? _documentLocation;

  Map<PolylineId, Polyline> polylines = {};
  final String googleAPIKey =
      "AIzaSyDac1_kPB36lIoq6k3HvF3CbzqdNvZEQAk"; // Replace with your actual Google Maps API Key

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _currentp = widget.initialLocation!;
    } else {
      getLocationUpdates();
    }
    getDocumentData(widget.documentId);
  }

  Future<void> getDocumentData(String docId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(widget.assusise)
          .doc(widget.documentId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data['currentLocation'] != null) {
          GeoPoint geoPoint = data['currentLocation'];
          setState(() {
            _documentLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
          });
          _updatePolyline();
        }
      }
    } catch (e) {
      print("Error getting document data: $e");
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentp =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        // _cameraToPosition(_currentp);
        _updatePolyline();
      }
    });
  }

  Future<void> _updatePolyline() async {
    if (_documentLocation != null) {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentp.latitude},${_currentp.longitude}&destination=${_documentLocation!.latitude},${_documentLocation!.longitude}&key=$googleAPIKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polylinePoints = route['overview_polyline']['points'];
          final decodedPoints = _decodePolyline(polylinePoints);

          generatePolylineFromPoints(decodedPoints);
        }
      } else {
        print('Error fetching directions: ${response.statusCode}');
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 12,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Maps'), centerTitle: true),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) =>
            _mapController.complete(controller),
        initialCameraPosition: CameraPosition(
          target: _currentp,
          zoom: 13,
        ),
        markers: _createMarkers(),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};
    // Current location marker
    markers.add(
      Marker(
        markerId: MarkerId("currentLocation"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: _currentp,
      ),
    );

    // Document location marker
    if (_documentLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId("documentLocation"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: _documentLocation!,
        ),
      );
    }

    return markers;
  }
}
