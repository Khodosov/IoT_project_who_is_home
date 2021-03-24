import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_home/main.dart';
import 'package:who_is_home/pages/user_profile_settings.dart';

import '../includes.dart';

class userProfilePage extends StatefulWidget {
  @override
  _userProfilePageState createState() => _userProfilePageState();
}

class _userProfilePageState extends State<userProfilePage> {
  String _name = 'username';
  bool _visibleProgress = false,
      _roomFree = true,
      _addNeighbor = false,
      _showNeighbours = false;

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
                                  _name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                                      builder: (context) => MyApp()));
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: _roomFree ? Colors.green : Colors.red,
                      ),
                      width: double.infinity,
                      height: 500,
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
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              _showNeighbours = !_showNeighbours;
                            });
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: Text(
                                  'Соседи',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                )),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              _roomFree = !_roomFree;
                            });
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: Text(
                                  _roomFree ? 'Вернулся' : 'Ухожу',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                )),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
          greyBackground(),
          neighbourList(),
        ],
      ),
    );
  }

  Widget greyBackground(){
    return Visibility(
      visible: _showNeighbours,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[800].withOpacity(0.7),
      ),
    );
  }

  Widget neighbourList() {
    return Center(
      child: Visibility(
        visible: _showNeighbours,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('Ваши соседи',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.cancel_outlined),
                        onPressed: () {
                          setState(() {
                            _showNeighbours = !_showNeighbours;
                          });
                    }
                    ),
                  ],
                ),

                // TODO: Это уродство тут временно. Нужно что-то придумать с дизайном. ИСПРАВЛЯТЬ В ПОСЛЕДНЮЮ ОЧЕРЕДЬ!
                //  Пока оставлю.
                // TODO: Сюда передавать готовый список соседей. Его формировать в отдельтном методе, который вызывается в setState(). Список формируется после получения инфы с сервера
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: _roomFree ? Colors.green[400] : Colors.red[400],
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
                    color: _roomFree ? Colors.green[400] : Colors.red[400],
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
                    color: _roomFree ? Colors.green[400] : Colors.red[400],
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
                    color: _roomFree ? Colors.green[400] : Colors.red[400],
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
                    color: _roomFree ? Colors.green[400] : Colors.red[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name5'),
                        Text(!_roomFree ? 'Дома' : 'Не дома')
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    addNeighbour(),
                    Visibility(
                      visible: !_addNeighbor,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _addNeighbor = !_addNeighbor;
                              });
                            },
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                  child: Text(
                                    'Добавить соседа',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  )
                              ),
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addNeighbour() {
    return Visibility(
      visible: _addNeighbor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: TextFormField(
                validator: UIComponent.emailValidate,
                decoration: UIComponent.inputDecoration(
                    label: 'Почта вашего соседа', hint: 'Введите вочту'),
                onSaved: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
            ),
            FlatButton(
                onPressed: () {
                  setState(() {
                    _addNeighbor = !_addNeighbor;
                  });
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: Text(
                        'Отправить приглашение!',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _addNeighbor = !_addNeighbor;
                    });
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                        child: Text(
                          'Отменить',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
