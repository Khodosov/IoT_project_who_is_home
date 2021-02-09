import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/home_alone.jpg'),
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
                    onPressed: null,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Center(child: Text('Войти',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        )
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: FlatButton(
                    onPressed: null,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: Center(child: Text('Зарегистрироваться',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )
                      ),
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}