import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Time timeModelFromJson(String str) {
  //x = json.decode(str);
  return (Time.fromJson(json.decode(str)));
}

String timeModelToJson(List<Time> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TimeApi {
  late File jsonFile;
  Directory dir = Directory('assets');
  String fileName = "settings.json";
  bool fileExists = false;
  late Map<String, dynamic> fileContent;

  void createJsonFile() {
    Map<String, dynamic> content = {
      "RefreshmentBreak": "00:15",
      "LunchBreak": "00:30"
    };
    getApplicationDocumentsDirectory().then((Directory directory) {
      this.dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (!fileExists) {
        File file = new File(dir.path + "/" + fileName);
        file.createSync();
        fileExists = true;
        file.writeAsStringSync(json.encode(content));
      }
    });
  }

  Time getTime() {
    File file = new File(dir.path + "/" + fileName);
    String data = file.readAsStringSync();
    Time _model = timeModelFromJson(data) as Time;
    print(_model);
    return _model;
  }

  void setTime(RefreshmentBreak, LunchBreak) {
    File file = new File(dir.path + "/" + fileName);
    var data = json.decode(file.readAsStringSync());
    data["RefreshmentBreak"] = RefreshmentBreak;
    data["LunchBreak"] = LunchBreak;
    file.writeAsStringSync(json.encode(data));
    //file.writeAsStringSync(json.encode({"RefreshmentBreak": RefreshmentBreak, "LunchBreak": LunchBreak}));
  }
}

class Time {
  Time({required this.RefreshmentBreak, required this.LunchBreak});

  String RefreshmentBreak;
  String LunchBreak;

  factory Time.fromJson(json) {
    return Time(
      RefreshmentBreak:
          json['RefreshmentBreak'] is String ? json['RefreshmentBreak'] : "",
      LunchBreak: json['LunchBreak'] is String ? json['LunchBreak'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
        'RefreshmentBreak': RefreshmentBreak,
        'LunchBreak': LunchBreak,
      };
}
