import 'package:flutter/material.dart';

class UIComponent {
  static InputDecoration inputDecoration({String label, String hint}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      hintText: hint,
      errorStyle: TextStyle(fontSize: 0, height: 0),
      fillColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
            color: Colors.lightBlue,
          )),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          )),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(color: Colors.lightBlue),
      ),
    );
  }

  //TODO: Password Text decoration
  static InputDecoration inputDecorationPassword(
      {String label, String hint, bool suffixIcon, eventSuffixIcon}) {
    return InputDecoration(
        contentPadding: EdgeInsets.all(15),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        errorStyle: TextStyle(fontSize: 0, height: 0),
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.lightBlue,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.red, width: 1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: Colors.lightBlue),
        ),
        suffixIcon: IconButton(
            icon: Icon(suffixIcon ? Icons.visibility : Icons.visibility_off),
            color: Colors.blueAccent[100],
            onPressed: eventSuffixIcon));
  }

  //TODO: Text Area Decoration
  static InputDecoration inputTextAreaDecoration({String label, String hint}) {
    return InputDecoration(
      alignLabelWithHint: true,
      contentPadding: EdgeInsets.all(15),
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      hintText: hint,
      errorStyle: TextStyle(fontSize: 0, height: 0),
      fillColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
            color: Colors.lightBlue,
          )),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          )),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
    );
  }

  //TODO: Validate text
  static String textValidate(String value) {
    if (value.isEmpty) {
      return 'Необходимо заполнить';
    }
    return null;
  }

  //TODO: Validate email
  static String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Введите вашу почту';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Проверьте правильность написания';
    else
      return null;
  }

  //TODO: Validate password
  static String passwordValidate(String value) {
    if (value.isEmpty) {
      return 'Необходимо заполнить';
    }

    if (value.length < 8) {
      return 'Минимальная длина 8 символов';
    }

    return null;
  }
}
