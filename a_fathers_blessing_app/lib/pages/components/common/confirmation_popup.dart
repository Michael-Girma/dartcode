import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:url'
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectionPopup extends StatefulWidget {
  final String url;
  final List buttons;
  final String title;
  final String okButtonText;
  final Function onTapOk;
  final String message;
  final String cancelText;
  final bool warning;

  RedirectionPopup(
      {this.url,
      this.buttons,
      this.title,
      this.message,
      this.okButtonText,
      this.cancelText,
      this.warning = false,
      this.onTapOk});

  @override
  _RedirectionPopupState createState() => _RedirectionPopupState();
}

class _RedirectionPopupState extends State<RedirectionPopup> {
  bool loading = false;
  TextEditingController tagController = TextEditingController();
  String newTag = '';
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset("assets/images/BlessingApp_Icons_24x24_Tag.png"),
          if (widget.warning) Icon(Icons.warning),
          SizedBox(width: 10),
          Text(widget.title,
              style: TextStyle(
                  fontFamily: "OpenSans-Bold",
                  color: Colors.lightBlue[800],
                  fontSize: 22)),
        ],
      ),
      content: Text(widget.message),
      // "The selected bible is a licensed version and thus can only be found on the bible gateway.\n" +
      //     "You will be redirected to the bible gateway where you can copy the verses you want."),
      actions: [
        !loading
            ? TextButton(
                onPressed: () async {
                  setState(() => loading = true);
                  try {
                    await widget.onTapOk(context);
                    // Navigator.pop(context);
                  } catch (e) {
                    // Navigator.of(context).pop();
                    Toast.show("Something went wrong", context,
                        duration: Toast.LENGTH_LONG);
                  } finally {
                    setState(() => loading = false);
                  }
                },
                child: Text(widget.okButtonText ?? "OK"))
            : CupertinoActivityIndicator(),
        widget.cancelText != null
            ? !loading
                ? TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(widget.cancelText))
                : CupertinoActivityIndicator()
            : SizedBox()
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(width: 5, color: Color(0xFFCF993D))),
    );
  }
}
