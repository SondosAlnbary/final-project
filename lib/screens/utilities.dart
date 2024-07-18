import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final_project/screens/map_page.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utilities extends StatefulWidget {
  const Utilities({Key? key}) : super(key: key);

  @override
  _UtilitiesState createState() => _UtilitiesState();
}

class _UtilitiesState extends State<Utilities> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  String? userName;
  String? messageText;
  String? messageText1;
  bool showImages = false;
  List<String> downloadUrls = [];
  List<File> _images = [];
  int? selectedImage;
  int? selectedImageIndex;
  String? documents;
  LatLng? currentLocation;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getLocation();
  }

  Future<void> getLocation() async {
    Location location = Location();
    LocationData _locationData = await location.getLocation();
    setState(() {
      currentLocation =
          LatLng(_locationData.latitude!, _locationData.longitude!);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
        showImages = true;
      });
    }
  }

  Future<void> changeImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        if (_images.isNotEmpty) {
          _images.removeAt(0);
        }
        _images.add(File(image.path));
        showImages = true;
      });
    }
  }

  Future<void> changeImageIndex(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        if (selectedImageIndex != null) {
          _images[selectedImageIndex!] = File(image.path);
        }
        _images.add(File(image.path));
        showImages = true;
      });
    }
  }

  Future<void> _uploadImagesToFirebaseStorage() async {
    for (int i = 0; i < _images.length; i++) {
      try {
        File imageFile = _images[i];
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/$documents/$fileName.jpg');

        UploadTask uploadTask = storageReference.putFile(imageFile);

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (error) {
        print('Error uploading image $i: $error');
      }
    }
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
        getUserName();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserName() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(signedInUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _sendReport({required bool isEmergency}) async {
    if (!_formKey.currentState!.validate()) {
      _showSnackbar(context, 'Please fill out all fields.');
      return;
    }

    if (currentLocation == null) {
      _showSnackbar(context, 'Could not get current location.');
      return;
    }

    try {
      DocumentReference docRef = await _firestore.collection('Utilities').add({
        'sender': signedInUser.email,
        'name': userName,
        'address': messageText1,
        'Report': messageText,
        'situation': 'Not treated yet',
        'Emergency': isEmergency ? 'yes' : 'no',
        'currentLocation':
            GeoPoint(currentLocation!.latitude, currentLocation!.longitude),
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Utilities')
          .where('sender', isEqualTo: signedInUser.email)
          .where('name', isEqualTo: userName)
          .where('address', isEqualTo: messageText1)
          .where('Report', isEqualTo: messageText)
          .get();

      documents = snapshot.docs[0].id.toString();
      await _uploadImagesToFirebaseStorage();
      if (isEmergency) {
        await docRef.update({'Emergency': 'yes'});
      }

      _showSnackbar(context, 'Report received');
    } catch (e) {
      _showSnackbar(context, 'Error sending report');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Utilities'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/noeye.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(
                  height: 10,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Create a report',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 100, 45, 155),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              messageText1 = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the address';
                              }
                              if (value.length < 2) {
                                return "Address is too short.";
                              } else if (value.length > 50) {
                                return "Address is too long.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: 'Enter Address',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              messageText = value;
                            },
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Defect description',
                              hintText: 'Enter a description',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading:
                                              const Icon(Icons.photo_library),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            _pickImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            _pickImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Add photo',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          showImages
                              ? Container(
                                  height: 300,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _images.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 90,
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedImage = index;
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: Image.file(
                                                            _images[index]),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text('Close'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  showImages =
                                                                      true;

                                                                  return Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            16),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        ListTile(
                                                                          leading:
                                                                              Icon(Icons.photo_library),
                                                                          title:
                                                                              Text('Gallery'),
                                                                          onTap:
                                                                              () {
                                                                            changeImage(ImageSource.gallery);

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          leading:
                                                                              Icon(Icons.camera_alt),
                                                                          title:
                                                                              Text('camera'),
                                                                          onTap:
                                                                              () {
                                                                            changeImage(ImageSource.camera);
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ); // או _pickImage(ImageSource.camera);
                                                            },
                                                            child:
                                                                Text('change'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _images
                                                                    .removeAt(
                                                                        index);
                                                                if (_images
                                                                    .isEmpty) {
                                                                  showImages =
                                                                      false;
                                                                }
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text('Delete'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Image.file(
                                                  _images[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            if (selectedImage == index)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 10,
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {
                              await _sendReport(isEmergency: true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Emergency',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {
                              await _sendReport(isEmergency: false);
                            },
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: Color.fromARGB(255, 22, 2, 2),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // TextButton(
                          //     onPressed: () {
                          //      Navigator.pushReplacement(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => MapPage()),
                          //       );
                          //     },
                          //     child: Text('map'))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
