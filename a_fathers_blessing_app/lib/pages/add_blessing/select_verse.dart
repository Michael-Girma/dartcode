import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/models/scripture/bible.dart';
import 'package:a_fathers_blessing_app/models/scripture/chapter.dart';
import 'package:a_fathers_blessing_app/models/scripture/verse.dart';
import 'package:a_fathers_blessing_app/pages/add_blessing/display_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SelectVerse extends StatefulWidget {
  SelectVerse({Key key}) : super(key: key);
  final String title = "SELECT VERSE";

  @override
  _SelectVerseState createState() => _SelectVerseState();
}

class _SelectVerseState extends State<SelectVerse> {
  Bible selectedBible;
  Chapter selectedChapter;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    this.selectedBible = data["bible"];
    this.selectedChapter = data["chapter"];

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
            future: _getVerses(context, selectedBible.id, selectedChapter.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<ScriptureProvider>(
                  builder: (context, scripture, child) {
                    return DisplayList(
                      scripture.filteredVerses,
                      getTitle,
                      getSubtitle,
                      _onTap,
                      _filter,
                      "FILTER VERSES BY REFERENCE"
                    );
                  }
                );
              } 
              else
                return SpinKitFadingCircle(
                  color: Theme.of(context).primaryColor,
                );
            }
          );
        },
      ),
    );
  }

  _getVerses(BuildContext context, String bibleId, String chapterId) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    await scripture.getVerses(bibleId, chapterId);

    scripture.filterVersesByRef(startingString: "");
  }

  Future<bool> _onTap(Verse item, BuildContext context) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    String bibleId = scripture.selectedBible.id;
    String verseId = item.id;

    Verse verse = await scripture.getVerse(bibleId, verseId);
    scripture.selectedVerse = verse;

    // scripture.selectedChapter = item;
    Navigator.pushNamed(context, "/verse_view");
  }

  String getTitle(Verse item) {
    return item.reference;
  }

  String getSubtitle(Verse item) {
    return this.selectedChapter.reference;
  }

  _filter(BuildContext context, String text) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.filterVersesByRef(startingString: text);
  }

  //TODO: make refresher function
}
