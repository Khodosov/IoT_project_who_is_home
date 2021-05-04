import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AppCustomization {
  bool darkmode;
  String jsonSettings = '{"darkmode": "1"}';

  Future<void> settingsFileReader() async {
    final directory = await getApplicationDocumentsDirectory();
    final File userFile = File('${directory.path}/userdata.json');
    if (await userFile.exists()) {
      jsonSettings = await userFile.readAsString();
    } else {
      userFile.writeAsString(jsonSettings);
    }
    Map<String, dynamic> data = jsonDecode(jsonSettings);
    if(data['darkmode'].toString().compareTo('1') != null){
      darkmode = true;
    }else {darkmode = false;}
  }




}