import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/scripture/utils.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/scripture/bible.dart';
import 'package:a_fathers_blessing_app/models/scripture/book.dart';
import 'package:a_fathers_blessing_app/models/scripture/chapter.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/add_blessing/display_list.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/truthBlessingsView.dart';
import 'package:a_fathers_blessing_app/pages/components/common/confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:a_fathers_blessing_app/models/blessings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:a_fathers_blessing_app/pages/single_blessing.dart';
import 'package:a_fathers_blessing_app/models/pass_data.dart';
import 'package:synchronized/synchronized.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SelectChapter extends StatefulWidget {
  SelectChapter({Key key}) : super(key: key);
  final String title = "SELECT CHAPTER";

  @override
  _SelectChapterState createState() => _SelectChapterState();
}

class _SelectChapterState extends State<SelectChapter> {
  Bible selectedBible;
  Book selectedBook;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    Map data = ModalRoute.of(context).settings.arguments;

    this.selectedBible = data["bible"];
    this.selectedBook = data["book"];

    // scripture.getBibles();
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
      body: Consumer<TruthBlessingProvider>(
        builder: (context, truthBlessingProvider, child) {
          return FutureBuilder(
              future: _getChapters(context, selectedBible.id, selectedBook.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<ScriptureProvider>(
                      builder: (context, scripture, child) {
                    return DisplayList(
                        scripture.filteredChapters,
                        getTitle,
                        getSubtitle,
                        _onTap,
                        _filter,
                        "FILTER CHAPTERS BY REFERENCE");
                  });
                } else
                  return SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  );
              });
        },
      ),
    );
  }

  _getChapters(BuildContext context, String bibleId, String bookId) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    await scripture.getChapters(bibleId, bookId);

    scripture.filterChaptersByRef(startingString: "");
  }

  Future<bool> _onTap(Chapter item, BuildContext context) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.selectedChapter = item;
    scripture.verses = [];
    scripture.filteredVerses = [];
    if (Utils.hasBible(
        scripture.selectedBible, RemoteConfig.config.gatewayVersions)) {
      print("bible has been caught");
      String url =
          "https://www.biblegateway.com/passage/?search=${item.reference}";
      _showDialog(context, url);
    } else {
      Navigator.pushNamed(context, "/test", arguments: {
        "bible": scripture.selectedBible,
        "chapter": scripture.selectedChapter
      });
    }
  }

  String getTitle(Chapter item) {
    return item.reference;
  }

  String getSubtitle(Chapter item) {
    return this.selectedBook.name;
  }

  _filter(BuildContext context, String text) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.filterBooksByName(startingString: text);
  }

  _showDialog(BuildContext context, String url) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return RedirectionPopup(
            url: url,
          );
        });
    //TODO: make refresher function
  }
}
