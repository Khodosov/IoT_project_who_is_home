import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/pages/sign_in.dart';
import 'package:who_is_home/pages/sign_up.dart';
import 'package:who_is_home/push_notifications/firebase_messaging_custom.dart';


class StartMenuPage extends StatefulWidget {
  @override
  _StartMenuPageState createState() => _StartMenuPageState();
}

class _StartMenuPageState extends State<StartMenuPage> {

  void _callback(int amount) {
    setState(() {});
  }

  void saveFCMToken(String fcmToken) async {
    final directory = await getApplicationDocumentsDirectory();
    final File tokenFile = File('${directory.path}/fcmtoken.json');
    String jsonUser =
        '{"fcm_token": "$fcmToken"}';
    tokenFile.writeAsString(jsonUser);
    print('FCM_TOKEN : $fcmToken');
  }

  @override
  void initState() {
    FirebaseMessagingServiceProvider().fcmToken()
        .then((token) => saveFCMToken(token));
    FirebaseMessagingServiceProvider.callback ??= _callback;

    // the code near this line in initState() is possibly useless =============
    Firebase.initializeApp().whenComplete(() {
      print("FIREBASE INITIALIZATION COMPLETED");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Image.asset('assets/images/tempLogojpg.jpg'),
          ),
          SizedBox(
            width: 15,
            height: 15,
          ),
          SizedBox(
            width: 15,
            height: 15,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          )),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: Text(
                            'Зарегистрироваться',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          )),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}