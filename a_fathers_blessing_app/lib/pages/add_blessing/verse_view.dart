import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/models/blessings.dart';
import 'package:a_fathers_blessing_app/models/more_menu.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/delete_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:a_fathers_blessing_app/models/blessing.dart';
import 'package:a_fathers_blessing_app/pages/edit_truth78_blessing.dart';
import 'package:a_fathers_blessing_app/pages/edit_my_blessing.dart';
import 'package:a_fathers_blessing_app/models/pass_data.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VerseView extends StatefulWidget {
  VerseView({Key key}) : super(key: key);
  final String title = "BLESSINGS";
  bool playing = false;

  @override
  _VerseViewState createState() => _VerseViewState();
}

class _VerseViewState extends State<VerseView> {
  @override
  Widget build(BuildContext context) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    color: Colors.white,
                    fontSize: 23),
              ),
            ],
          ),
        ),
        body: Container(
            child: Column(
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    shrinkWrap: true,
                    children: [
                      Text(
                        scripture.selectedVerse
                            .reference, //This is a mock data template defined under models/blessing.dart
                        style: TextStyle(
                            fontSize: 27,
                            fontFamily: "OpenSans-Bold",
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      SizedBox(height: 25),
                      Text(scripture.selectedVerse.text,
                          style: TextStyle(
                            fontFamily: "Aleo-Regular",
                            fontSize: 21,
                          )),
                    ],
                  )),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 3, color: Color(0xFFCF993D)),
                  ),
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/BlessingApp_WheatBackground_Blue.jpg"),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          MyBlessingProvider provider =
                              Provider.of<MyBlessingProvider>(context,
                                  listen: false);
                          provider.setTempBlessingTitle(
                              scripture.selectedVerse.reference);
                          scripture.copiedText = scripture.selectedVerse.text;
                          _copyToClipboard(scripture.selectedVerse.text);
                          Navigator.popUntil(
                              context, ModalRoute.withName('/add_blessing'));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  "assets/images/BlessingApp_Icons_48x48_SaveTags.png"),
                            ),
                            Container(
                              // width: MediaQuery.of(context).size.width * 0.,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 5, 10, 5),
                                child: Text(
                                  "COPY\nTEXT",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "OpenSans-Bold",
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            )
          ],
        )));
  }

  String _getTags(List<dynamic> tags) {
    if (tags.length > 0) {
      return tags.join(", ");
    } else {
      return "None";
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
