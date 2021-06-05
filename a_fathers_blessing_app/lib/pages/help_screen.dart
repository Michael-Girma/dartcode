import 'package:flutter/material.dart';


class HelpScreen extends StatelessWidget {
  final String screenTitle = "HELP";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    fontSize: 27,
                    color: Colors.white
                ),
              ),
            ),
            Icon(Icons.more_vert, color: Colors.white, size: 30,),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/BlessingApp_WheatBackground_Blue.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Text('HELP CONTENT GOES HERE'),
      ),
    );
  }
}