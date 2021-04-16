import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/pages/user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../includes.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email, _password, _id;
  bool _passwordVisible = true, _is_in_home = false;
  final _formKey = GlobalKey<FormState>();
  String _url = 'http://http://127.0.0.1:5000';

  void updateUserJSON(String email, String password, int id) async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    String jsonUser =
        '{\n  "id" : "$id",\n  "email" : "$email",\n  "password" : "$password",\n  "is_in_home" : "true"\n}';
    userFile.writeAsString(jsonUser);
  }

  Future<void> registrationRequest(String id, String email, String password) async {
    Map<String, String> headers = {"Content-type": "application/json", "accept" : "application/json"};
    String json = '{"id": "$id", "email": "$email", "password": "$password"}';
    Response response = await post(Uri.parse("$_url/register"), headers: headers, body: json);
    int statusCode = response.statusCode;
    print('CONNECTION...');
    print(response.body);
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
                            _id = value;
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
                        // _visibleProgress = true;
                        print(_email);
                        print(_password);
                        print(_id);
                        updateUserJSON(_email, _password, int.parse(_id));
                        registrationRequest(_id, _email, _password);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => userProfilePage()));
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
                )),
          ]),
    );
  }
}
