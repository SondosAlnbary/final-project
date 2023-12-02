import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/signin_screen.dart';
import 'package:final_project/widgets/custom_scaffold.dart';

final _firebase = FirebaseAuth.instance;

class AdminSignUp extends StatefulWidget {
  const AdminSignUp({super.key});

  @override
  State<AdminSignUp> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<AdminSignUp> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;

 //Add controllers for email, full name, and password
   TextEditingController _emailController = TextEditingController();
   TextEditingController _fullNameController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();

var _enteredFullName='';
var _enteredEmail='';
var _enteredPassword='';
var _isEmailTaken = false; // Variable to track if the email is already taken

Future<void> _submit() async{
  final isValid= _formSignupKey.currentState!.validate();

if(!isValid){
  return;
  }
  _formSignupKey.currentState!.save();

  if(agreePersonalData){
//log users in 
}else{
  try{
     // Check if the email already exists
        if (await isEmailTaken(_enteredEmail)) {
           setState(() {
            _isEmailTaken = true;
          });
          showSnackBar('This email is already in use. Please use another email.');
          
        } else {
    final userCredentials =await _firebase.createUserWithEmailAndPassword(
    email: _enteredEmail,
     password: _enteredPassword
     );
    print(userCredentials);
        }
  }on FirebaseAuthException catch (error){
    if(error.code == 'email-already-in-use'){
      setState(() {
            _isEmailTaken = true;
          });
    // Handle email already in use error
        showSnackBar('This email is already in use. Please use another email.');
        } else {
          // Handle other authentication errors
          showSnackBar(error.message ?? 'Authentication failed!');
    }
  }
}
}
    // Function to show a SnackBar with a given message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 60, 103, 124), 
                         ),
                      ),
                  
                      const SizedBox(
                        height: 40.0,
                      ),
                      // full name
                      TextFormField(
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        onSaved: (value){
                          _enteredFullName=value!;
                        },
                        decoration: InputDecoration(
                          label: const Text('Full Name'),
                          hintText: 'Enter Full Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType:TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                    
                          return null;
                        },
                        
                        onSaved: (value){
                          _enteredEmail=value!;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',

                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
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
                        height: 8.0, // Adjust the spacing based on your design
                      ),
                      // Display message if email is already taken
                      Text(
                        _isEmailTaken ? 'This email is already in use. Please use another email.' : '',
                        style: TextStyle(
                          color: Colors.red, // Change the color as needed
                        ),
                      ),

                      const SizedBox(
                        height: 5.0,
                      ),
                      
                      // password
 /////////////////////////////////////////////////////////////////////////////////                     
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        onSaved: (value){
                          _enteredPassword=value!;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // i agree to the processing
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                           activeColor: Color.fromARGB(255, 60, 103, 124),
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                           
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                                String fullName = _fullNameController.text;
                                String email = _emailController.text;
                                 String password = _passwordController.text;
                                await registerUser(fullName,email,password);
                       
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')),
                              );
                            } 
                          },
                          
                          child: const Text('Sign up'),
                        ),
                      ),
                     

                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up divider
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
                      // sign up social media logo
                      
                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SingnInScreen(),
                                ),
                              );
                            },
                            
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
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
        ],
      ),
    );
  }

// Function to check if the email is already taken
  Future<bool> isEmailTaken(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('Adminuser');
    QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).get();

    return querySnapshot.docs.isNotEmpty;
  }


  Future<void> registerUser(String fullName, String email, String password) async {
  try {
    // Create user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user data to Firestore
    await FirebaseFirestore.instance.collection('Adminuser').doc(userCredential.user!.uid).set({
      'name': fullName,
      'email': email,
      'password':password,

      // Add other user-related data as needed
    });

    print('User registered successfully!');
  } catch (e) {
    print('Error registering user: $e');
  }
}
}