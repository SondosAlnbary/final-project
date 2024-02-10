import 'package:flutter/material.dart';
import 'package:final_project/screens/category_screen.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
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
            children: [
              Text(
                'Welcome, User!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Recent Reports:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // replace with actual report count
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.report),
                      title: Text('Report ${index + 1} title'),
                      subtitle: Text('Report ${index + 1} description'),
                      trailing: Text('${index + 1} min ago'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
