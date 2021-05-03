import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/pages/user_profile.dart';
import '../includes.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email, _password, _device_id, _is_in_home, _token, jsonToken;
  bool _passwordVisible = true;
  bool _requestSucceed = false;
  bool _allreadyExist = false;
  final _formKey = GlobalKey<FormState>();




  // Ссылка на сервер. К ней нужно прибавть /register + POST + формат jsona на скрине - регистрация
  //
  // /login + POST + тот же json, только без id - вход
  //
  // /neighbours - список соседей
  // /update/почта человека + PUT - обновление состояния, почты, пароля, чего угодно
  // /neighbours/код устройства - поправила вывод соседей
  // по /neighbours/ до сих пор доступны все соседи

  String _url = 'http://lemonl1me.pythonanywhere.com';

  // ==========================================================================
  void updateUserJSON(String id, String email, String password, String is_in_home) async {
    final directory = await getApplicationDocumentsDirectory();
      final File userFile = File('${directory.path}/userdata.json');
    String jsonUser =
        '{\n  "device_id" : "$id",\n  "email" : "$email",\n  "password" : "$password",\n  "is_in_home" : "$is_in_home"\n}';
    userFile.writeAsString(jsonUser);
  }

  Future<void> registrationRequest(String device_id, String email, String password) async {
    final directory = await getApplicationDocumentsDirectory();
    final File tokenFile = File('${directory.path}/fcmtoken.json');
    if (await tokenFile.exists()) {
      jsonToken = await tokenFile.readAsString();
    } else {
      tokenFile.writeAsString(jsonToken);
    }
    Map<String, dynamic> data = jsonDecode(jsonToken);
    setState(() {
      _token = data["fcm_token"];
    });
    Map<String, String> headers = {
      "Content-type": "application/json",
      "accept": "application/json"
    };
    String json = '{"id": "$device_id", "email": "$email", "password": "$password", "fcm_token": "$_token"}';
    Response response =
        await post(Uri.parse("$_url/register"), headers: headers, body: json);
    print("Request content : " + json);
    int statusCode = response.statusCode;
    print('CONNECTION...');
    print(response.body);
    print("Status Code:" + statusCode.toString());
    if (statusCode == 201) {
      setState(() {
        _requestSucceed = true;
      });
    }
    if (statusCode == 400){
      setState(() {
        _allreadyExist = true;
      });
    }
    if (_requestSucceed) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => userProfilePage()));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Text(
                'Добро пожаловать!',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 45),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child: TextFormField(
                        validator: UIComponent.emailValidate,
                        decoration: UIComponent.inputDecoration(
                            label: 'Ваша почта', hint: 'Введите вочту'),
                        onSaved: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child: TextFormField(
                        obscureText: _passwordVisible,
                        validator: UIComponent.passwordValidate,
                        decoration: UIComponent.inputDecorationPassword(
                            label: 'Ваш пароль',
                            hint: 'Введите пароль',
                            suffixIcon: _passwordVisible,
                            eventSuffixIcon: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                        onSaved: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child: TextFormField(
                        validator: UIComponent.textValidate,
                        decoration: UIComponent.inputDecoration(
                            label: 'Код устройства',
                            hint: 'Введите код, указанный на устройстве'),
                        onSaved: (value) {
                          setState(() {
                            _device_id = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    // TODO: set json data
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        updateUserJSON(_device_id, _email, _password, "1");
                        registrationRequest(_device_id, _email, _password);
                      });
                    }
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
                    'Подтвердить регистрацию!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  )),
                )
            ),
            Visibility(
              visible: _allreadyExist,
              child: Text("Аккаунт с введёнными данными уже существует",
                style: TextStyle(color: Colors.red),
              )
            )
          ]),
    );
  }
}
