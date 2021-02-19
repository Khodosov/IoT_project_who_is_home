import 'package:flutter/material.dart';
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
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        _visibleProgress = true;
                      });
                      // TODO: set json data
                    }
                  });
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
