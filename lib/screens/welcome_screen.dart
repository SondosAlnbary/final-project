import 'package:final_project/screens/signin_screen.dart';
import 'package:final_project/widgets/custom_scaffold.dart';
import 'package:final_project/widgets/welcome_button.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/signup_screen.dart';


class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return  CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
            child:Center(
              child:RichText(
                textAlign: TextAlign.center,
                text:const TextSpan(
                  children: [
                    // TextSpan(
                    //   text: 'Welcome\n',
                    //   style: TextStyle(
                    //     fontSize: 45.0,
                    //     fontWeight: FontWeight.w600,
                    //   )),
                    // TextSpan(
                    //   text: 
                    //   '\nEnter personal details',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //   ))
                      
                  ],
                ),
                ),
            ),
              ) ,
          ),
          const Flexible(
            flex: 1,
            child:Align(
              alignment: Alignment.bottomRight,
            
            child: Row(
              children: [
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Sign in',
                    onTap: SingnInScreen(),
                    color: Colors.transparent,
                    textColor: Colors.black,
                  ),
                  ) ,
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Sign up',
                    onTap: SignUpScreen(),
                    color: Colors.white,
                    textColor:  Colors.red,
                  ),
                  ),


              ],
            ),
            ),
            ),
        ],
      ),
    );
  }
}