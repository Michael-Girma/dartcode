import 'package:a_fathers_blessing_app/controller/config.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/myBlessingsView.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../controller/my_blessing/my_blessing.dart';

class MyBlessings extends StatefulWidget {
  MyBlessings({Key key}) : super(key: key);
  final String title = "MY BLESSINGS";

  @override
  _MyBlessingsState createState() => _MyBlessingsState();
}

class _MyBlessingsState extends State<MyBlessings> {
  @override
  void initState(){
    var box = Hive.box(Config.myBlessingBox);
    print(box.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
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
                widget.title,
                style: TextStyle(
                  fontFamily: 'OpenSans-Bold',
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
        child: Consumer<MyBlessingProvider>(
          builder: (context, myBlessingProvider, child){
            return MyBlessingView(context, _requester, myBlessingProvider.myBlessings);
          },
        )
      )
    );
  }

  Future<bool> _requester(context) async{
    MyBlessingProvider provider = Provider.of<MyBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen:false );
    List<MyBlessing> blessings = await provider.getMoreMyBlessings(user.user);
    if(blessings == null) return false;
    return blessings.length > 0;
  }
}
