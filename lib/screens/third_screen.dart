import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:final_project/screens/welcome_screen.dart';
import 'package:final_project/screens/signin_screen.dart';
import 'package:final_project/screens/Admin_signin.dart';
import 'package:final_project/screens/Admin_signup.dart';
import 'package:final_project/screens/signup_screen.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formSignInKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Set this property to false to remove the back arrow
      ),
      extendBodyBehindAppBar: true,
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
              const Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sign up as',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 60, 103, 124),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle the first button press
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpScreen()), // Replace NextScreen with the actual screen you want to navigate to
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50), // Set the minimum width
                            ),
                            child: Text('Reporter'),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          // sign up divider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          // sign up social media logo

                          const SizedBox(
                            height: 25.0,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle the second button press
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AdminSignUp()), // Replace NextScreen with the actual screen you want to navigate to
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50), // Set the minimum width
                            ),
                            child: Text('Admin'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
