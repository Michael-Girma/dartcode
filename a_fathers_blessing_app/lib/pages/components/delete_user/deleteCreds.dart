import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ReAuthPopup extends StatefulWidget {
  final String message;
  final String title;
  final Function onTapOk;
  final String cancelText;
  final String okButtonText;

  ReAuthPopup(
      {this.message,
      this.title,
      this.onTapOk,
      this.cancelText,
      this.okButtonText});

  @override
  _ReAuthPopupState createState() => _ReAuthPopupState();
}

class _ReAuthPopupState extends State<ReAuthPopup> {
  bool loading = false;
  TextEditingController _credController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset("assets/images/BlessingApp_Icons_24x24_Tag.png"),
          Icon(Icons.warning),
          SizedBox(width: 10),
          Text(widget.title,
              style: TextStyle(
                  fontFamily: "OpenSans-Bold",
                  color: Colors.lightBlue[800],
                  fontSize: 22)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message),
          TextFormField(
            controller: _credController,
            obscureText: true,
          )
        ],
      ),
      // "The selected bible is a licensed version and thus can only be found on the bible gateway.\n" +
      //     "You will be redirected to the bible gateway where you can copy the verses you want."),
      actions: [
        !loading
            ? TextButton(
                onPressed: () async {
                  setState(() => loading = true);
                  try {
                    await widget.onTapOk(context, _credController.text);
                    //Navigator.pop(context);
                  } catch (e) {
                    print(e);
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
