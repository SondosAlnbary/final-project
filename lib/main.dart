import 'package:final_project/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:final_project/screens/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      home:const WelcomeScreen(),
       
    );
  }
}





































// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.asset('assets/images/eye.png'), // Load the image from assets
//             ElevatedButton(
//               onPressed: () {
//                  // Navigate to the second screen when the button is pressed.
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SecondPage()),);
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (context) => SecondPage(),
//                 //   ),
//                 // );
//               },
//               child: Text('Go to Next Screen'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NextScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Next Screen'),
//       ),
//       body: Center(
//         child: Text('This is the next screen.'),
//       ),
//     );
//   }
// }



// class FirstPage extends StatelessWidget {
//   void _navigateToSecondPage(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => SecondPage(), // Navigate to the second page
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('LocalEye'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _navigateToSecondPage(context); // Call the navigation function
//           },
//           child: Text('הבא'),
          
          
//         ),
//       ),
//     );
//   }
// }





// void main(){
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         body: Container(
//           decoration:const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                  Color.fromARGB(255, 58, 13, 116),
//                  Color.fromARGB(255, 89, 16, 102),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//          child:const StartScreen(),
//         ) ,
//       ),
//     ),
//   );
// }
// class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Login Page'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => StartScreen()),
//               );
//             },
//             child: Text('Go to Home Page'),
//           ),
//         ),
//       ),
//     );
//  }
// }