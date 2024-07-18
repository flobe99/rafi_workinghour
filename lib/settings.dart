import 'package:RAFI_Workinghours/Time.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, this.timeApi});

  final TimeApi? timeApi;
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  TextEditingController _controller_Refreshment_break = TextEditingController();
  TextEditingController _controller_Lunch_break = TextEditingController();
  TextEditingController _controller_Working_Hour = TextEditingController();

  int refreshmentbreak_hours = 0;
  int refreshmentbreak_minutes = 15;
  int lunchbreak_hours = 0;
  int lunchbreak_minutes = 30;
  int workinghour_hours = 0;
  int workinghour_minutes = 30;
  late Time data;

  @override
  void initState() {
    super.initState();
    Time data = widget.timeApi!.getTime();
    _controller_Refreshment_break.text = data.RefreshmentBreak;
    _controller_Lunch_break.text = data.LunchBreak;
    _controller_Working_Hour.text = data.WorkingHour;
    refreshmentbreak_hours = int.parse(data.RefreshmentBreak.split(":")[0]);
    refreshmentbreak_minutes = int.parse(data.RefreshmentBreak.split(":")[1]);
    lunchbreak_hours = int.parse(data.LunchBreak.split(":")[0]);
    lunchbreak_minutes = int.parse(data.LunchBreak.split(":")[1]);
    workinghour_hours = int.parse(data.WorkingHour.split(":")[0]);
    workinghour_minutes = int.parse(data.WorkingHour.split(":")[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Color.fromRGBO(0, 52, 66, 1),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: TextField(
                  controller: _controller_Refreshment_break,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(labelText: "Refreshment Break"),
                  readOnly: true,
                ),
                onDoubleTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: refreshmentbreak_hours,
                        minute: refreshmentbreak_minutes),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    print(picked.hour.toString().padLeft(2, '0'));
                    String formattedTime =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

                    setState(() {
                      _controller_Refreshment_break.text = formattedTime;
                    });
                  }
                },
              ),
              GestureDetector(
                child: TextField(
                  controller: _controller_Lunch_break,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(labelText: "Lunch Break"),
                  readOnly: true,
                ),
                onDoubleTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: lunchbreak_hours, minute: lunchbreak_minutes),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    String formattedTime =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    setState(() {
                      _controller_Lunch_break.text = formattedTime;
                    });
                  }
                },
              ),
              GestureDetector(
                child: TextField(
                  controller: _controller_Working_Hour,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(labelText: "Working Hour"),
                  readOnly: true,
                ),
                onDoubleTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: workinghour_hours, minute: workinghour_minutes),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    String formattedTime =
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    setState(() {
                      _controller_Working_Hour.text = formattedTime;
                    });
                  }
                },
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(255, 255, 255, 1)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 52, 66, 1)),
                  ),
                  onPressed: () async {
                    //writeToFile(_controller_Refreshment_break.text, _controller_Lunch_break.text);
                    widget.timeApi?.setTime(
                        _controller_Refreshment_break.text,
                        _controller_Lunch_break.text,
                        _controller_Working_Hour.text);
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
