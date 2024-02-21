import 'package:flutter/material.dart';
import 'package:final_project/screens/category_screen.dart';

class Sanitation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
       body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/noeye.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
      child: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
   
        ),
      ),
       ),
    );
  }
}


