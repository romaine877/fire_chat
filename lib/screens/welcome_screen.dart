import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fire_chat/components/rounded_button.dart';

import 'package:flutter/material.dart';

import 'login_screen.dart';

import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animate;
  @override
  void initState() {
    super.initState();
    
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animate =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animate.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'tag',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                    speed: Duration(seconds: 1),
                    repeatForever: true,
                    text: ['Fire Chat'],
                    textStyle: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              text: 'Login',
              buttonColor: Colors.lightBlueAccent,
            ),
            RoundedButton(
              onTap: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              text: 'Register',
              buttonColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
