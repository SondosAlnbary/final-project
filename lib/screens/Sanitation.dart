import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sanitation extends StatefulWidget {
  const Sanitation({Key? key}) : super(key: key);

  @override
  _SanitationState createState() => _SanitationState();
}

class _SanitationState extends State<Sanitation> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  String? userName;
  String? messageText;
  String? messageText1;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
        await getUserName();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserName() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(signedInUser.uid).get();
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
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sanitation'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/noeye.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Create a report',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 45, 126, 219),
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
                              return 'Enter the address';
                            }
                            if (value.length < 2) {
                              return "Username is too short.";
                            } else if (value.length > 16) {
                              return "Username is too long.";
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
                          keyboardType: TextInputType.emailAddress,
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
                          height: 8.0,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const SizedBox(
                          width: double.infinity,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _firestore.collection('Sanitation').add({
                  'sender': signedInUser.email,
                  'name': userName,
                  'address': messageText1,
                  'Report': messageText,
                });
                _showSnackbar(context, 'Report received');
              },
             child: Text('send',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 255, 255, 255)
              ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'camera_screen.dart'; // Import the camera screen

// class Sanitation extends StatefulWidget {
//   const Sanitation({Key? key}) : super(key: key);

//   @override
//   _SanitationState createState() => _SanitationState();
// }

// class _SanitationState extends State<Sanitation> {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   late User signedInUser;
//   String? userName;
//   String? messageText;
//   String? messageText1;
//   String? imagePath; // To store the path of the captured image

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   void getCurrentUser() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         signedInUser = user;
//         print(signedInUser.email);
//         await getUserName();
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> getUserName() async {
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection('user').doc(signedInUser.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           userName = userDoc['name'];
//         });
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sanitation'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/noeye.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             const Expanded(
//               flex: 1,
//               child: SizedBox(
//                 height: 10,
//               ),
//             ),
//             Expanded(
//               flex: 7,
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
//                 decoration: const BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40.0),
//                     topRight: Radius.circular(40.0),
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Create a report',
//                           style: TextStyle(
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.w900,
//                             color: Color.fromARGB(255, 255, 255, 255),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 40.0,
//                         ),
//                         TextFormField(
//                           onChanged: (value) {
//                             messageText1 = value;
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Enter the address';
//                             }
//                             if (value.length < 2) {
//                               return "Address is too short.";
//                             } else if (value.length > 16) {
//                               return "Address is too long.";
//                             } else {
//                               return null;
//                             }
//                           },
//                           decoration: InputDecoration(
//                             labelText: 'Address',
//                             hintText: 'Enter Address',
//                             hintStyle: const TextStyle(
//                               color: Colors.black26,
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.black12,
//                               ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.black12,
//                               ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           keyboardType: TextInputType.streetAddress,
//                           autocorrect: false,
//                           textCapitalization: TextCapitalization.words,
//                         ),
//                         const SizedBox(
//                           height: 25.0,
//                         ),
//                         TextFormField(
//                           onChanged: (value) {
//                             messageText = value;
//                           },
//                           maxLines: 5,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a description';
//                             } else {
//                               return null;
//                             }
//                           },
//                           decoration: InputDecoration(
//                             labelText: 'Defect description',
//                             hintText: 'Enter a description',
//                             hintStyle: const TextStyle(
//                               color: Colors.black26,
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.black12,
//                               ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                 color: Colors.black12,
//                               ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 25.0,
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             // Navigate to the CameraScreen
//                             final result = await Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => CameraScreen()),
//                             );
//                             if (result != null) {
//                               setState(() {
//                                 imagePath = result;
//                               });
//                             }
//                           },
//                           child: Text('Take Photo'),
//                         ),
//                         const SizedBox(
//                           height: 25.0,
//                         ),
//                         imagePath != null
//                             ? Image.file(File(imagePath!))
//                             : Container(),
//                         const SizedBox(
//                           height: 30.0,
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             _firestore.collection('Sanitation').add({
//                               'sender': signedInUser.email,
//                               'name': userName,
//                               'address': messageText1,
//                               'Report': messageText,
//                               'imagePath': imagePath, // Save the image path
//                             });
//                           },
//                           child: Text(
//                             'Send',
//                             style: TextStyle(
//                               color: Color.fromARGB(255, 58, 112, 183),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


