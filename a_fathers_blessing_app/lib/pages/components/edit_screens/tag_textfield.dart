import 'package:flutter/material.dart';

class TagTextField extends StatelessWidget {
  final List<String> tags;
  final Function onTap;

  TagTextField({this.tags, this.onTap});

  @override
  Widget build(BuildContext context) {
    TextEditingController tagsController = TextEditingController();
    tagsController.text = tags.join(', ');
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Container(
                  child: TextFormField(
                      onTap: onTap,
                      // minLines: 2,
                      readOnly: true,
                      controller: tagsController,
                      autocorrect: false,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "None",
                          hintStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: "Lato-Regular",
                              fontSize: 20)),
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Lato-Regular",
                          color: Theme.of(context).accentColor)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: GestureDetector(
                onTap: onTap,
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(
                      "assets/images/BlessingApp_Icons_24x24_Arrow.png"),
                ),
              ),
            )
          ],
        ));
  }
}
