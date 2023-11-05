import 'package:final_project/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';


class SingnInScreen extends StatefulWidget{
  const SingnInScreen({super.key});

  @override
  State<SingnInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SingnInScreen>{
@override
Widget build(BuildContext context){
  return const CustomScaffold(
    child:  Text('Sign in'),

  );
} 
}