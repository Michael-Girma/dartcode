import 'dart:async';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:a_fathers_blessing_app/models/more_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = "A FATHER'S BLESSING";

  final String aboutUrl = "https://www.truth78.org";
  final String helpUrl = "http://truth78.org/fb-help";
  final String otherAppsUrl = "https://www.truth78.org/apps-for-families";

  static const List<Choice> choices = const <Choice>[
    // const Choice(title: 'Logout', icon: Icons.logout),
    const Choice(title: 'Settings', icon: Icons.settings)
  ];

  getToken(context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String token = await userProvider.user.getIdToken();
    print("TOKEN $token");
  }

  @override
  Widget build(BuildContext context) {
    getToken(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'OpenSans-Bold', color: Colors.white, fontSize: 23),
        ),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            color: Color(0xFFCF993D),
            onSelected: (Choice choice) {
              _select(context, choice);
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    textStyle: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                    ),
                    value: choice,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            choice.icon,
                            color: Colors.white,
                          ),
                        ),
                        Text(choice.title),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/BlessingApp_WheatBackground_Blue.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder<Object>(
              future: _getUserData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.none) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => {
                          Navigator.pushNamed(context, "/chapters")
                        }, // , ROUTE SOMEWHERE MAYBE
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 50.0, 0, 0),
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: AssetImage(
                                      'assets/images/BlessingApp_Icons_100x100_Guide.png'),
                                ),
                                Text(
                                  'GUIDE',
                                  style: TextStyle(
                                    fontFamily: 'OpenSans-Bold',
                                    fontSize: 30.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            {Navigator.pushNamed(context, "/blessing_menu")},
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50.0,
                                backgroundImage: AssetImage(
                                    'assets/images/BlessingApp_Icons_100x100_Blessings.png'),
                              ),
                              Text(
                                'BLESSINGS',
                                style: TextStyle(
                                  fontFamily: 'OpenSans-Bold',
                                  fontSize: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () async {
                                  await canLaunch(helpUrl)
                                      ? await launch(helpUrl)
                                      : throw 'Could not launch $helpUrl';
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/BlessingApp_Icons_100x100_Help.png'),
                                      ),
                                      Text(
                                        'HELP',
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () async {
                                  await canLaunch(aboutUrl)
                                      ? await launch(aboutUrl)
                                      : throw 'Could not launch $aboutUrl';
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/BlessingApp_Icons_100x100_AboutTruth78.png'),
                                      ),
                                      Text(
                                        'ABOUT TRUTH78',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () async {
                                  await canLaunch(otherAppsUrl)
                                      ? await launch(otherAppsUrl)
                                      : throw 'Could not launch $otherAppsUrl';
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 35.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/BlessingApp_Icons_100x100_OtherApps.png'),
                                      ),
                                      Text(
                                        'OTHER\nAPPS',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-Bold',
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      Container(
                        width: double.infinity,
                      ),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitCircle(color: Theme.of(context).primaryColor);
                }
              }),
        ),
      ),
    );
  }

  void _select(BuildContext context, Choice choice) {
    if (choice.title == choices[0].title) {
      Navigator.pushNamed(context, '/settings');
    }
  }

  void logOutUser(BuildContext context) async {
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

  Future<void> _getUserData(BuildContext context) {}
}
