
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'welcome_screen.dart';

// class AccountScreen extends StatefulWidget {
//   @override
//   _AccountState createState() => _AccountState();
// }

// class _AccountState extends State<AccountScreen> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   User? signedInUser;
//   String? email;
//   List<String> collections = [
//     'Sanitation', 'environment', 'garden', 'road', 'lighting', 'safety', 'Utilities', 'transportation'
//   ]; // Add your collection names here

//   List<QueryDocumentSnapshot> allReports = [];

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   Future<void> getCurrentUser() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         signedInUser = user;
//         await getUserName();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> getUserName() async {
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection('user').doc(signedInUser!.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           email = userDoc['email'];
//         });

//         print(email);
//         await fetchReportsForUser(email!); // Fetch reports after getting the username
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> fetchReportsForUser(String email) async {
//     List<QueryDocumentSnapshot> reports = [];

//     for (String collection in collections) {
//       QuerySnapshot snapshot = await _firestore.collection(collection).where('sender', isEqualTo: email).get();
//       reports.addAll(snapshot.docs);
//       print(reports);
//     }

//     setState(() {
//       allReports = reports;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/noeye.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     email ?? 'Loading...',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: allReports.isEmpty
//                       ? Center(
//                           child: Text(
//                             'No reports available.',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.only(bottom: 20.0),
//                           itemCount: allReports.length,
//                           itemBuilder: (context, index) {
//                             var report = allReports[index];
//                             return ReportItem(
//                               report: report,
//                               selectedCollection: getCollectionName(report.reference.path),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String getCollectionName(String path) {
//     return path.split('/').first;
//   }
// }

// class ReportItem extends StatefulWidget {
//   final QueryDocumentSnapshot report;
//   final String selectedCollection;

//   ReportItem({required this.report, required this.selectedCollection});

//   @override
//   _ReportItemState createState() => _ReportItemState();
// }

// class _ReportItemState extends State<ReportItem> {
//   String? _selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               ListTile(
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.report['address'],
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     Text(
//                       widget.selectedCollection,
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     ),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: 150),
//                       child: Text(
//                         widget.report['Report'],
//                         style: TextStyle(fontSize: 14),
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'welcome_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? signedInUser;
  String? email;
  String? username; // Added username field
  List<String> collections = [
    'Sanitation', 'environment', 'garden', 'road', 'lighting', 'safety', 'Utilities', 'transportation'
  ]; // Add your collection names here

  List<QueryDocumentSnapshot> allReports = [];

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
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(signedInUser!.uid).get();
      if (userDoc.exists) {
        setState(() {
          email = userDoc['email'];
          username = userDoc['name']; // Assuming the field name in Firestore is 'name'
        });

        print('Email: $email, Username: $username');
        await fetchReportsForUser(email!); // Fetch reports after getting the user details
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchReportsForUser(String email) async {
    List<QueryDocumentSnapshot> reports = [];

    for (String collection in collections) {
      QuerySnapshot snapshot = await _firestore.collection(collection).where('sender', isEqualTo: email).get();
      reports.addAll(snapshot.docs);
      print(reports);
    }

    setState(() {
      allReports = reports;
    });
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
                  child: Text(
                    'Hello ${username ?? 'Loading...'}', // Greeting with the username
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: allReports.isEmpty
                      ? Center(
                          child: Text(
                            'No reports available.',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 20.0),
                          itemCount: allReports.length,
                          itemBuilder: (context, index) {
                            var report = allReports[index];
                            return ReportItem(
                              report: report,
                              selectedCollection: getCollectionName(report.reference.path),
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
                      widget.report['address'],
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.selectedCollection,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
