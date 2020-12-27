import 'package:fire_chat/screens/chat_screen.dart';

import 'package:flutter/material.dart';

import '../constants.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  final _auth = FirebaseAuth.instance;
  String email, password;
  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kinputDecoration.copyWith(hintText: 'Email')),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kinputDecoration.copyWith(
                  hintText: 'Password',
                )),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async{
                    try{
                       final newUser=
                   await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                        if (newUser!=null){
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                  }catch(e){
                    print('e=$e');
                  }
                    },
                   
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
