 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/utilities.dart';
import 'welcome_screen.dart';

class ReportListScreen extends StatefulWidget {
  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  List<String> collections = ['Sanitation', 'environment','garden',
                              'road','lighting','safety','Utilities','transportation']; // Add your collection names here

  String selectedCollection = 'Sanitation'; // Initial collection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report List'),
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
        ],
      ),
      body: Container(
        color: Colors.blueGrey[100], // Set the background color here
        child: Column(
          children: [
            DropdownButton(
              value: selectedCollection,
              onChanged: (String? newValue) async {
                bool exists= await doesCollectionExist(newValue!);
                setState(() {
                  selectedCollection =exists? newValue:'Sanitation';
                });
              },
              items: collections.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(selectedCollection).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
                  return Center(child: Text('No reports available.'));
                }

                final reports = snapshot.data!.docs.reversed.toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      var report = reports[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(report['sender']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(report['address']),
                                Text(selectedCollection, style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            trailing: Text(report['Report']),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ); 
  }
  Future<bool> doesCollectionExist(String collectionName) async {
    var collectionRef = FirebaseFirestore.instance.collection(collectionName);
    var docSnapshot = await collectionRef.limit(1).get();
    return docSnapshot.docs.isNotEmpty;
  }
}
