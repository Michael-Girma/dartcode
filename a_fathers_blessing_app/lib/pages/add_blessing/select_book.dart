import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/models/scripture/book.dart';
import 'package:a_fathers_blessing_app/pages/add_blessing/display_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SelectBook extends StatefulWidget {
  SelectBook({Key key}) : super(key: key);
  final String title = "SELECT BOOK";

  @override
  _SelectBookState createState() => _SelectBookState();
}

class _SelectBookState extends State<SelectBook> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    String bibleId = ModalRoute.of(context).settings.arguments;

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
              future: _getBooks(context, bibleId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<ScriptureProvider>(
                      builder: (context, scripture, child) {
                    return DisplayList(scripture.filteredBooks, getTitle,
                        getSubtitle, _onTap, _filter, "FILTER BOOKS BY NAME");
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

  _getBooks(BuildContext context, String bibleId) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    await scripture.getBooks(bibleId);
    scripture.sortBibles();
    scripture.filterBooksByName(startingString: "");
  }

  Future<bool> _onTap(Book item, BuildContext context) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.selectedBook = item;
    scripture.chapters = [];
    scripture.filteredChapters = [];
    Navigator.pushNamed(context, "/select_chapter", arguments: {
      "bible": scripture.selectedBible,
      "book": scripture.selectedBook
    });
  }

  String getTitle(Book item) {
    return item.abbreviation;
  }

  String getSubtitle(Book item) {
    return item.name;
  }

  _filter(BuildContext context, String text) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.filterBooksByName(startingString: text);
  }

  //TODO: make refresher function
}
