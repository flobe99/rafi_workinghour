import 'package:flutter/material.dart';
import 'package:RAFI_Workinghours/overview.dart';
import 'package:RAFI_Workinghours/settings.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RAFI Workinghour",
      home: Overview(),
      //home: Overview(),
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 52, 66, 1))),
    );
  }
}
