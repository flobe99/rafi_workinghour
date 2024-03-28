import 'dart:io';

import 'package:RAFI_Workinghours/Time.dart';
import 'package:RAFI_Workinghours/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Overview extends StatefulWidget {
  _Overview createState() => _Overview();
}

class _Overview extends State<Overview> {
  TimeOfDay? checkInTime;
  late bool isChecked;
  int refreshmentbreak_minutes = 15;
  int lunchbreak_minutes = 30;

  TimeApi timeApi = new TimeApi();

  late File jsonFile;
  late Directory dir;
  String fileName = "settings.json";
  bool fileExists = false;
  late Map<String, dynamic> fileContent;

  TextEditingController _controller_Check_IN = TextEditingController();
  TextEditingController _controller_Check_OUT = TextEditingController();
  TextEditingController _controller_Working_Hour = TextEditingController();

  @override
  void initState() {
    super.initState();
    isChecked = true;
    TimeOfDay checkInTime = TimeOfDay?.now();
    String formattedTime =
        '${checkInTime.hour.toString().padLeft(2, '0')}:${checkInTime.minute.toString().padLeft(2, '0')}';
    _controller_Check_IN.text = "07:00";
    _controller_Check_OUT.text = formattedTime;
    _controller_Working_Hour.text = "";
    timeApi.createJsonFile();
    //readJson();
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
    TimeOfDay? checkInTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return checkInTime;
  }

  void readJson() async {
    Time data = timeApi.getTime();

    print("RefreshmentBreak: " + data.RefreshmentBreak);
    print("LunchBreak: " + data.LunchBreak);

    this.refreshmentbreak_minutes =
        int.parse(data.RefreshmentBreak.substring(0, 2)) * 60 +
            int.parse(data.RefreshmentBreak.substring(3, 5));
    this.lunchbreak_minutes = int.parse(data.LunchBreak.substring(0, 2)) * 60 +
        int.parse(data.LunchBreak.substring(3, 5));
  }

  Widget _buildPopupDialog(BuildContext context, String pText) {
    return new AlertDialog(
      title: const Text('RAFI Workinghour'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(pText),
        ],
      ),
      actions: <Widget>[
        new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          //textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  int convertTimeString_to_Minutes(String pTime) {
    return ((int.parse(pTime.split(":")[0]) * 60) +
        int.parse(pTime.split(":")[1]));
  }

  int reduce_break(int timeDiff) {
    int total_break = 0;
    if (!isChecked && timeDiff <= (360 + refreshmentbreak_minutes)) {
      total_break = refreshmentbreak_minutes;
    } else {
      total_break = refreshmentbreak_minutes + lunchbreak_minutes;
    }
    return timeDiff - total_break;
  }

  String calculateWorkingHour() {
    if (_controller_Working_Hour.text == "" &&
        _controller_Check_IN.text != "" &&
        _controller_Check_OUT.text != "") {
      int check_in_minutes =
          convertTimeString_to_Minutes(_controller_Check_IN.text);
      int check_out_minutes =
          convertTimeString_to_Minutes(_controller_Check_OUT.text);

      int _timeDiff = check_out_minutes - check_in_minutes;

      _timeDiff = reduce_break(_timeDiff);

      int _hr = _timeDiff ~/ 60;
      int _minute = (_timeDiff - (_hr * 60));

      return "Sie müssen ${_hr.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')} h arbeiten";
    } else if (_controller_Working_Hour.text != "" &&
        _controller_Check_IN.text != "" &&
        _controller_Check_OUT.text == "") {
      int check_in_minutes =
          convertTimeString_to_Minutes(_controller_Check_IN.text);
      int working_hours_minutes =
          convertTimeString_to_Minutes(_controller_Working_Hour.text);

      int _timeDiff = check_in_minutes + working_hours_minutes;

      _timeDiff = reduce_break(_timeDiff);

      int _hr = _timeDiff ~/ 60;
      int _minute = (_timeDiff - (_hr * 60));

      return "Sie müssen bis ${_hr.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')} h arbeiten";
    } else if (_controller_Working_Hour.text != "" &&
        _controller_Check_IN.text == "" &&
        _controller_Check_OUT.text != "") {
      int check_out_minutes =
          convertTimeString_to_Minutes(_controller_Check_OUT.text);
      int working_hours_minutes =
          convertTimeString_to_Minutes(_controller_Working_Hour.text);

      int _timeDiff = check_out_minutes - working_hours_minutes;

      _timeDiff = reduce_break(_timeDiff);

      int _hr = _timeDiff ~/ 60;
      int _minute = (_timeDiff - (_hr * 60));

      return "Sie müssen um ${_hr.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')} h arbeiten anfangen.";
    }
    return "Da ist mir ein Fehler unterlaufen";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RAFI Workinghour"),
        backgroundColor: Color.fromRGBO(0, 52, 66, 1),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("My Account"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Settings"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Settings(timeApi: timeApi)),
                    );
                  },
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
      body: Center(
        //mainAxisAlignment: MainAxisAlignment.center,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: TextField(
                    readOnly: true,
                    controller: _controller_Check_IN,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: "Check IN",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _controller_Check_IN.clear();
                          },
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        )),
                  ),
                  onDoubleTap: () async {
                    TimeOfDay time =
                        TimeOfDay(hour: 7, minute: 0); //TimeOfDay.now();
                    FocusScope.of(context).requestFocus(new FocusNode());

                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: time,
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
                        _controller_Check_IN.text = formattedTime;
                      });
                    }
                  }),
              GestureDetector(
                child: TextField(
                  readOnly: true,
                  controller: _controller_Check_OUT,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Check OUT",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _controller_Check_OUT.clear();
                      },
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                onDoubleTap: () async {
                  TimeOfDay time = TimeOfDay.now();
                  FocusScope.of(context).requestFocus(new FocusNode());

                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: time,
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
                      _controller_Check_OUT.text = formattedTime;
                    });
                  }
                },
              ),
              GestureDetector(
                child: TextField(
                  readOnly: true,
                  controller: _controller_Working_Hour,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Working hours",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _controller_Working_Hour.clear();
                      },
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                onDoubleTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 7, minute: 36),
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
              CheckboxListTile(
                  value: isChecked,
                  title: Text("Lunch Break"),
                  onChanged: (bool? value) {
                    setState(
                      () {
                        isChecked = value!;
                      },
                    );
                  }),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(255, 255, 255, 1)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(0, 52, 66, 1)),
                ),
                onPressed: () async {
                  readJson();

                  String ret = calculateWorkingHour();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, ret),
                  );
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.settings),
          backgroundColor: Color.fromRGBO(0, 52, 66, 1),
          onPressed: () {
            //Navigator.pushNamed(context, '/settings');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Settings(timeApi: timeApi)),
            );
          }),
    );
  }
}
