import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/more_menu.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/delete_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:a_fathers_blessing_app/pages/edit_truth78_blessing.dart';
import 'package:a_fathers_blessing_app/pages/edit_my_blessing.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class BlessingScreen extends StatefulWidget {
  BlessingScreen({Key key}) : super(key: key);
  bool playing = false;

  final String editBlessingChoice = "Edit Blessing";
  final String deleteBlessingChoice = "Delete Blessing";

  @override
  _BlessingScreenState createState() => _BlessingScreenState();
}

class _BlessingScreenState extends State<BlessingScreen> {
  static MyBlessing myBlessing;
  static dynamic selectedBlessing;
  List<Choice> choices = [];
  String screenTitle = "BLESSING";

  bool isLoading = false;

  @override
  void initState() {
    choices = <Choice>[
      // const Choice(title: 'Play Blessing', icon: Icons.play_arrow),
      Choice(title: widget.editBlessingChoice, icon: Icons.edit),
      // const Choice(title: 'Record Blessing', icon: Icons.mic),
      // const Choice(title: 'Send Blessing', icon: Icons.send),
      // const Choice(title: 'Memorize Blessing', icon: Icons.article_rounded),
      Choice(title: widget.deleteBlessingChoice, icon: Icons.delete),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic blessing = ModalRoute.of(context).settings.arguments;
    selectedBlessing = blessing;
    if (blessing.runtimeType == MyBlessing) {
      screenTitle = "MY BLESSINGS";
      myBlessing = ModalRoute.of(context).settings.arguments;
    } else if (blessing.runtimeType == TruthBlessing) {
      screenTitle = "TRUTH78 BLESSINGS";
    }

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
                    screenTitle,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        color: Colors.white,
                        fontSize: 23),
                  ),
                ),
                // Row(
                //   children: [
                //     GestureDetector(
                //       onTap: () {},
                //       child: CircleAvatar(
                //         radius: 15,
                //         backgroundImage: AssetImage(
                //             "assets/images/BlessingApp_Icons_100x100_Play.png"),
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     GestureDetector(
                //       onTap: () {},
                //       child: CircleAvatar(
                //         radius: 15,
                //         backgroundImage: AssetImage(
                //             "assets/images/BlessingApp_Icons_100x100_Memorized.png"),
                //       ),
                //     ),
                //     SizedBox(width: 20),
                //     //Icon(Icons.more_vert, color: Colors.white, size: 30,),
                //   ],
                // ),
              ],
            ),
            actions: <Widget>[
              PopupMenuButton<Choice>(
                color: Theme.of(context).primaryColor,
                onSelected: (Choice selected) {
                  _select(context, selected);
                },
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    if (choice.title == choices[choices.length - 1].title &&
                        blessing.runtimeType == TruthBlessing) {
                      return null;
                    }
                    return PopupMenuItem<Choice>(
                        textStyle: TextStyle(
                            fontFamily: 'Lato-Regular', color: Colors.white),
                        value: choice,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(
                                choice.icon,
                                color: Colors.white,
                              ),
                            ),
                            Text(choice.title),
                          ],
                        ));
                  }).toList();
                },
              ),
            ]),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: SpinKitFadingCircle(
            color: Theme.of(context).primaryColor,
          ),
          child: Consumer2(builder: (context,
              MyBlessingProvider myBlessingProvider,
              TruthBlessingProvider truthBlessingProvider,
              child) {
            return Container(
                child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 20, 25, 5),
                        child: Text(
                          blessing.runtimeType == MyBlessing
                              ? myBlessingProvider.selectedBlessing.title
                              : truthBlessingProvider.selectedBlessing
                                  .title, //This is a mock data template defined under models/blessing.dart
                          style: TextStyle(
                              fontSize: 27,
                              fontFamily: "OpenSans-Bold",
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                      ),
                      SizedBox(height: 25),
                      Expanded(
                        child: ListView(shrinkWrap: true, children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 10),
                            child: Text(
                                blessing.runtimeType == MyBlessing
                                    ? myBlessingProvider.selectedBlessing.body
                                    : truthBlessingProvider
                                        .selectedBlessing.body,
                                style: TextStyle(
                                  fontFamily: "Aleo-Regular",
                                  fontSize: 21,
                                )),
                          ),
                        ]),
                      ),
                      Divider(
                        height: 15,
                        color: Color(0xFFCF993D),
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 5, 25, 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                flex: 1,
                                child: Image.asset(
                                    "assets/images/BlessingApp_Icons_24x24_Tag.png")),
                            SizedBox(width: 3),
                            Flexible(
                                flex: 10,
                                child: Text(
                                    blessing.runtimeType == MyBlessing
                                        ? _getTags(myBlessingProvider
                                            .selectedBlessing.tags)
                                        : _getTags(truthBlessingProvider
                                            .selectedBlessing.tags),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Lato-Regular",
                                        color: Theme.of(context).accentColor)))
                          ],
                        ),
                      ) //TODO: Try to make reference to the primary color
                    ],
                  ),
                ),
                Container(
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
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _routeToEdit(context, blessing);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  "assets/images/BlessingApp_Icons_100x100_Edit.png"),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: CircleAvatar(
                          //     radius: 30,
                          //     backgroundImage: AssetImage(
                          //         "assets/images/BlessingApp_Icons_100x100_Record.png"),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: CircleAvatar(
                          //     radius: 30,
                          //     backgroundImage: AssetImage(
                          //         "assets/images/BlessingApp_Icons_100x100_Send.png"),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: CircleAvatar(
                          //     radius: 30,
                          //     backgroundImage: AssetImage(
                          //         "assets/images/BlessingApp_Icons_100x100_Memorize.png"),
                          //   ),
                          // ),
                        ]),
                  ),
                )
              ],
            ));
          }),
        ));
  }

  String _getTags(List<dynamic> tags) {
    if (tags.length > 0) {
      return tags.join(", ");
    } else {
      return "None";
    }
  }

  void _select(BuildContext context, Choice choice) async {
    print("selected");
    if (choice.title == widget.editBlessingChoice) {
      _routeToEdit(context, selectedBlessing);
    }
    if (choice.title == widget.deleteBlessingChoice) {
      _showDeleteDialog(context, myBlessing);
    }
  }

  _showDeleteDialog(BuildContext context, MyBlessing blessing) {
    print("IN HERE");
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DeleteBlessingPopup(
            myBlessing: blessing,
          );
        });
  }

  _routeToEdit(BuildContext context, dynamic blessing) async {
    MyBlessingProvider myBlessings =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TruthBlessingProvider truthBlessings =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    TagProvider tags = Provider.of<TagProvider>(context, listen: false);
    UserProvider userProv = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    try {
      await tags.getMoreTags(userProv.user);
      if (blessing.runtimeType == MyBlessing) {
        myBlessings.makeTempFromSelected();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditMyBlessing(),
              settings: RouteSettings(arguments: blessing)),
        );
      } else {
        truthBlessings.makeTempFromSelected();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditTruthBlessing(),
              settings: RouteSettings(arguments: blessing)),
        );
      }
    } catch (e) {
      if (e is SocketException) {
        Toast.show("Couldn't Connect to Server", context);
      } else
        Toast.show("Something Went Wrong", context);
    } finally {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
