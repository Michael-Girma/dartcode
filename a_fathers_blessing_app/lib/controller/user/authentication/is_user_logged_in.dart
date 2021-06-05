import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_fathers_blessing_app/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:a_fathers_blessing_app/pages/selector_screen.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';

class IsUserLoggedIn extends StatefulWidget {
  @override
  _IsUserLoggedInState createState() => _IsUserLoggedInState();
}

class _IsUserLoggedInState extends State<IsUserLoggedIn> {
  bool showSpinner = true;

  @override
  void initState() {
    isUserLoggedIn(context);
    super.initState();
  }

  void isUserLoggedIn(BuildContext context) async {
    SharedPreferences isLoggedIn = await SharedPreferences.getInstance();
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    // if (isLoggedIn.get('email') != null) {
    //   try {
    //     final result = await InternetAddress.lookup('google.com');
    //     if (result.isEmpty && result[0].rawAddress.isEmpty) {
    //       Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(
    //           builder: (BuildContext context) => MyHomePage(),
    //         ),
    //         (route) => false,
    //       );
    //     } else if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //       UserProvider userProvider =
    //           Provider.of<UserProvider>(context, listen: false);
    //       String status = await userProvider.login(
    //           email: isLoggedIn.get('email'), pass: isLoggedIn.get('password'));

    //       if (status == "success") {
    //         Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(
    //             builder: (BuildContext context) => MyHomePage(),
    //           ),
    //           (route) => false,
    //         );
    //       }
    //     }
    //   } on SocketException catch (_) {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (BuildContext context) => MyHomePage(),
    //       ),
    //       (route) => false,
    //     );
    //   }
    if (user.user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SelectorPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: showSpinner,
        color: Colors.white,
        progressIndicator: SpinKitFadingCircle(
          color: Theme.of(context).primaryColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/BlessingApp_WheatBackground_Blue.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
