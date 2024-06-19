
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
                              'road','lighting','safety','Utilities','transportation'
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
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 135, 164, 176),
        child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView( 
        scrollDirection: Axis.horizontal,
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
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 18),
                    ),
                );
              }).toList(),
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

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
                  return Center(child: Text(
                    'No reports available.',
                    style: TextStyle(fontSize: 18),));
                }

                final reports = snapshot.data!.docs.reversed.toList();

                             return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          var report = reports[index];
                          return ReportItem(
                            report: report,
                            selectedCollection: selectedCollection,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.report['sender'],
              style: TextStyle(fontSize: 16), // Increase text size here
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.report['address'],
                  style: TextStyle(fontSize: 16), // Increase text size here
                ),
              ),
              Text(
                widget.selectedCollection,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Increase text size here
              ),
            ],
          ),
          trailing: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.report['Report'],
              style: TextStyle(fontSize: 14), // Increase text size here
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: 'Option 1',
              groupValue: _selectedValue,
              onChanged: (String? value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            Text('Not yet treated'),
            Radio<String>(
              value: 'Option 2',
              groupValue: _selectedValue,
              onChanged: (String? value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            Text('In treatment'),
            Radio<String>(
              value: 'Option 3',
              groupValue: _selectedValue,
              onChanged: (String? value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            Text('Done'),
          ],
        ),
        Divider(),
      ],
    );
  }
}