import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:who_is_home/pages/sign_in.dart';
import 'package:who_is_home/pages/sign_up.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Who is home?',
      theme: ThemeData(
        primarySwatch: Colors.primaryBlack,
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()
                          ));
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
                child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()
                          ));
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(40)
                      ),
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
