import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:a_fathers_blessing_app/controller/user/authentication/auth_exception_handler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

FocusNode _emailFocus = FocusNode();
FocusNode _passFocus = FocusNode();
FocusNode _confirmFocus = FocusNode();

class _RegisterScreenState extends State<RegisterScreen> {
  final String screenTitle = "A FATHER'S BLESSING";
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String confirmPassword;
  Color confPassBorder = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Icon(Icons.more_vert, color: Colors.white),
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
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: ListTile(
                          leading: Image.asset(
                              'assets/images/BlessingApp_Icons_65x65_Blessings.png'),
                          title: Text(
                            'Register',
                            style: TextStyle(
                              fontFamily: 'OpenSans-Bold',
                              color: Colors.white,
                              fontSize: 50,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: confPassBorder, width: 1),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            focusNode: _emailFocus,
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
                          side: BorderSide(color: confPassBorder, width: 1),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            focusNode: _passFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: confPassBorder, width: 1),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: TextField(
                            onChanged: (value) {
                              confirmPassword = value;
                            },
                            focusNode: _confirmFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Re-Enter Password",
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          label: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xffcf993d),
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 25,
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.app_registration,
                            color: Color(0xffcf993d),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(color: Color(0xffcf993d)),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: () async {
                            _emailFocus.unfocus();
                            _passFocus.unfocus();
                            _confirmFocus.unfocus();
                            setState(() {
                              showSpinner = true;
                            });
                            if (email == null || password == null) {
                              Toast.show(
                                  "Please fill in all the credentials", context,
                                  duration: Toast.LENGTH_LONG);
                              setState(() {
                                confPassBorder = Colors.red;
                                showSpinner = false;
                              });
                            } else if (password.length < 8) {
                              Toast.show(
                                  "Passwords must aleast be 8 characters long.",
                                  context,
                                  duration: Toast.LENGTH_LONG);
                              setState(() {
                                confPassBorder = Colors.red;
                                showSpinner = false;
                              });
                            } else if (password != confirmPassword) {
                              Toast.show("Passwords don't match.", context,
                                  duration: Toast.LENGTH_LONG);
                              setState(() {
                                confPassBorder = Colors.red;
                                showSpinner = false;
                              });
                            } else {
                              try {
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email.trim(),
                                        password: password);
                                if (newUser != null) {
                                  Navigator.pushNamed(
                                      context, '/email_verified');
                                }
                              } catch (error) {
                                if (this.mounted)
                                  setState(() {
                                    showSpinner = false;
                                  });
                                if (error is TimeoutException)
                                  Toast.show("No Internet Connection", context,
                                      duration: Toast.LENGTH_LONG);
                                else if (error is FirebaseAuthException) {
                                  var code =
                                      AuthExceptionHandler.handleException(
                                          error);
                                  String message = AuthExceptionHandler
                                      .generateExceptionMessage(code);
                                  Toast.show(message, context,
                                      duration: Toast.LENGTH_LONG);
                                }
                              } finally {
                                if (this.mounted)
                                  setState(() {
                                    showSpinner = false;
                                  });
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
