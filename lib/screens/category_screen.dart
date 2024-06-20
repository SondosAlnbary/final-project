
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'welcome_screen.dart';
import 'ContactUs.dart';
import 'Account.dart';
import 'Sanitation.dart';
import 'enviroment.dart';
import 'garden.dart';
import 'lighting.dart';
import 'road.dart';
import 'safety.dart';
import 'transportation.dart';
import 'utilities.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    CategoryListScreen(),
    ContactUsScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _screens[_selectedIndex],
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
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 223, 160, 104),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Color.fromARGB(255, 91, 109, 132), 
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryListScreen extends StatelessWidget {
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

    return Stack(
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
                  switch (category.name) {
                    case 'Sanitation':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Sanitation()),
                      );
                      break;
                    case 'Garden Maintenance':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Garden()),
                      );
                      break;
                    case 'Lighting Maintenance':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => lighting()),
                      );
                      break;
                    case 'Road Maintenance':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Road()),
                      );
                      break;
                    case 'Environmental Sanitation':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => enviroment()),
                      );
                      break;
                    case 'Safety and Security':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => safety()),
                      );
                      break;
                    case 'Utilities':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Utilities()),
                      );
                      break;
                    case 'Transportation':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => transportation()),
                      );
                      break;
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
            Icon(
              category.icon,
              size: 30.0,
              color: Color.fromARGB(255, 69, 108, 140),
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
