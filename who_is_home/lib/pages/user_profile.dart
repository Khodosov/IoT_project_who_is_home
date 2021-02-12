import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class userProfilePage extends StatefulWidget {
  @override
  _userProfilePageState createState() => _userProfilePageState();
}

class _userProfilePageState extends State<userProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              child: Image.asset('assets/images/guard_unlocked.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Профиль',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                IconButton(
                    color: Colors.white,
                    icon: Icon(
                      Icons.sensor_door_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
