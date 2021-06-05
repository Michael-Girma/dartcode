import 'dart:async';

import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:a_fathers_blessing_app/pages/reset_password.dart';
import 'package:a_fathers_blessing_app/controller/user/authentication/is_email_verified.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String screenTitle = "A FATHER'S BLESSING";
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String errorMessage = " ";
  Color borderColor = Colors.white;
  FocusNode _passFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();

  void hideLabel() async {
    Timer(const Duration(seconds: 5), () {
      setState() {
        errorMessage = " ";
        borderColor = Colors.white;
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
              ListTile(
                leading: Image.asset(
                    'assets/images/BlessingApp_Icons_65x65_Blessings.png'),
                title: Text(
                  'Log In',
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    color: Colors.white,
                    fontSize: 50,
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
                    focusNode: _emailFocus,
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
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: borderColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: TextField(
                    focusNode: _passFocus,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _emailFocus.unfocus();
                    _passFocus.unfocus();
                    _login(context);
                  },
                  label: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xffcf993d),
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 25,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.login_rounded,
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
              TextButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ResetScreen())),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xffcf993d),
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 20,
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

  _login(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    setState(() {
      showSpinner = true;
    });
    if (email == null && password == null) {
      setState(() {
        errorMessage = "Please fill in your credentials";
        borderColor = Colors.red;
        showSpinner = false;
        hideLabel();
      });
    } else {
      String status = await userProvider.login(email: email, pass: password);

      if (status == "success") {
        SharedPreferences isLoggedIn = await SharedPreferences.getInstance();
        isLoggedIn.setString('email', email);
        isLoggedIn.setString('password', password);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(),
          ),
          (route) => false,
        );
      } else if (status == "failed") {
        print("fail");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => IsEmailVerified(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          // errorMessage = status;
          Toast.show(status, context, duration: Toast.LENGTH_LONG);
          borderColor = Colors.red;
          showSpinner = false;
          hideLabel();
        });
      }
      setState(() {
        showSpinner = false;
      });
      //TODO: create a small label under the textfields to notify the error of the login
    }
  }

  // _changeTag(){
  //   await changes tagname;
  //   await change Blessing;

  // }
}
