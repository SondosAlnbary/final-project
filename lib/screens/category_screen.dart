import 'package:final_project/screens/enviroment.dart';
import 'package:final_project/screens/garden.dart';
import 'package:final_project/screens/lighting.dart';
import 'package:final_project/screens/road.dart';
import 'package:final_project/screens/safety.dart';
import 'package:final_project/screens/transportation.dart';
import 'package:final_project/screens/utilities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'welcome_screen.dart';
import 'ContactUs.dart';
import 'Account.dart';
import 'Sanitation.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key});


  @override
  Widget build(BuildContext context) {
    List<CategoryInfo> categories = [
      CategoryInfo(name: 'Sanitation', icon: Icons.cleaning_services),
      CategoryInfo(name: 'Garden Maintenance', icon: Icons.park_rounded),
      CategoryInfo(name: 'Lighting Maintenance', icon: FontAwesomeIcons.lightbulb),
      CategoryInfo(name: 'Road Maintenance', icon: Icons.settings),
      CategoryInfo(name: 'Environmental Sanitation', icon: Icons.eco),
      CategoryInfo(name: 'Safety and Security', icon: Icons.safety_check),
      CategoryInfo(name: 'Utilities', icon: Icons.electric_bolt),
      CategoryInfo(name: 'Transportation', icon: Icons.emoji_transportation_sharp),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Categories'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ],
      ),
    
        
      body: 
      Stack(
        children: [
          Image.asset(
            'assets/images/noeye.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Reports',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(62, 104, 156, 1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  padding: EdgeInsets.all(8.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return buildCategoryItem(context, categories[index]);
                  },
                  
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Contact Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        selectedItemColor: Colors.blue, // Customize the selected item color
        unselectedItemColor: Colors.grey, // Customize the unselected item color
        onTap: (index) {
          switch (index) {
            case 0:
              // Handle 'Reports' tab
              break;
            case 1:
              // Navigate to the 'Contact Us' screen when 'Contact Us' tab is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget buildCategoryItem(BuildContext context, CategoryInfo category) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Selected category: ${category.name}'),
              ElevatedButton(
                onPressed: () {
                  // Handle the '+' button click
                  if (category.name == 'Sanitation') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Sanitation()),
                    );
                    
                  }
                  if (category.name == 'Garden Maintenance'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Garden()),
                    );
                  }
                  if (category.name == 'Lighting Maintenance'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => lighting()),
                    );
                  }
                  if (category.name == 'Road Maintenance'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Road()),
                    );
                  }
                  if (category.name == 'Environmental Sanitation'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => enviroment()),
                    );
                  }
                   if (category.name == 'Safety and Security'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => safety()),
                    );
                  }
                   if (category.name == 'Utilities'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Utilities()),
                    );
                  }
                  if (category.name == 'Transportation'){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => transportation()),
                    );
                  }
                },
                child: Text('+'),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(255, 69, 108, 140),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            category.icon is IconData
                ? Icon(
                    category.icon as IconData,
                    size: 30.0,
                    color: Color.fromARGB(255, 69, 108, 140),
                  )
                : FaIcon(
                    category.icon as IconData,
                    size: 30.0,
                    color: Color.fromARGB(255, 193, 125, 73),
                  ),
            SizedBox(height: 8.0),
            Text(
              category.name,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryInfo {
  final String name;
  final IconData icon;

  CategoryInfo({required this.name, required this.icon});
}
