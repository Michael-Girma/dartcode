import 'package:flutter/material.dart';

class TileSubtitle extends StatelessWidget {
  final String body;
  final List<String> tags;
  final bool expandable;

  TileSubtitle(this.body,
      {this.tags = const <String>[], this.expandable = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              // "body",
              body,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontFamily: 'Aleo-Regular',
                  fontSize: 18.0,
                  color: Colors.black),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Image.asset(
                  'assets/images/BlessingApp_Icons_24x24_Tag.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                // "here",
                expandable == true ? "EXPAND TO VIEW" : _getTags(tags),
                // nowData.tags.join(", "),
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: "Lato-Regular",
                    fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }

  _getTags(List<String> tags) {
    print(tags);
    String tagString;
    if (tags.length == 0)
      tagString = "NO TAGS";
    else
      tagString = tags.join(", ");
    print(tagString);
    return tagString;
  }
}
