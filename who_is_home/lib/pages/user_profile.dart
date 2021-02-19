import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_home/main.dart';
import 'package:who_is_home/pages/user_profile_settings.dart';

class userProfilePage extends StatefulWidget {
  @override
  _userProfilePageState createState() => _userProfilePageState();
}

class _userProfilePageState extends State<userProfilePage> {
  String _name;
  bool _visibleProgress = false, _roomFree = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Профиль',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                                )),
                            IconButton(
                                color: Colors.lightBlue,
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              userProfileSettingsPage()));
                                })
                          ],
                        ),
                        IconButton(
                            color: Colors.white,
                            icon: Icon(
                              Icons.sensor_door_outlined,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyApp()));
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Card(
                      color: _roomFree ? Colors.green[400] : Colors.red[400],
                      elevation: 15,
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        child: Center(
                            child: Text(
                              _roomFree ? 'Свободно' : 'Занято',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            )),
                      ),
                    ),
                  ),
                  Container(
                    height: 240,
                    color: Colors.grey[200],
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // TODO: Это уродство тут временно. Нужно что-то придумать с дизайном. ИСПРАВЛЯТЬ В ПОСЛЕДНЮЮ ОЧЕРЕДЬ!
                        //  Пока оставлю.
                        // TODO: Сюда передавать готовый список соседей. Его формировать в отдельтном методе, который вызывается в setState(). Список формируется после получения инфы с сервера
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.transparent.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name1'),
                                Text(!_roomFree ? 'Дома' : 'Не дома')
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.transparent.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name2'),
                                Text(!_roomFree ? 'Дома' : 'Не дома')
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.transparent.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name3'),
                                Text(!_roomFree ? 'Дома' : 'Не дома')
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.transparent.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name4'),
                                Text(!_roomFree ? 'Дома' : 'Не дома')
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            color: Colors.transparent.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name5'),
                                Text(!_roomFree ? 'Дома' : 'Не дома')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                userProfileSettingsPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.transparent.withOpacity(0.2),
                      child: Center(
                        child: Container(
                          height: 50,
                          child: Column(
                            children: [
                              Text('Добавить соседа'),
                              Icon(Icons.add),
                            ],
                          ),
                        ),
                      ),

                    ),
                  )),
            ],
          ),
          Visibility(
            visible: _visibleProgress,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                child: Image.asset('assets/images/guard_unlocked.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
