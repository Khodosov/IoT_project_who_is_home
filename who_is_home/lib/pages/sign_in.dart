import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:who_is_home/includes.dart';
import 'package:who_is_home/pages/user_profile.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _name, _password;
  bool _passwordVisible = false, _loginError, _visibleProgress;
  final _formKey = GlobalKey<FormState>();


  // Логика работы с файловой системой. =======================================
  TextEditingController _controllerKeyMail, _controllerValueMail, _controllerKeyPassword,
      _controllerValuePassword;
  bool _fileExists = false;
  File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<String, dynamic> _json = {};
  String _jsonString;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userdata.txt');
  }

  void _writeJson(String key, dynamic value) async {
    // Initialize the local _filePath
    final _filePath = await _localFile;

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> _newJson = {key: value};
    print('1.(_writeJson) _newJson: $_newJson');

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    _json.addAll(_newJson);
    print('2.(_writeJson) _json(updated): $_json');

    //3. Convert _json ->_jsonString
    _jsonString = jsonEncode(_json);
    print('3.(_writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    _filePath.writeAsString(_jsonString);
  }

  void _readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _fileExists = await _filePath.exists();
    print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath.readAsString();
        print('1.(_readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        _json = jsonDecode(_jsonString);
        print('2.(_readJson) _json: $_json \n - \n');
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Instantiate _controllerKey and _controllerValue
    _controllerKeyMail = TextEditingController();
    _controllerValueMail = TextEditingController();
    _controllerKeyPassword = TextEditingController();
    _controllerValuePassword = TextEditingController();
    print('0. Initialized _json: $_json');
    _readJson();
  }

  @override
  void dispose() {
    _controllerKeyMail.dispose();
    _controllerValueMail.dispose();
    _controllerKeyPassword.dispose();
    _controllerValuePassword.dispose();
    super.dispose();
  }
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget> [
          /*Container(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              child: Image.asset('assets/images/guard_locked.jpg'),
              fit: BoxFit.fill,
            ),
          ),*/
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
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(40)),
                      child: TextFormField(
                        controller: _controllerValueMail,
                        validator: UIComponent.emailValidate,
                        decoration: UIComponent.inputDecoration(
                            label: 'Ваша почта', hint: 'Введите вочту'),
                        onSaved: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(40)),
                      child: TextFormField(
                        controller: _controllerValuePassword,
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
            FlatButton(
                onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // TODO: set json data
                      _writeJson(_controllerKeyMail.text, _controllerValueMail.text);
                      _writeJson(_controllerKeyPassword.text, _controllerValuePassword.text);
                      final file = await _localFile;
                      _fileExists = await file.exists();
                      //_fileName = file;

                      setState(() {});
                      _controllerKeyMail.clear();
                      _controllerValueMail.clear();
                      _controllerKeyPassword.clear();
                      _controllerValuePassword.clear();
                    }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => userProfilePage()));
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
