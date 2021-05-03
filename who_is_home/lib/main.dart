import 'package:flutter/material.dart';
import 'package:who_is_home/pages/start_splash_screen.dart';

// vapid key: BNEZLRS7baD5qDrOaFCTo5EIstA-p19nENsS6wWLFvYyGFE7VksjlwX3cyAIx6lVRvMrLpkUYpiFoFmphVTHBZs

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Who is home?',
    theme: ThemeData(),
    home: SplashScreen(),
  ));
}



