import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/edit_screens/edit_screen.dart';
import 'package:a_fathers_blessing_app/pages/components/tags/tags_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'components/edit_screens/tag_textfield.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class EditMyBlessing extends StatefulWidget {
  EditMyBlessing({Key key}) : super(key: key);
  final String title = "EDIT MY BLESSING";
  bool playing = false;

  @override
  _EditMyBlessingState createState() => _EditMyBlessingState();
}

class _EditMyBlessingState extends State<EditMyBlessing> {
  TextEditingController blessingController = TextEditingController();
  bool loading = false;
  bool editing = false;
  FocusNode _focus = FocusNode();
  BuildContext childContext;

  @override
  Widget build(BuildContext context) {
    MyBlessingProvider blessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: true);
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    Size screen = MediaQuery.of(context).size;

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
                      fontSize: 23),
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
                        child: EditScreen(
                      title: blessingProvider.temporaryBlessing.title,
                      initialBlessing: blessingProvider.temporaryBlessing.body,
                      tags: blessingProvider.temporaryBlessing.tags,
                      onEditFocus: () => setState(() => editing = true),
                      onTagTap: _showDialog,
                      onTextChange: (String text) {
                        blessingProvider.temporaryBlessing.body = text;
                      },
                      onTitleChange: (BuildContext context, String text) {
                        blessingProvider.temporaryBlessing.title = text;
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
                        padding: const EdgeInsets.fromLTRB(5, 15, 3, 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    dynamic validation = _validate(
                                        blessingProvider.temporaryBlessing);
                                    if (validation != null) {
                                      Toast.show(validation, context,
                                          duration: Toast.LENGTH_SHORT);
                                      return;
                                    }
                                    setState(() => loading = true);
                                    try {
                                      User user = userProvider.user;
                                      bool status =
                                          await blessingProvider.saveBlessing(
                                              userProvider.user,
                                              blessingProvider
                                                  .temporaryBlessing);
                                      if (status) {
                                        blessingProvider.makeTempSelected();
                                        tagProvider.updateTagLists(user);

                                        if (tagProvider.selectedTag != null) {
                                          String selectedTag =
                                              tagProvider.selectedTag.tagText;
                                          await blessingProvider
                                              .updateFilteredBlessings(
                                                  user, selectedTag);
                                          await truthBlessingProvider
                                              .updateFilteredBlessings(
                                                  user, selectedTag);
                                        }
                                        if (this.mounted)
                                          Navigator.pop(context);
                                      } else {
                                        throw Exception;
                                      }
                                    } catch (e) {
                                      print(
                                          "===================== caught exception");
                                      print(e);
                                      Toast.show(
                                          "Something went wrong", context,
                                          duration: Toast.LENGTH_LONG);
                                    } finally {
                                      setState(() => loading = false);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AssetImage(
                                            "assets/images/BlessingApp_Icons_48x48_Save.png"),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.21,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "SAVE MY BLESSING",
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: 15,
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
                                  onTap: () async {
                                    dynamic validation = _validate(
                                        blessingProvider.temporaryBlessing);
                                    User user = userProvider.user;
                                    if (validation != null) {
                                      Toast.show(validation, context,
                                          duration: Toast.LENGTH_SHORT);
                                      return;
                                    }
                                    setState(() => loading = true);
                                    try {
                                      bool newId = await blessingProvider
                                          .saveNewBlessing(
                                              user,
                                              blessingProvider
                                                  .temporaryBlessing);
                                      tagProvider
                                          .updateTagLists(userProvider.user);

                                      if (tagProvider.selectedTag != null) {
                                        String selectedTag =
                                            tagProvider.selectedTag.tagText;
                                        await blessingProvider
                                            .updateFilteredBlessings(
                                                user, selectedTag);
                                        await truthBlessingProvider
                                            .updateFilteredBlessings(
                                                user, selectedTag);
                                      }
                                      Toast.show("New Blessing Saved", context,
                                          duration: Toast.LENGTH_SHORT);
                                    } catch (e) {
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
                                        radius: 25,
                                        backgroundImage: AssetImage(
                                            "assets/images/BlessingApp_Icons_48x48_SaveNewVersion.png"),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "SAVE\nNEW\nVERSION",
                                            style: TextStyle(
                                              fontSize: 15,
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
                      ),
                    )
                  ],
                )),
              ));
  }

  Future<void> _showDialog(BuildContext context) {
    MyBlessingProvider blessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);

    MyBlessing selected = blessingProvider.selectedBlessing;
    MyBlessing temporary = blessingProvider.temporaryBlessing;
    tagProvider.setTemporaryLists(tagProvider.tagsText, temporary.tags);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TagsPopup(context,
              blessingData: blessingProvider.selectedBlessing,
              onTapOk: (BuildContext context, List<String> newTags) async {
            User user = userProvider.user;
            bool status = await blessingProvider.saveTags(
                userProvider.user, blessingProvider.selectedBlessing, newTags);
            if (status) {
              blessingProvider.temporaryBlessing.tags = newTags;
              await tagProvider.updateTagLists(user);

              List<String> savedTags = blessingProvider.temporaryBlessing.tags;
              blessingProvider.setSeletedBlessingTags(savedTags);

              if (tagProvider.selectedTag != null) {
                String selectedTag = tagProvider.selectedTag.tagText;
                await blessingProvider.updateFilteredBlessings(
                    user, selectedTag);
                await truthBlessingProvider.updateFilteredBlessings(
                    user, selectedTag);
              }
              print("Done");
            } else {
              throw Exception;
            }
          }, onError: (BuildContext context, var error) {
            if (error is SocketException)
              Toast.show("Couldn't Connect to Server", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            else
              Toast.show("Something went wrong", context,
                  duration: Toast.LENGTH_LONG);
          });
        });
  }
}

_validate(MyBlessing blessing) {
  if (blessing.title == '') return "Reference cannot be empty";
  if (blessing.body.trim() == '') return 'Blessing text can not be empty';
  return;
}
