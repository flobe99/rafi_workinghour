import 'package:RAFI_Workinghours/signin.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  bool firstPasswordVisible = true;
  bool secondPasswordVisible = true;
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
                  "Sign Up",
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
                obscureText: firstPasswordVisible,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "password",
                  suffixIcon: IconButton(
                    icon: Icon(firstPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          firstPasswordVisible = !firstPasswordVisible;
                        },
                      );
                    },
                  ),
                  alignLabelWithHint: false,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
              TextField(
                obscureText: secondPasswordVisible,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "password",
                  suffixIcon: IconButton(
                    icon: Icon(secondPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          secondPasswordVisible = !secondPasswordVisible;
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
                  child: Text("Sign Up"),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
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
