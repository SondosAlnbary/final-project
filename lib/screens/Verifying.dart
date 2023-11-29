import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyEmail extends StatefulWidget {
 @override
 _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 String _errorMessage = '';

 Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        setState(() {
          _errorMessage = '';
        });
        userCredential.user!.sendEmailVerification();
        await userCredential.user!.reload();
        if (userCredential.user!.emailVerified) {
          print('Email is verified');
        } else {
          print('Email is not verified');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message!;
        });
      }
    }
 }

// Future<bool> isEmailAlreadyInUse(String email) async {
//  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
//  return querySnapshot.docs.isNotEmpty;
// }



 @override
 Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Submit'),
          ),
          Text(_errorMessage),
        ],
      ),
    );
 }
}