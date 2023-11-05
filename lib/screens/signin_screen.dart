import 'package:final_project/widgets/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SingnInScreen extends StatefulWidget{
  const SingnInScreen({super.key});

  @override
  State<SingnInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SingnInScreen>{
  final _formSignInKey= GlobalKey<FormState>();
bool rememberPassword = true;

@override
Widget build(BuildContext context){
  return  CustomScaffold(
    child:  Column(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
          height: 10,
          ),
          ),
          Expanded(
            flex: 7,
            child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Form(
             key: _formSignInKey,
              child: Column(
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 60, 103, 124),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if(value== null || value.isEmpty){
                            return 'Please Enter Email ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      hintText: 'Enter Email',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                 //
                  const SizedBox(height: 10,),

                 TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                    validator: (value) {
                      if(value== null || value.isEmpty){
                            return 'Please Enter Password ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                const SizedBox(height: 10,),
               //
                const SizedBox(height: 20,),

               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberPassword,
                         onChanged: (bool? value){
                          setState(() {
                            rememberPassword=value!;
                          });
                         },
                         activeColor: Color.fromARGB(255, 60, 103, 124),
                         ),
                         const Text(
                          'Remember me',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                         ),
                    ],
                  ),
                ],
               ),
               GestureDetector(
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
               ),
              const SizedBox(height: 20,),
              

                ],
              ),
            ),
          ),),
      ],
    ),

  );
} 
}