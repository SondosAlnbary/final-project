import 'package:flutter/material.dart';
import 'package:final_project/screens/category_screen.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
       body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/gray.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
      child: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: contactus@municipality.com',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: +1-076-777-7777',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
           
            SizedBox(height: 20),
            Text(
              'Operating Hours:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Sundayday to Thutsday: 9:00 AM to 5:00 PM',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            
            SizedBox(height: 20),
            Text(
              'Response Time: We aim to respond to fault reports within 5 business days.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Emergency Information: In case of emergencies, please call : 076-777-3532.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
       ),
    );
  }
}


