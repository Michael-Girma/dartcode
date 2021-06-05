import 'dart:async';

import 'package:a_fathers_blessing_app/pages/selector_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class IsEmailVerified extends StatefulWidget {
  @override
  _IsEmailVerifiedState createState() => _IsEmailVerifiedState();
}

class _IsEmailVerifiedState extends State<IsEmailVerified> {
  bool showSpiner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/BlessingApp_WheatBackground_Blue.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'A verification email has been sent to your email address. Please verify to continue.',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold', fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SelectorPage()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
