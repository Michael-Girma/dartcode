import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final String screenTitle = "A FATHER'S BLESSING";
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String errorMessage = " ";
  Color borderColor = Colors.white;

  void hideLabel() async {
    Timer(const Duration(seconds: 5), () {
      setState() {
        errorMessage = " ";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //provider.of
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                screenTitle,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 23,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Image.asset(
                      'assets/images/BlessingApp_Icons_65x65_Blessings.png'),
                  title: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: borderColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _auth.sendPasswordResetEmail(email: email);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text("Request Sent"),
                          content:
                              Text('Request Sent\nPlease check your email for a password reset link.'),
                          actions: [
                            CupertinoDialogAction(
                              child: Text('Ok'),
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/login_screen'),
                            )
                          ],
                        );
                      },
                      barrierDismissible: false,
                    );
                  },
                  label: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Send Request',
                      style: TextStyle(
                        color: Color(0xffcf993d),
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 25,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.send,
                    color: Color(0xffcf993d),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(color: Color(0xffcf993d)),
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
              Visibility(
                visible: errorMessage != " ",
                child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[400]))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
