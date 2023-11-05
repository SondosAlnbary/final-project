import 'package:final_project/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';


class SingnUpScreen extends StatefulWidget{
  const SingnUpScreen({super.key});

  @override
  State<SingnUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SingnUpScreen>{
@override
Widget build(BuildContext context){
  return const CustomScaffold(
    child:  Text('Sign up'),

  );
} 
}