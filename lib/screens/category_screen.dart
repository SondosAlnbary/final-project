
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'welcome_screen.dart'; // Import your welcome screen file

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
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Pick a category'),
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate to the welcome screen
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
                    return buildCategoryItem(categories[index]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(CategoryInfo category) {
    return Container(
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
                  size: 48.0,
                  color: Color.fromARGB(255, 174, 112, 64), // Customize the color of the icon
                )
              : FaIcon(
                  category.icon as IconData,
                  size: 48.0,
                  color: Color.fromARGB(255, 193, 125, 73), // Customize the color of the icon
                ),
          SizedBox(height: 8.0),
          Text(
            category.name,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class CategoryInfo {
  final String name;
  final IconData icon;

  CategoryInfo({required this.name, required this.icon});
}

