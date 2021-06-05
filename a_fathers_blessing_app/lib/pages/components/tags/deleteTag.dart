import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class DeleteTagPopup extends StatefulWidget {
  final String initialTag;
  
  DeleteTagPopup({this.initialTag});

  @override
  _DeleteTagPopupState createState() => _DeleteTagPopupState();
}

class _DeleteTagPopupState extends State<DeleteTagPopup> {
  bool loading = false;
  TextEditingController tagController = TextEditingController();
  String newTag = '';
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen:false);
    UserProvider userProvider = Provider.of<UserProvider>(context, listen:false);
    MyBlessingProvider myBlessingProvider = Provider.of<MyBlessingProvider>(context, listen:false);
    TruthBlessingProvider truthBlessingProvider = Provider.of<TruthBlessingProvider>(context, listen:false);
    
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/BlessingApp_Icons_24x24_Tag.png"),
          SizedBox(width: 10),
          Text("DELETE TAG",
              style: TextStyle(
                  fontFamily: "OpenSans-Bold",
                  color: Colors.lightBlue[800],
                  fontSize: 22)),
        ],
      ),
      content: Text("Deleting this tag will remove it from all tagged blessings. Are you sure?"),
      actions: [
        !loading? TextButton(onPressed: ()async{
          setState(()=> loading = true);
          try{
            await tagProvider.deleteTag(userProvider.user, widget.initialTag);
            await myBlessingProvider.updateMyBlessings(userProvider.user);
            await truthBlessingProvider.updateTruthBlessings(userProvider.user);
            Navigator.pop(context);
            // Navigator.
          }catch(e){
            // Navigator.of(context).pop();
            if(e is SocketException)
              Toast.show("Couldn't Connect to server", context, duration: Toast.LENGTH_LONG);
            else 
              Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG);
          }finally{
            setState(()=> loading = false);
          }
        }, child: Text("Yes")
        ): CupertinoActivityIndicator(),
        !loading? TextButton(onPressed: (){Navigator.pop(context);}, child: Text("No"),): CupertinoActivityIndicator()
      ], 
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(width: 5, color: Color(0xFFCF993D))),
    );
  }
}