import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/tag/utils.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/blessing.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TagsPopup extends StatefulWidget {
  var blessingData;
  final Function onTapOk;
  final Function onError;

  TagsPopup(BuildContext context,
      {this.blessingData, this.onTapOk, this.onError});

  @override
  _TagsPopupState createState() => _TagsPopupState();
}

class _TagsPopupState extends State<TagsPopup> {
  List<String> tags = [];
  TextEditingController newTagController = TextEditingController();
  List<String> selectedTags = [];
  FocusNode _focusNode = FocusNode();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    var blessingProvider = _decideProvider(context, widget.blessingData);

    print("THIS IS THE BUILD BEGINNING");

    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/BlessingApp_Icons_24x24_Tag.png"),
          SizedBox(width: 10),
          Text("SELECT TAGS",
              style: TextStyle(
                  fontFamily: "OpenSans-Bold",
                  color: Colors.lightBlue[800],
                  fontSize: 22)),
        ],
      ),
      content: Consumer<TagProvider>(builder: (context, tagProvider, child) {
        // _buildTags(
        //     blessingTags: tagProvider.selectedTempTags, allTags: tagProvider.allTempTags);
        print("rebuilding consumer tab by ${tags.length} tags");
        return Container(
          height: MediaQuery.of(context).size.height *
              0.65, // Change as per your requirement
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            // physics: NeverScrollableScrollPhysics(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: tagProvider.allTempTags.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 24,
                      child: CheckboxListTile(
                        // checkColor: Colors.blue[800],
                        // activeColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(width: 10, color: Colors.black)),
                        title: Text(
                          tagProvider.allTempTags[index],
                          style: TextStyle(
                            fontFamily: "Lato-Regular",
                            fontSize: 18,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: tagProvider.selectedTempTags
                            .contains(tagProvider.allTempTags[index]),
                        onChanged: (bool selected) {
                          if (selected) {
                            tagProvider.addToSelectedTemporaryTags(
                                tagProvider.allTempTags[index]);
                          } else {
                            tagProvider.removeFromSelectedTemporaryTags(
                                tagProvider.allTempTags[index]);
                          }
                          print(selectedTags);
                        },
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: newTagController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: "NEW TAG",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add_box_rounded,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                              onPressed: () {
                                String newTagText = newTagController.text;
                                // implementation for adding new tag goes here
                                if (newTagText.trim() == "") {
                                  return;
                                }
                                if (Utils.tagExists(newTagText,
                                    allTags: tagProvider.allTempTags)) {
                                  Toast.show("Tag Already Exists", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                  return;
                                  //render a snackbar or something indicating that the tag exists TODO:
                                } else {
                                  tagProvider.addToAllTemporaryTags(newTagText,
                                      position: 0);
                                  tagProvider
                                      .addToSelectedTemporaryTags(newTagText);
                                  Toast.show("Tag Added", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                  newTagController.text = "";
                                }
                              },
                            )),
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      loading == false
                          ? TextButton(
                              child: Text("SAVE",
                                  style: TextStyle(
                                      color: Colors.lightBlue[800],
                                      fontSize: 18,
                                      fontFamily: "Lato-Regular")),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  List<String> tags =
                                      tagProvider.selectedTempTags;
                                  await widget.onTapOk(context, tags);
                                  Navigator.pop(context);
                                } catch (error) {
                                  widget.onError(context, error);
                                } finally {
                                  setState(() {
                                    loading = false;
                                  });
                                }

                                // blessingProvider.setTempBlessingTags(
                                //     tagProvider.selectedTempTags);
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CupertinoActivityIndicator(),
                            ),
                      loading == false
                          ? TextButton(
                              child: Text("CANCEL",
                                  style: TextStyle(
                                      color: Colors.lightBlue[800],
                                      fontSize: 18,
                                      fontFamily: "Lato-Regular")),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          : CupertinoActivityIndicator(),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      }),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(width: 5, color: Color(0xFFCF993D))),
    );
  }

  _decideProvider(BuildContext context, var blessingData) {
    if (blessingData.runtimeType == MyBlessing) {
      return Provider.of<MyBlessingProvider>(context, listen: false);
    } else if (blessingData.runtimeType == TruthBlessing) {
      return Provider.of<TruthBlessingProvider>(context, listen: false);
    }
  }
}
