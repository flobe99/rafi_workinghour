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
      "LunchBreak": "00:30",
      "WorkingHour": "00:36"
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

  void setTime(RefreshmentBreak, LunchBreak, WorkingHour) {
    File file = new File(dir.path + "/" + fileName);
    var data = json.decode(file.readAsStringSync());
    data["RefreshmentBreak"] = RefreshmentBreak;
    data["LunchBreak"] = LunchBreak;
    data["WorkingHour"] = WorkingHour;
    file.writeAsStringSync(json.encode(data));
    //file.writeAsStringSync(json.encode({"RefreshmentBreak": RefreshmentBreak, "LunchBreak": LunchBreak}));
  }
}

class Time {
  Time(
      {required this.RefreshmentBreak,
      required this.LunchBreak,
      required this.WorkingHour});

  String RefreshmentBreak;
  String LunchBreak;
  String WorkingHour;

  factory Time.fromJson(json) {
    return Time(
      RefreshmentBreak:
          json['RefreshmentBreak'] is String ? json['RefreshmentBreak'] : "",
      LunchBreak: json['LunchBreak'] is String ? json['LunchBreak'] : "",
      WorkingHour: json['WorkingHour'] is String ? json['WorkingHour'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
        'RefreshmentBreak': RefreshmentBreak,
        'LunchBreak': LunchBreak,
        'WorkingHour': WorkingHour
      };
}
