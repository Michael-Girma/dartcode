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

class EditTagPopup extends StatefulWidget {
  final String initialTag;

  EditTagPopup({this.initialTag});

  @override
  _EditTagPopupState createState() => _EditTagPopupState();
}

class _EditTagPopupState extends State<EditTagPopup> {
  bool loading = false;
  TextEditingController tagController = TextEditingController();
  String newTag = '';
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    MyBlessingProvider myBlessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    newTag = widget.initialTag;

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/BlessingApp_Icons_24x24_Tag.png"),
          SizedBox(width: 10),
          Text("EDIT TAG",
              style: TextStyle(
                  fontFamily: "OpenSans-Bold",
                  color: Colors.lightBlue[800],
                  fontSize: 22)),
        ],
      ),
      content: Container(
        // height: MediaQuery.of(context).size.height *
        //     0.1, // Change as per your requirement
        width: MediaQuery.of(context).size.width * 0.75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  TextFormField(
                      onChanged: (String text) {
                        newTag = text;
                      },
                      initialValue: widget.initialTag,
                      decoration: InputDecoration(
                        hintText: "EDIT TAG",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w300),
                      )),
                  !loading
                      ? TextButton(
                          child: Text("Save"),
                          onPressed: () async {
                            if (widget.initialTag.trim() == newTag.trim()) {
                              Navigator.pop(context);
                              return;
                            }
                            setState(() => loading = true);
                            try {
                              await tagProvider.persistTag(
                                  userProvider.user, widget.initialTag, newTag);
                              await tagProvider.refreshTags(userProvider.user);
                              await myBlessingProvider
                                  .updateMyBlessings(userProvider.user);
                              await truthBlessingProvider
                                  .updateTruthBlessings(userProvider.user);
                              Navigator.pop(context);
                            } catch (e) {
                              if (e is SocketException)
                                Toast.show(
                                    "Couldn't connect to server", context,
                                    duration: Toast.LENGTH_SHORT);
                              else
                                Toast.show("Something went wrong", context,
                                    duration: Toast.LENGTH_SHORT);
                            } finally {
                              setState(() => loading = false);
                            }
                            print("save pressed");
                          },
                        )
                      : CupertinoActivityIndicator(),
                ],
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(width: 5, color: Color(0xFFCF993D))),
    );
  }
}
