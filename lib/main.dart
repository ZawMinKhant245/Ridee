
import 'package:firstapp1/homeScreen.dart';
import 'package:firstapp1/onborading_test/into_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());  //add object in the blacket
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const IntroScreen(),
    );
  }
}
