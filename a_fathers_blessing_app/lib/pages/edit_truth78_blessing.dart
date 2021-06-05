import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/edit_screens/edit_screen.dart';
import 'package:a_fathers_blessing_app/pages/components/tags/tags_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'components/edit_screens/tag_textfield.dart';

class EditTruthBlessing extends StatefulWidget {
  final String title = "EDIT TRUTH78 BLESSING";
  @override
  _EditTruthBlessingState createState() => _EditTruthBlessingState();
}

class _EditTruthBlessingState extends State<EditTruthBlessing> {
  TextEditingController tagsController = TextEditingController();
  bool loading = false;
  bool editing = false;

  @override
  Widget build(BuildContext context) {
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    MyBlessingProvider myBlessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    tagsController.text =
        truthBlessingProvider.temporaryBlessing.tags.join(', ');

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: loading
            ? SpinKitCircle(
                color: Theme.of(context).primaryColor,
              )
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                    child: Column(
                  children: [
                    Expanded(
                        //height: MediaQuery.of(context).size.height*0.803,
                        child: EditScreen(
                      title: truthBlessingProvider.temporaryBlessing.title,
                      tags: truthBlessingProvider.temporaryBlessing.tags,
                      initialBlessing:
                          truthBlessingProvider.temporaryBlessing.body,
                      onEditFocus: () => setState(() => editing = true),
                      onTagTap: _showDialog,
                      onTextChange: (String text) {
                        truthBlessingProvider.temporaryBlessing.body = text;
                      },
                    )),
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
                        padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    dynamic validation = _validate(
                                        truthBlessingProvider
                                            .temporaryBlessing);
                                    if (validation != null) {
                                      Toast.show(validation, context,
                                          duration: Toast.LENGTH_SHORT);
                                      return;
                                    }
                                    setState(() => loading = true);
                                    try {
                                      User user = userProvider.user;
                                      bool status = await myBlessingProvider
                                          .saveTruthBlessing(
                                              userProvider.user,
                                              truthBlessingProvider
                                                  .temporaryBlessing);
                                      if (status) {
                                        await tagProvider.updateTagLists(user);

                                        if (tagProvider.selectedTag != null) {
                                          String selectedTag =
                                              tagProvider.selectedTag.tagText;
                                          await myBlessingProvider
                                              .updateFilteredBlessings(
                                                  user, selectedTag);
                                          await truthBlessingProvider
                                              .updateFilteredBlessings(
                                                  user, selectedTag);
                                        }

                                        Toast.show(
                                            "New Blessing Saved", context,
                                            duration: Toast.LENGTH_SHORT);
                                      } else {}
                                    } catch (e) {
                                      print(
                                          "===================== caught exception");
                                      print(e);
                                      Toast.show(
                                          "Something went wrong", context,
                                          duration: Toast.LENGTH_SHORT);
                                    } finally {
                                      setState(() => loading = false);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            "assets/images/BlessingApp_Icons_48x48_SaveNewVersion.png"),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.29,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "SAVE to MY BLESSING",
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
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
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            "assets/images/BlessingApp_Icons_100x100_Save.png"),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.29,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "DONE",
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: "OpenSans-Bold",
                                            ),
                                            maxLines: 4,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )
                  ],
                )),
              ));
  }

  Future<void> _showDialog(BuildContext context) {
    MyBlessingProvider myBlessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    TruthBlessing selected = truthBlessingProvider.selectedBlessing;
    TruthBlessing temporary = truthBlessingProvider.temporaryBlessing;

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);

    tagProvider.setTemporaryLists(tagProvider.tagsText, temporary.tags);

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return TagsPopup(
            context,
            blessingData: truthBlessingProvider.selectedBlessing,
            onTapOk: (BuildContext context, List<String> newTags) async {
              User user = userProvider.user;
              // await blessingProvider.saveExistingBlessing(user, blessingProvider.selectedBlessing, blessingProvider.temporaryBlessing);
              // await tagProvider.getTagsFromFirestore(userProvider.user);
              bool status = await truthBlessingProvider.saveTags(
                  userProvider.user,
                  TruthBlessing(
                    docId: truthBlessingProvider.temporaryBlessing.docId,
                    tags: newTags,
                  ));
              if (status) {
                truthBlessingProvider.temporaryBlessing.tags = newTags;
                truthBlessingProvider.makeTempSelected();
                await tagProvider.updateTagLists(user);

                if (tagProvider.selectedTag != null) {
                  String selectedTag = tagProvider.selectedTag.tagText;
                  await myBlessingProvider.updateFilteredBlessings(
                      user, selectedTag);
                  await truthBlessingProvider.updateFilteredBlessings(
                      user, selectedTag);
                }
              } else {
                throw new Exception();
              }
            },
            onError: (var error) {
              if (error is SocketException)
                Toast.show("Couldn't Connect to Server", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              else
                Toast.show("Something went wrong", context,
                    duration: Toast.LENGTH_LONG);
            },
          );
        });
  }

  _validate(TruthBlessing blessing) {
    if (blessing.title.trim() == '') return "Reference can not be empty";
    if (blessing.body.trim() == "") return 'Blessing text can not be empty';
    return;
  }
}
