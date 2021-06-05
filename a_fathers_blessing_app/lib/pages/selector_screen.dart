import 'package:flutter/material.dart';


class SelectorPage extends StatefulWidget{

  @override
  _SelectorPageState createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  final String screenTitle = "A FATHER'S BLESSING";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/BlessingApp_WheatBackground_Blue.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                      AssetImage('assets/images/BlessingApp_Icons_100x100_Blessings.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 50),
                    child: Text(
                      'A FATHER\'S BLESSING',
                      style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login_screen');
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
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register_screen');
                          },
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
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}