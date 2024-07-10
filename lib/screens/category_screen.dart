// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'ContactUs.dart';
import 'Account.dart';
import 'Sanitation.dart';
import 'enviroment.dart';
import 'garden.dart';
import 'lighting.dart';
import 'road.dart';
import 'safety.dart';
import 'Transportation.dart';
import 'utilities.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/noeye.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        selectedItemColor: Color.fromARGB(255, 44, 180, 210),
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 177, 87, 13),
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<CategoryInfo> categories = [
      CategoryInfo(
        name: 'Sanitation',
        icon: Icons.cleaning_services,
        imagePath: 'assets/images/sanitation.png',
      ),
      CategoryInfo(
        name: 'Garden Maintenance',
        icon: Icons.park_rounded,
        imagePath: 'assets/images/garden.png',
      ),
      CategoryInfo(
        name: 'Lighting Maintenance',
        icon: Icons.lightbulb,
        imagePath: 'assets/images/light.png',
      ),
      CategoryInfo(
        name: 'Road Maintenance',
        icon: Icons.settings,
        imagePath: 'assets/images/road.png',
      ),
      CategoryInfo(
        name: 'Environment',
        icon: Icons.eco,
        imagePath: 'assets/images/enviroment.png',
      ),
      CategoryInfo(
        name: 'Safety',
        icon: Icons.safety_check,
        imagePath: 'assets/images/safety.png',
      ),
      CategoryInfo(
        name: 'Utilities',
        icon: Icons.electric_bolt,
        imagePath: 'assets/images/utilities.png',
      ),
      CategoryInfo(
        name: 'Transportation',
        icon: Icons.emoji_transportation_sharp,
        imagePath: 'assets/images/transportation.png',
      ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Which service do you need?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return buildCategoryItem(context, categories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildCategoryItem(BuildContext context, CategoryInfo category) {
    return GestureDetector(
      onTap: () {
        switch (category.name) {
          case 'Sanitation':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SanitationState()),
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
              MaterialPageRoute(builder: (context) => Lighting()),
            );
            break;
          case 'Road Maintenance':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Road()),
            );
            break;
          case 'Environment':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Environment()),
            );
            break;
          case 'Safety':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Safety()),
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
              MaterialPageRoute(builder: (context) => Transportation()),
            );
            break;
          default:
            // Handle cases where the category does not match any known case
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (category.imagePath != null)
                Image.asset(
                  category.imagePath!,
                  width: 100.0,
                  height: 100.0,
                )
              else
                Icon(
                  category.icon,
                  size: 60.0,
                  color: const Color.fromARGB(255, 69, 108, 140),
                ),
              const SizedBox(height: 8.0),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryInfo {
  final String name;
  final IconData icon;
  final String? imagePath;

  CategoryInfo({required this.name, required this.icon, this.imagePath});
}
