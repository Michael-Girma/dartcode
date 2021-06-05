import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class DeleteBlessingPopup extends StatefulWidget {
  final MyBlessing myBlessing;
  
  DeleteBlessingPopup({this.myBlessing});

  @override
  _DeleteBlessingPopupState createState() => _DeleteBlessingPopupState();
}

class _DeleteBlessingPopupState extends State<DeleteBlessingPopup> {
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
          Text("DELETE BLESSING",
              style: TextStyle(
                  fontFamily: "OpenSans-Bold",
                  color: Colors.lightBlue[800],
                  fontSize: 22)),
        ],
      ),
      content: Text("Are you sure you want to delete this blessing?"),
      actions: [
        !loading? TextButton(onPressed: ()async{
          setState(()=> loading = true);
          try{
            await myBlessingProvider.deleteBlessing(userProvider.user, widget.myBlessing);
            await tagProvider.updateTagLists(userProvider.user);
            Navigator.pop(context);
            Navigator.pop(context);
          }catch(e){
            print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE $e");
            Toast.show("Something went wrong", context, duration: Toast.LENGTH_SHORT);
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