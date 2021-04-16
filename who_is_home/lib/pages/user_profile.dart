import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/main.dart';
import 'package:who_is_home/pages/user_profile_settings.dart';
import 'package:who_is_home/data.dart';

import '../includes.dart';

class userProfilePage extends StatefulWidget {
  @override
  _userProfilePageState createState() => _userProfilePageState();
}

class _userProfilePageState extends State<userProfilePage>
    with TickerProviderStateMixin {
  AnimationController controller;
  String _email, _password, _id;
  String jsonUser =
      '{\n  "id" : "",\n  "email" : "",\n  "password" : "",\n  "is_in_home" : ""\n}';
  String jsonNeighbours =
      '{\n  "neighbours": [\n   {\n     "email": "kek",\n     "is_in_home": "false"\n   },\n  ]\n}';

  bool _visibleProgress = true,
      _addNeighbor = false,
      _is_in_home = false,
      _is_in_home_temp = false,
      _showNeighbours = false;

  List<bool> _roommatesCurrentStateList = [];
  bool  _roomIsFree = false;
  List _neighboursInfo = [];

  String _url = 'http://lemonl1me.pythonanywhere.com';
  // Fetch content from the json file =========================================

  // TODO: функции, отвечающие за формирование списка соседей НЕ реализованы. Необходимо их исправить, а после начать работу с http.
  Future<void> fetchJsonNeighbours() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "accept": "application/json"
    };
    Response response = await get(Uri.parse("$_url/neighbours"), headers: headers);
    int statusCode = response.statusCode;
    print('FETCHING NEIGHBOURS DATA STATUS CODE : ' + response.statusCode.toString());
    jsonNeighbours = response.body;
    print(jsonNeighbours);
    Map<String, dynamic> data = jsonDecode(jsonNeighbours);
    setState(() {
      print('Файл JSON neighboursdata.json' + data.toString());
      _neighboursInfo = data["neighbours"];
      print(_neighboursInfo);
    });
  }

  List<Widget> neighboursListReadJson() {
    List<Widget> result = [];
    for (int index = 0; index < _neighboursInfo.length; index++){
      if (_neighboursInfo[index]["is_in_home"]){
        _roommatesCurrentStateList.add(false);
        _roomIsFree = false;
      }else {_roommatesCurrentStateList.add(true);}
    }
    if (_neighboursInfo != null) {
      for (int index = 0; index < _neighboursInfo.length; index++) {
        result.add(Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 50,
            width: double.infinity,
            color: _roommatesCurrentStateList[index] ? Colors.green[400] : Colors.red[400],
            child: ListTile(
              title: Text(_neighboursInfo[index]["is_in_home"] ? 'Дома' : 'Не дома'),
              subtitle: Text(_neighboursInfo[index]["name"]),
            ),
          ),
        ));
      }
    }
    return result;
  }

  // This function can read local files from device.
  void readJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    if (await userFile.exists()) {
      jsonUser = await userFile.readAsString();
    } else {
      userFile.writeAsString(jsonUser);
    }
    Map<String, dynamic> data = jsonDecode(jsonUser);
    if (data["is_in_home"].compareTo('false') == 0) {
      _is_in_home_temp = false;
    } else {
      _is_in_home_temp = true;
    }
    setState(() {
      _email = data["email"];
      _password = data["password"];
      _id = data["id"];
      _is_in_home = _is_in_home_temp;
    });
    // Reading neighbours list.
    final File neighboursFile = File('${directory.path}/neighbours.json');
    if (await neighboursFile.exists()) {
      jsonNeighbours = await neighboursFile.readAsString();
    } else {
      neighboursFile.writeAsString(jsonNeighbours);
    }
    _visibleProgress = false;
  }

  void deleteDataJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    userFile.writeAsString(
        '{\n  "id" : "",\n  "email" : "",\n  "password" : "",\n  "is_in_home" : ""\n}');
  }

  @override
  void initState() {
    // Code for Circular Progress
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    readJSON();
    fetchJsonNeighbours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _visibleProgress
          ? Visibility(
              child: CircularProgressIndicator(
              value: controller.value,
            ))
          : Stack(
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
                                        _email,
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
                                    deleteDataJSON();
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
                              color: _roomIsFree ? Colors.green : Colors.red,
                            ),
                            width: double.infinity,
                            height: 500,
                            child: Center(
                                child: Text(
                                  _roomIsFree ? 'Свободно' : 'Занято',
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
                            child: TextButton(
                                onPressed: () {
                                  readJSON();
                                  print(_neighboursInfo);
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
                            child: TextButton(
                                onPressed: () {
                                  // TODO: Сделать отправку на сервер сообщение об изменении состояния пользователя.
                                  setState(() {});
                                },
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(
                                      child: Text(
                                        _roomIsFree ? 'Вернулся' : 'Ухожу',
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

  Widget greyBackground() {
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
                      child: Text(
                        'Ваши соседи',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.cancel_outlined),
                        onPressed: () {
                          setState(() {
                            _showNeighbours = !_showNeighbours;
                          });
                        }),
                  ],
                ),
                // TODO: Это уродство тут временно. Нужно что-то придумать с дизайном. ИСПРАВЛЯТЬ В ПОСЛЕДНЮЮ ОЧЕРЕДЬ!
                //  Пока оставлю.
                // TODO: Сюда передавать готовый список соседей. Его формировать в отдельтном методе, который вызывается в setState(). Список формируется после получения инфы с сервера
                Column(
                  children: neighboursListReadJson(),
                ),
                Stack(
                  children: [
                    addNeighbour(),
                    Visibility(
                      visible: !_addNeighbor,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        child: TextButton(
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
                              )),
                            )),
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
                    label: 'Почта вашего соседа', hint: 'Введите почту'),
                onSaved: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
            TextButton(
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
