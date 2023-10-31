import 'package:final_project/start_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                 Color.fromARGB(255, 58, 13, 116),
                 Color.fromARGB(255, 89, 16, 102),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
         child:const StartScreen(),
        ) ,
      ),
    ),
  );
}
// class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Displaying a Photo'),
//         ),
//         body: Center(
//           child: Image.asset('assets/1.png'),
//         ),
//       ),
//     );
//  }
// }