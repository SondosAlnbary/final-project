import 'package:flutter/material.dart';
import 'package:final_project/screens/signin_screen.dart';


class CategoryScreen extends StatelessWidget {
    const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        ], 
      ),
    );
  }
}