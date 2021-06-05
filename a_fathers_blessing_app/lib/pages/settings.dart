import 'dart:io';

import 'package:a_fathers_blessing_app/controller/all_provs.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/authentication/auth_exception_handler.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/pages/components/delete_user/deleteCreds.dart';
import 'package:a_fathers_blessing_app/pages/selector_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'components/common/confirmation_popup.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "SETTINGS",
          style: TextStyle(
              fontFamily: 'OpenSans-Bold', color: Colors.white, fontSize: 23),
        )),
        body: Container(
            child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                logoutUser(context);
              },
              child: Card(
                child: ListTile(
                  leading:
                      Icon(Icons.logout, color: Theme.of(context).primaryColor),
                  title: Text('Logout'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showSigninPopup(context);
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Delete Account'),
                ),
              ),
            ),
          ],
        )));
  }

  void logoutUser(BuildContext context) async {
    MyBlessingProvider provider =
        Provider.of<MyBlessingProvider>(context, listen: false);

    provider.deleteMyBlessings();

    final _auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    _auth.signOut();
    Navigator.pushReplacementNamed(context, '/selector_page');
  }

  _deleteLocalUserData() async {
    MyBlessingProvider myBlessings =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TruthBlessingProvider truthBlessings =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    TagProvider tags = Provider.of<TagProvider>(context, listen: false);

    await myBlessings.deleteMyBlessings();
    await truthBlessings.deleteTruthBlessings();
    await tags.deleteTags();
  }

  _showSigninPopup(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ReAuthPopup(
              cancelText: "CANCEL",
              title: "DELETE ACCOUNT",
              message:
                  "Deleting your account will erase all your data. Please enter your credentials to delete account.",
              onTapOk: (BuildContext context, String password) async {
                if (password == null || password == "") {
                  Toast.show("Please enter your credentials", context,
                      duration: Toast.LENGTH_LONG);
                  return;
                }
                UserProvider prov =
                    Provider.of<UserProvider>(context, listen: false);

                String email = prov.user.email;

                var credential = EmailAuthProvider.credential(
                    email: email, password: password);

                try {
                  await prov.user.reauthenticateWithCredential(credential);
                  bool status = await prov.clearDataFromServer(prov.user);
                  if (status) {
                    await _deleteUser(context, prov.user);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SelectorPage()),
                      (route) => false,
                    );
                    return;
                  } else {
                    throw Exception;
                  }
                } catch (error) {
                  if (error is FirebaseAuthException) {
                    var status = AuthExceptionHandler.handleException(error);
                    var message =
                        AuthExceptionHandler.generateExceptionMessage(status);
                    Toast.show(message, context, duration: Toast.LENGTH_LONG);
                    return;
                  }
                  if (error is SocketException) {
                    Toast.show("Couldn't Connect to Server", context,
                        duration: Toast.LENGTH_LONG);
                  }
                  Toast.show("Something went wrong", context,
                      duration: Toast.LENGTH_LONG);
                }
              });
        });
  }

  _deleteUser(BuildContext context, User user) async {
    await user.delete();
    await _deleteLocalUserData();
  }
}
