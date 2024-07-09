// ignore_for_file: unused_local_variable, library_private_types_in_public_api, prefer_final_fields, avoid_print, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:io';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  bool x = false;
  List<String> downloadUrls = [];
  List<File> _images = [];
  int? selectedImage;

  final _formKey = GlobalKey<FormState>(); // Added Global Key

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  Future<void> _uploadImagesToFirebaseStorage() async {
    print('This is my best rrrdocument $documents');
    for (int i = 0; i < _images.length; i++) {
      try {
        File imageFile = _images[i];
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/$documents/$fileName.jpg');

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageReference.putFile(imageFile);

        // Wait for the upload task to complete and fetch the download URL
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Print the download URL for the uploaded image
        // print('Download URL for Image $i: $k');
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
      // If the form is not valid, display a message and return.
      _showSnackbar(context, 'Please fill out all fields.');
      return;
    }

    try {
      DocumentReference docRef = await _firestore.collection('Utilities').add({
        'sender': signedInUser.email,
        'name': userName,
        'address': messageText1,
        'Report': messageText,
        'situation': 'Not treated yet',
        'Emergency': isEmergency ? 'yes' : 'no'
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
      _uploadImagesToFirebaseStorage();
      if (isEmergency) {
        // Update the Emergency field to "yes"
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
                      key: _formKey, // Added Global Key
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
                          TextButton(
                            onPressed: () {
                              _sendReport(isEmergency: false);
                            },
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          //////////////////////////
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  x = true;

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
                            style: ElevatedButton.styleFrom(
                              // primary: Colors.teal,
                              side: const BorderSide(
                                  color: Color.fromARGB(121, 0, 0, 0),
                                  width: 2.0),
                              minimumSize: const Size(40, 40),
                            ),
                            child: const Text(
                              'Add photo',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // SizedBox(height: 20),
                          Container(
                            height: x ? 300 : 10,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                _images.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    //width: 150, // Set the desired width
                                    height: 90, // Set the desired height
                                    child: TextButton(
                                      onPressed: () {},
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.delete),
                                                  title: const Text(
                                                      'delete photo'),
                                                  onTap: () {
                                                    setState(() {
                                                      x = false;
                                                      if (_images.isNotEmpty) {
                                                        _images.removeAt(
                                                            index); // Remove the image at the given
                                                      }
                                                    });
                                                    Navigator.pop(
                                                        context); // Close the bottom sheet
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.cancel),
                                                  title: const Text('Cancel'),
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context); // Close the bottom sheet
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Image.file(
                                        _images[index],
                                        fit: BoxFit
                                            .contain, // Adjust the fit as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //////////////////////////
                          TextButton(
                            onPressed: () {
                              _sendReport(isEmergency: true);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Emergency',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
