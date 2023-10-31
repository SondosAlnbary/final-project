import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget{
  const StartScreen({super.key});

 @override
  Widget build(BuildContext context){
    return  Scaffold(
      body: Center(
        child: Image.asset('assets/images/eye.png'),
      ),
    );
       
  }
}



//   @override
//   Widget build(contex){
//     return  Center(
//       child: Column(children: [
//        Image.asset('assets/images/quiz-logo.png'),
//        ],
//        );
       
//   }
// }