import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/main.dart';
import 'package:who_is_home/pages/start_menu_page.dart';
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
  String _email, _password, _device_id, is_in_home_str;
  String jsonUser =
      '{\n  "device_id" : "",\n  "email" : "",\n  "password" : "",\n  "is_in_home" : ""\n}';
  String jsonNeighbours =
      '{\n  "neighbours": [\n   {\n     "email": "kek",\n     "is_in_home": "false"\n   },\n  ]\n}';

  bool _visibleProgress = true,
      _addNeighbor = false,
      _am_i_in_home,
      _showNeighbours = false;

  List<bool> _roommatesCurrentStateList = [];
  bool _roomIsFree = true;
  bool _homeAlone;
  List _neighboursInfo = [];

  String _url = 'http://lemonl1me.pythonanywhere.com';

  // Функции, отвечающие за получение, храненние и обработку информации =======
  Future<void> fetchJsonNeighbours() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "accept": "application/json"
    };
    Response response =
        await get(Uri.parse("$_url/neighbours/$_device_id/$_email"), headers: headers);
    int statusCode = response.statusCode;
    print('FETCHING NEIGHBOURS DATA STATUS CODE : ' + statusCode.toString());
    jsonNeighbours = response.body;
    Map<String, dynamic> data = jsonDecode(jsonNeighbours);
    setState(() {
      _neighboursInfo = data["neighbours"];
      // print(_neighboursInfo);
    });
  }

  void readJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    if (await userFile.exists()) {
      jsonUser = await userFile.readAsString();
    } else {
      userFile.writeAsString(jsonUser);
    }
    Map<String, dynamic> data = jsonDecode(jsonUser);
    setState(() {
      _email = data["email"];
      _password = data["password"];
      _device_id = data["device_id"];
      is_in_home_str = data["is_in_home"];
      if (int.parse(is_in_home_str) == 0){
        _am_i_in_home = false;
      }else {_am_i_in_home = true;}
      fetchJsonNeighbours();
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

  void updateUserJSON(String id, String email, String password, bool is_in_home) async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    String jsonUser =
        '{\n  "device_id" : "$id",\n  "email" : "$email",\n  "password" : "$password",\n  "is_in_home" : "$is_in_home"\n}';
    userFile.writeAsString(jsonUser);
  }

  void deleteDataJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    userFile.delete();
  }

  Future<void> updateStateRequest () async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "accept": "application/json"
    };
    String newState = '';
    if(_am_i_in_home){
      setState(() {
        newState = '0';
      });
    }else{
      setState(() {
        newState = '1';
      });
    }
    String json = '{"id": "$_device_id", "email": "$_email", "password": "$_password", "is_in_home": $newState}';
    Response response =
    await put(Uri.parse("$_url/update/$_email"), headers: headers, body: json);
    print("Request content : " + json);
  }

  // ==========================================================================
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
    // Тут должен был быть вызов функции fetchJsonNeighbours(_device_id), но
    // из-за приколов с async её тут нет.
    // Вызов будет сделан внутри функции readJSON().
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope() позволяет изменить функциона кнопок навигации. Добавлено
    // для того, чтобы не возникало ошибок при нажатии на них.
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      upperBar(),
                      stateDisplay(),
                      lowerButtons(),
                    ],
                  ),
                  greyBackground(),
                  neighbourList(),
                ],
              ),
      ),
    );
  }

  List<Widget> neighboursListBuilder() {
    List<Widget> result = [];
    for (int index = 0; index < _neighboursInfo.length; index++) {
      if (_neighboursInfo[index]["is_in_home"] == 1) {
        _roommatesCurrentStateList.add(false);
      } else {
        _roommatesCurrentStateList.add(true);
      }
      if (_roommatesCurrentStateList.contains(false)){
        setState(() {
          _roomIsFree = false;
        });
      }
    }
    if (_neighboursInfo != null) {
      for (int index = 0; index < _neighboursInfo.length; index++) {
        result.add(Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _roommatesCurrentStateList[index]
                  ? Colors.green[400]
                  : Colors.red[400],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    _neighboursInfo[index]["email"],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    _roommatesCurrentStateList[index]
                        ? 'Не дома'
                        : 'Дома',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }
    return result;
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
                // TODO: Сюда передавать готовый список соседей. Его формировать в отдельтном методе, который вызывается в setState(). Список формируется после получения инфы с сервера
                Column(
                  children: neighboursListBuilder(),
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

  Widget upperBar() {
    return Container(
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
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              // TODO: Сдедать редактирование профиля
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
                            builder: (context) => userProfileSettingsPage()));
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
                    context, MaterialPageRoute(builder: (context) => StartMenuPage()));
              })
        ],
      ),
    );
  }

  Widget stateDisplay() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: getColor(),
        ),
        width: double.infinity,
        height: 500,
        child: Center(
            child: Text(getStatusText(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        )),
      ),
    );
  }

  Widget lowerButtons() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    fetchJsonNeighbours();
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
                  setState(() {
                    _am_i_in_home = !_am_i_in_home;
                    updateStateRequest();
                    updateUserJSON(_device_id, _email, _password, _am_i_in_home);
                  });
                },
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: Text(
                    _am_i_in_home ? 'Вернулся' : 'Ухожу',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  )),
                )),
          ),
        ),
      ],
    );
  }

  String getStatusText(){
    if (!_am_i_in_home & _roomIsFree){return 'Вы один дома';}
    else if (_roomIsFree & _am_i_in_home){return 'Дома никого';}
    else{return 'Ваш сосед дома';}
  }

  Color getColor(){
    if (!_am_i_in_home & _roomIsFree){return Colors.orange;}
    else if (_roomIsFree & _am_i_in_home){return Colors.green;}
    else{return Colors.red;}
  }

}
