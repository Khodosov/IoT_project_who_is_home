import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/pages/start_menu_page.dart';
import 'package:who_is_home/pages/user_profile.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAuthorized;

  Future<void> AuthorizationCheck() async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    setState(() async {
      isAuthorized = await userFile.exists();
    });
  }

  @override
  void initState() {
    super.initState();
    AuthorizationCheck();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              !isAuthorized ? StartMenuPage() : userProfilePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/sandalcrew.jpg'),
            Text(
              'WHO IS HOME?',
                style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
