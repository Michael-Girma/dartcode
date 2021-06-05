import 'package:a_fathers_blessing_app/controller/all_provs.dart';
import 'package:a_fathers_blessing_app/controller/scripture/utils.dart';
import 'package:a_fathers_blessing_app/models/scripture/bible.dart';
import 'package:a_fathers_blessing_app/models/scripture/chapter.dart';
import 'package:a_fathers_blessing_app/models/scripture/verse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class VerseSelector extends StatefulWidget {
  String title = "Select Verses";
  VerseSelector();

  @override
  _VerseSelectorState createState() => _VerseSelectorState();
}

class _VerseSelectorState extends State<VerseSelector> {
  List<Verse> allModels = [];
  List<int> selected = [];

  bool loading = false;
  Bible selectedBible;
  Chapter selectedChapter;

  _getItems(
    BuildContext context,
  ) async {
    setState(() {
      loading = true;
    });
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    String bibleId = scripture.selectedBible.id;
    String chapterId = scripture.selectedChapter.id;
    try {
      await _getVerses(context, bibleId, chapterId);
    } catch (e) {
      Toast.show("Something Wrong Happened", context,
          duration: Toast.LENGTH_SHORT);
    } finally {
      if (this.mounted)
        setState(() {
          loading = false;
        });
    }
  }

  @override
  void initState() {
    _getItems(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    Map data = ModalRoute.of(context).settings.arguments;

    this.selectedBible = data["bible"];
    this.selectedChapter = data["chapter"];

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
        body: ModalProgressHUD(
            opacity: 0.1,
            inAsyncCall: loading,
            progressIndicator:
                SpinKitFadingCircle(color: Theme.of(context).primaryColor),
            child: RefreshIndicator(
              onRefresh: () async {
                _getItems(context);
                return;
              },
              child: Container(
                  child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: allModels.length,
                      itemBuilder: (context, index) {
                        ScriptureProvider provider =
                            Provider.of<ScriptureProvider>(context,
                                listen: false);

                        return CheckboxListTile(
                          value: getValue(index),
                          onChanged: (bool value) {
                            print(selected);
                            _onChanged(value, selected, index);
                            print("AFTER ${selected}");
                          },
                          title: ExpansionTile(
                            childrenPadding: EdgeInsets.zero,
                            title: Text(allModels[index].reference,
                                style: TextStyle(
                                    fontFamily: 'lato-regular', fontSize: 22)),
                            children: [
                              allModels[index].text != ''
                                  ? Text(
                                      allModels[index].text,
                                      style: TextStyle(
                                          fontFamily: 'lato-regular',
                                          fontSize: 18),
                                      textAlign: TextAlign.left,
                                    )
                                  : FutureBuilder(
                                      future:
                                          _getVerse(allModels[index], context),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Text(
                                            allModels[index].text,
                                            style: TextStyle(
                                                fontFamily: 'lato-regular',
                                                fontSize: 18),
                                            textAlign: TextAlign.left,
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return SpinKitFadingCircle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          );
                                        }
                                      })
                            ],
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Theme.of(context).primaryColor,
                          thickness: 1,
                        );
                      },
                    ),
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
                                List<Verse> selectedVerses;
                                if (selected.length == 0) {
                                  Toast.show(
                                      "Select At Least 1 Blessing", context);
                                  return;
                                }
                                selectedVerses = selected.length == 1
                                    ? <Verse>[allModels[selected[0]]]
                                    : allModels.sublist(
                                        selected[0], selected[1] + 1);
                                bool checked =
                                    Utils.allVersesHaveText(selectedVerses);

                                if (checked) {
                                  String reference = Utils.generateReference(
                                      selectedChapter.reference,
                                      selected
                                          .map((element) => element + 1)
                                          .toList());
                                  String text =
                                      Utils.getBlessingText(selectedVerses);
                                  scripture.setSelectedVerse(
                                      ref: reference, text: text);

                                  Navigator.pushNamed(context, '/verse_view');
                                } else {
                                  Toast.show(
                                      "Blessing you select didn't load properly. Please refresh this page",
                                      context);
                                }
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        "assets/images/BlessingApp_Icons_100x100_Blessings.png"),
                                  ),
                                  Container(
                                    // width: MediaQuery.of(context).size.width * 0.,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 5, 10, 5),
                                      child: Text(
                                        "GENERATE\nBLESSING",
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
              )),
            )));
  }

  bool getValue(int index) {
    if (selected.length == 0)
      return false;
    else if (selected.length == 1) {
      if (index == selected[0])
        return true;
      else
        return false;
    } else if (index >= selected[0] && index <= selected[selected.length - 1])
      return true;
    else
      return false;
  }

  void _onChanged(bool value, List<int> selected, int index) {
    if (value == false)
      removeFromSelected(selected, index);
    else
      addToSelected(selected, index);
    setState(() {});
  }

  void removeFromSelected(List<int> selected, int index) {
    if (selected.length == 1)
      selected.removeAt(0);
    else if (selected.length == 2) {
      int midIndex = selected[0] + selected[1];
      double midline = midIndex / 2;
      if (index < midline) {
        selected[0] = index + 1;
      } else
        selected[1] = index - 1;
      if (selected[0] == selected[1]) selected.removeAt(1);
    }

    print(selected);
  }

  void addToSelected(List<int> selected, int index) {
    if (selected.length == 0)
      selected.add(index);
    else if (selected.length == 1) {
      if (index > selected[0])
        selected.add(index);
      else
        selected.insert(0, index);
    } else if (selected.length == 2) {
      if (index < selected[0])
        selected[0] = index;
      else
        selected[selected.length - 1] = index;
    }
  }

  _getVerses(BuildContext context, String bibleId, String chapterId) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    await scripture.getVerses(bibleId, chapterId);
    this.allModels = scripture.verses;
    scripture.filterVersesByRef(startingString: "");
  }

  Future<bool> _getVerse(Verse item, BuildContext context) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    String bibleId = scripture.selectedBible.id;
    String verseId = item.id;

    Verse verse = await scripture.getVerse(bibleId, verseId);
    item.text = verse.text;

    // scripture.selectedChapter = item;
    // Navigator.pushNamed(context, "/verse_view");
  }
}
