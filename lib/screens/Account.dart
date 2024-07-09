// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? signedInUser;
  String? email;
  String? username;
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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        await getUserDetails();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserDetails() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(signedInUser!.uid).get();
      if (userDoc.exists) {
        setState(() {
          email = userDoc['email'];
          username = userDoc['name'];
        });

        print('Email: $email, Username: $username');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchReportsForUser() async {
    List<QueryDocumentSnapshot> reports = [];

    if (email != null) {
      for (String collection in collections) {
        try {
          QuerySnapshot snapshot = await _firestore
              .collection(collection)
              .where('sender', isEqualTo: email)
              .get();
          reports.addAll(snapshot.docs);
        } catch (e) {
          print(e);
        }
      }
    }

    return reports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Hello ${username ?? 'Loading...'}', // Greeting with the username
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<QueryDocumentSnapshot>>(
                    future: fetchReportsForUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No reports available.',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      final allReports = snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 20.0),
                        itemCount: allReports.length,
                        itemBuilder: (context, index) {
                          var report = allReports[index];
                          return ReportItem(
                            report: report,
                            selectedCollection:
                                getCollectionName(report.reference.path),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getCollectionName(String path) {
    return path.split('/').first;
  }
}

class ReportItem extends StatelessWidget {
  final QueryDocumentSnapshot report;
  final String selectedCollection;

  ReportItem({required this.report, required this.selectedCollection});

  @override
  Widget build(BuildContext context) {
    String situation = report['situation'] ?? 'Unknown';

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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report['address'],
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      selectedCollection,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Situation: $situation', // Display the "situation" field
                      style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        report['Report'],
                        style: TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
