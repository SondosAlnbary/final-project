// import 'package:final_project/screens/Sanitation.dart';
// import 'package:flutter/material.dart';
// import 'package:final_project/screens/category_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';

// class AccountScreen extends StatefulWidget {
//   const AccountScreen({Key? key}) : super(key: key);

//   @override
//   _AccountState createState() => _AccountState();
// }

// class _AccountState extends State<AccountScreen> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   late User signedInUser;
//   String? messageText;
//   String? messageText1;
//   String selectedCollection = "reports"; // Assuming a default collection name

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   void getCurrentUser() {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         signedInUser = user;
//         print(signedInUser.email);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// void getMessages() async{
//   final Sanitation = await _firestore.collection('Sanitation').get();
//   for(var message in Sanitation.docs){
    
//   }
// }
 


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // Remove the back button
       
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/noeye.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Welcome, User!',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Recent Reports:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection(selectedCollection)
//                           .where('sender', isNotEqualTo: '')
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         }

//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return Center(
//                             child: Text(
//                               'No reports available.',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           );
//                         }

//                         final reports = snapshot.data!.docs.reversed.toList();

//                         return ListView.builder(
//                           itemCount: reports.length,
//                           itemBuilder: (context, index) {
//                             var report = reports[index];
//                             return ListTile(
//                               leading: Icon(Icons.report),
//                               title: Text(report['title'] ?? 'No title'),
//                               subtitle: Text(report['description'] ?? 'No description'),
//                               trailing: Text('Time info here'), // Replace with actual time info
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? signedInUser;
  String? email;
 List<String> collections = [
    'Sanitation', 'environment', 'garden', 'road', 'lighting', 'safety', 'Utilities', 'transportation'
  ];
  Map<String, List<QueryDocumentSnapshot>> reportsByCollection = {};

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
        await getUserName();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserName() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(signedInUser!.uid).get();
      if (userDoc.exists) {
        setState(() {
          email = userDoc['name'];
        });

        print(email);
        fetchReportsForUser(email!); // Fetch reports after getting the username
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchReportsForUser(String email) async {
    Map<String, List<QueryDocumentSnapshot>> fetchedReportsByCollection = {};

    for (String collection in collections) {
      try {
        final querySnapshot = await _firestore
            .collection(collection)
            .where('email', isEqualTo: email)
            .get();

        fetchedReportsByCollection[collection] = querySnapshot.docs;
      } catch (e) {
        print('Error fetching reports from collection $collection: $e');
      }
    }

    setState(() {
      reportsByCollection = fetchedReportsByCollection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/noeye.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email != null
                      ? 'Welcome, $email!'
                      : 'Welcome, loading...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Your reports:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: reportsByCollection.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: () async {
                            await fetchReportsForUser(email!);
                          },
                          child: ListView.builder(
                            itemCount: reportsByCollection.length,
                            itemBuilder: (context, index) {
                              String collection = reportsByCollection.keys.elementAt(index);
                              List<QueryDocumentSnapshot> reports = reportsByCollection[collection]!;
                              return ExpansionTile(
                                title: Text(collection),
                                children: reports.map((report) {
                                  return ListTile(
                                    leading: Icon(Icons.report),
                                    title: Text(report['title'] ?? 'No title'),
                                    subtitle: Text(report['description'] ?? 'No description'),
                                    trailing: Text((report['timestamp'] as Timestamp).toDate().toString() ?? 'No time info'), // Replace with actual time info if available
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
          
        ),
        
      ),
    );
  }
}
