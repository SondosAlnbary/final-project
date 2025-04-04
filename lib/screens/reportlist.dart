import 'package:final_project/screens/emergencyreports.dart';
import 'package:final_project/screens/map_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'welcome_screen.dart';

String name = '12';

class ReportListScreen extends StatefulWidget {
  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  List<String> collections = [
    'Sanitation',
    'environment',
    'garden',
    'road',
    'lighting',
    'safety',
    'Utilities',
    'transportation'
  ]; // Add your collection names here

  String selectedCollection = 'Sanitation'; // Initial collection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Report List',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emergency()),
              );
            },
            child: Text(
              'Emergency Reports',
              style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/noeye.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButton(
                      value: selectedCollection,
                      onChanged: (String? newValue) async {
                        bool exists = await doesCollectionExist(newValue!);
                        setState(() {
                          selectedCollection = exists ? newValue : 'Sanitation';
                        });
                      },
                      items: collections
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(selectedCollection)
                        .where('sender', isNotEqualTo: '')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No reports available.',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      final reports = snapshot.data!.docs.reversed.toList();

                      return ListView.builder(
                        shrinkWrap:
                            true, // Added to ensure ListView works inside SingleChildScrollView
                        physics:
                            NeverScrollableScrollPhysics(), // Added to prevent ListView from scrolling independently
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          var report = reports[index];
                          return ReportItem(
                            report: report,
                            selectedCollection: selectedCollection,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> doesCollectionExist(String collectionName) async {
    var collectionRef = FirebaseFirestore.instance.collection(collectionName);
    var docSnapshot = await collectionRef.limit(1).get();
    name = collectionName;
    return docSnapshot.docs.isNotEmpty;
  }
}

class ReportItem extends StatefulWidget {
  final QueryDocumentSnapshot report;
  final String selectedCollection;

  ReportItem({required this.report, required this.selectedCollection});

  @override
  _ReportItemState createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.report['situation']; // Set the initial value from Firestore
  }

  void _updateSituation(String? value) async {
    if (value != null) {
      setState(() {
        _selectedValue = value;
      });

      await FirebaseFirestore.instance
          .collection(widget.selectedCollection)
          .doc(widget.report.id)
          .update({'situation': value});
    }
  }

  void _deleteReport() async {
    await FirebaseFirestore.instance
        .collection(widget.selectedCollection)
        .doc(widget.report.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.report['sender'],
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.report['address'],
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.selectedCollection,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    TextButton(
                        onPressed: () {
                          print("lllllllllllll ${widget.report.id}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapPage(
                                      documentId: widget.report.id,
                                      assusise: widget.selectedCollection,
                                    )),
                          );
                        },
                        child: Text('targetlocation'))
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        widget.report['Report'],
                        style: TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteReport();
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'Not yet treated',
                    groupValue: _selectedValue,
                    onChanged: _updateSituation,
                  ),
                  Text('Not yet treated'),
                  Radio<String>(
                    value: 'In treatment',
                    groupValue: _selectedValue,
                    onChanged: _updateSituation,
                  ),
                  Text('In treatment'),
                  Radio<String>(
                    value: 'Done',
                    groupValue: _selectedValue,
                    onChanged: _updateSituation,
                  ),
                  Text('Done'),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
