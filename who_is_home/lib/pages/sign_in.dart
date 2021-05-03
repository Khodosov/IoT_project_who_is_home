import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/includes.dart';
import 'package:who_is_home/pages/user_profile.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _email, _password;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  String _url = 'http://lemonl1me.pythonanywhere.com';
  bool _requestSucceed = false;
  bool _doesNotExist = false;
  String _token, jsonToken;

  // Логика работы с файловой системой. =======================================
  void updateUserJSON(
      int device_id, String email, String password, String is_in_home) async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    String jsonUser =
        '{\n  "device_id" : "$device_id",\n  "email" : "$email",\n  "password" : "$password",\n  "is_in_home" : "$is_in_home"\n}';
    userFile.writeAsString(jsonUser);
  }

  // Работа с сетью ===========================================================
  Future<void> loginRequest(String email, String password) async {
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
    String json =
        '{"email": "$email", "password": "$password", "fcm_token": "$_token"}';
    Response response =
        await post(Uri.parse("$_url/login"), headers: headers, body: json);
    int statusCode = response.statusCode;
    print('CONNECTION...');
    int device_id = int.parse(response.body);
    print("Status Code:" + statusCode.toString());
    if (statusCode == 201) {
      setState(() {
        _requestSucceed = true;
        updateUserJSON(device_id, _email, _password, "1");
        print('LOGIN REQUEST DATA: ' + json);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => userProfilePage()));
      });
    }
    if (statusCode == 400) {
      setState(() {
        _doesNotExist = true;
      });
    }
  }

  // ==========================================================================


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                            label: 'Ваша почта', hint: 'Введите почту'),
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
                    )
                  ],
                ),
              ),
            ),
            Visibility(
                visible: _doesNotExist,
                child: Text(
                  "Почта или пароль введены неверно",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      print(_email);
                      print(_password);
                      loginRequest(_email, _password);
                    });
                  }
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: Text(
                    'Вход',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  )),
                )),
          ]),
        ],
      ),
    );
  }
}
