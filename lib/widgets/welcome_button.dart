import 'package:flutter/material.dart';
import 'package:final_project/screens/signup_screen.dart';
import 'package:final_project/screens/signin_screen.dart'; // Import your sign-in screen here

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    Key? key,
    this.buttonText,
    this.onTap,
    this.color,
    this.textColor,
  }) : super(key: key);

  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => onTap!,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: color!,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: textColor!,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WelcomeButton(
              buttonText: 'Sign In',
              onTap: SignUpScreen(), // Replace with your actual sign-in screen
              color: Colors.blue,
              textColor: Colors.white,
            ),
            WelcomeButton(
              buttonText: 'Sign Up',
              onTap: SignUpScreen(), // Replace with your actual sign-up screen
              color: Colors.green,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
