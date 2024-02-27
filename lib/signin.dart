import 'package:RAFI_Workinghours/signup.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SignIn extends StatefulWidget {
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  bool passwordVisible = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Image.asset("assets/RAFI_logo.png"),
              ),
              Container(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromRGBO(0, 52, 66, 1),
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "username",
                ),
              ),
              TextField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "password",
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                  alignLabelWithHint: false,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all<Size?>(Size(200.0, 5.0)),
                    textStyle: MaterialStateProperty.all<TextStyle?>(
                        TextStyle(fontSize: 20)),
                  ),
                  onPressed: () {},
                  child: Text("Sign In"),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
