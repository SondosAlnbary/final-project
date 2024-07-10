import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final String phoneNumber = '076-777-3532';
  final String email = 'contactus@municipality.com';
  final String emergencyPhoneNumber = '076-777-3532';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/noeye.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: +1-$phoneNumber',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Operating Hours:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sunday to Thursday: 9:00 AM to 5:00 PM',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Response Time: We aim to respond to fault reports within 5 business days.',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Emergency Information:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'In case of emergencies, please call:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      final phoneUri = Uri.parse('tel:$emergencyPhoneNumber');
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Could not launch $emergencyPhoneNumber')),
                        );
                      }
                    },
                    child: Text(emergencyPhoneNumber),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
