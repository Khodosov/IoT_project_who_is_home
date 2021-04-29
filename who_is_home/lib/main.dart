import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/pages/sign_in.dart';
import 'package:who_is_home/pages/sign_up.dart';

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Who is home?',
    theme: ThemeData(),
    home: MyApp(),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void messegingMethod() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // use the returned token to send messages to users from your custom server
    String token = await messaging.getToken(
      vapidKey:
          "BNEZLRS7baD5qDrOaFCTo5EIstA-p19nENsS6wWLFvYyGFE7VksjlwX3cyAIx6lVRvMrLpkUYpiFoFmphVTHBZs",
    );
    print('REGISTRATION TOKEN: ' + token);
  }

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("FIREBASE INITIALIZATION COMPLETED");
      // messegingMethod();
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
