import 'package:flutter/material.dart';
import 'package:final_project/screens/category_screen.dart';

class environment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Environmental Sanitation'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 183, 211, 225), // Set the background color to light blue
          
        ),
       
      ),
    );
  }
}
