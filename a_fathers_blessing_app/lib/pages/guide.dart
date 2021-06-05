import 'dart:convert';
import 'dart:ui';
import 'package:easy_rich_text/easy_rich_text.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class GuidePage extends StatefulWidget {
  final String title = "GUIDE";
  final int initialChapter;

  GuidePage({Key key, this.initialChapter}) : super(key: key);
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int page;
  bool loading = true;
  Map data = {'title': ' ', 'body': ' ', 'footers': <Map<String, String>>[]};
  List footers = <Map<String, String>>[];
  //   {
  //     "title": "1",
  //     "content":
  //         'this is a joke lomga sosidfhaioehf euifh aiuefb uiebf ueifb uief euis feiu bfeiufb ieusbf iesub fiseua bfiseb fiue bfiuas befise bfiueb fiasebf iueb fieu fbisauf biue bfiub uiasb fiue bfuiase bfuie fbes'
  //   }
  // ];

  Future<void> loadJsonData() async {
    setState(() => loading = true);
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString("assets/files/chapter_$page.json");
    setState(() {
      data = json.decode(jsonString);
      print(data);
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    page = widget.initialChapter == 0 ? 1 : widget.initialChapter;
    loadJsonData();
  }

  int calculateRead(String body) {
    var words = body.split(' ').length;
    var minutes = words / 200;
    return minutes.ceil();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: false);

    int timeToRead = 0;

    if (!loading) {
      timeToRead = calculateRead(data['body']);
    }

    String body = data["body"];

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
                fontSize: 27,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                //height: MediaQuery.of(context).size.height*0.803,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text("$page. ${data['title']}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontFamily: 'OpenSans-Bold',
                                      fontSize: 30))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Text("$timeToRead minute read",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Lato-Regular',
                                      fontSize: 18))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: EasyRichText(
                                body,
                                defaultStyle: TextStyle(
                                    fontFamily: 'Aleo-Regular',
                                    fontSize: 20,
                                    color: Colors.black),
                                patternList: [
                                  EasyRichTextPattern(
                                    targetString: r"<sup> *[A-z0-9]* *</sup>",
                                    superScript: true,
                                    matchOption: 'all',
                                    matchBuilder: (BuildContext context,
                                        RegExpMatch match) {
                                      return WidgetSpan(
                                        baseline: TextBaseline.alphabetic,
                                        child: EasyRichText(
                                            match[0]
                                                .replaceAll('<sup>', '')
                                                .replaceAll('</sup>', ''),
                                            defaultStyle:
                                                TextStyle(fontSize: 20),
                                            patternList: [
                                              EasyRichTextPattern(
                                                  targetString: '.*',
                                                  superScript: true,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      // fontFamily:
                                                      //     'Aleo-Regular',
                                                      fontWeight:
                                                          FontWeight.w200))
                                            ]),
                                      );
                                    },
                                    matchWordBoundaries: false,
                                  ),
                                ],
                              )),
                          Divider(color: Theme.of(context).primaryColor),
                          ...List.generate(data["footers"]?.length, (index) {
                            footers = data["footers"];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${footers[index]["title"]}.  "),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    footers[index]["content"],
                                    textAlign: TextAlign.justify,
                                  ),
                                ))
                              ],
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //FOOTER
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 3,
                          color: Color(
                              0xFFCF993D)), //TODO: Try to make reference to the primary color
                    ),
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/BlessingApp_WheatBackground_Blue.jpg"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 3, 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (page != 1) {
                                  page -= 1;
                                  _scrollController.jumpTo(0);
                                  loadJsonData();
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_back,
                                    color: page == 1
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Text(
                                      "PREVIOUS",
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: page == 1
                                            ? Colors.grey
                                            : Colors.white,
                                        fontFamily: "OpenSans-Bold",
                                      ),
                                      maxLines: 4,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (page != 7) {
                                  page += 1;
                                  _scrollController.jumpTo(0);
                                  loadJsonData();
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child: Text(
                                      "NEXT",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: page == 7
                                            ? Colors.grey
                                            : Colors.white,
                                        fontFamily: "OpenSans-Bold",
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward,
                                    color: page == 7
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
