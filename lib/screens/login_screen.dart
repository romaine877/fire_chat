import 'package:fire_chat/components/rounded_button.dart';
import 'package:fire_chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                              child: Hero(
                  tag: 'tag',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: kinputDecoration,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kinputDecoration.copyWith(hintText: 'password')),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.lightBlueAccent,
                text: 'Login',
                onTap: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                     setState(() {
                    showSpinner = false;
                  });
                  } catch (e) {
                    print(e);
                  }
                  
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
