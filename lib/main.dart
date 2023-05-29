import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'screen/Homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AnimatedSplashScreen(
          splash: Image.asset('assets/Untitled design.gif',fit: BoxFit.contain,),
          nextScreen: const TodoApp(),
        duration: 5000,

        splashIconSize: double.infinity,
        backgroundColor: Colors.black,
        // disableNavigation: true,
        centered: true,



      ),
    );
  }
}
