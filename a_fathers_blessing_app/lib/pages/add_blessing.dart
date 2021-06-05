import 'dart:ui';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/scripture/utils.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/common/confirmation_popup.dart';
import 'package:a_fathers_blessing_app/pages/components/tags/tags_popup.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/edit_screens/tag_textfield.dart';

class AddBlessing extends StatefulWidget {
  final String title = "ADD BLESSING";
  @override
  _AddBlessingState createState() => _AddBlessingState();
}

class _AddBlessingState extends State<AddBlessing> with WidgetsBindingObserver {
  TextEditingController referenceController = TextEditingController();
  TextEditingController blessingController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  bool loading = false;
  bool saved = false;
  bool exception = false;
  bool redirectAware = false;
  bool editing = false;
  bool copied = false;
  double _overlap = 0;
  FocusNode _focusNode = FocusNode();

  _getRedirectAware() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    redirectAware = false;
    //(prefs.getBool('redirectAware') ?? false);
  }

  @override
  void initState() {
    super.initState();
    getClipboard();
    WidgetsBinding.instance.addObserver(this);
    _getRedirectAware();
  }

  @override
  Widget build(BuildContext context) {
    MyBlessingProvider provider =
        Provider.of<MyBlessingProvider>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;

    _focusNode.addListener(() async {
      MyBlessingProvider prov =
          Provider.of<MyBlessingProvider>(context, listen: false);
      if (_focusNode.hasFocus) {
        if (copied) {
          copied = false;
          FlutterClipboard.paste().then((value) {
            setState(() {
              blessingController.text += value ?? "";
              prov.setTemporaryBlessingText(blessingController.text);
            });
          });
        }
        setState(() => editing = true);
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: Consumer<MyBlessingProvider>(
                builder: (context, blessingProv, child) {
                  referenceController.text = provider.temporaryBlessing.title;

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          //height: MediaQuery.of(context).size.height*0.803,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _hideKeyboard();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        _hideKeyboard();
                                      },
                                      child: Row(children: [
                                        Text(
                                          "ENTER TITLE OR BIBLE REFERENCE",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "OpenSans-Bold",
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5)),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 15, 5),
                                          child: TextFormField(
                                              // minLines: 2,
                                              onChanged: (String text) {
                                                provider.temporaryBlessing
                                                    .title = text;
                                              },
                                              onTap: () async {
                                                ClipboardData data =
                                                    await Clipboard.getData(
                                                        Clipboard.kTextPlain);
                                                print(data?.text ?? "s");
                                              },
                                              controller: referenceController,
                                              autocorrect: false,
                                              readOnly: false,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  hintText: "",
                                                  hintStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontFamily:
                                                          "Lato-Regular",
                                                      fontSize: 20)),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily:
                                                      "OpenSans-Regular",
                                                  color: Theme.of(context)
                                                      .accentColor)
                                                      ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String ref =
                                                referenceController.text;
                                            String url = parseUrl(ref);
                                            if (redirectAware) {
                                              await canLaunch(url)
                                                  ? await launch(url)
                                                  : throw 'Could not launch $widget.url';
                                              copied = true;
                                            } else
                                              _showDirectionDialog(
                                                  context, url);
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                "assets/images/BlessingApp_Icons_24x24_Search.png"),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _hideKeyboard();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 5, top: 25),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                      },
                                      child: Row(children: [
                                        Text(
                                          "PASTE OR ENTER BLESSING TEXT",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "OpenSans-Bold",
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _hideKeyboard();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 10, 0, _overlap),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.5,
                                                color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onChanged: (String text) {
                                              provider.setTemporaryBlessingText(
                                                  text);
                                            },
                                            focusNode: _focusNode,
                                            textCapitalization:
                                                  TextCapitalization.sentences,
                                            controller: blessingController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            expands: true,
                                            decoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Aleo-Regular',
                                              fontSize: 21,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          "assets/images/BlessingApp_Icons_24x24_Tag.png"),
                                      SizedBox(width: 10),
                                      Text(
                                        "TAGS",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "OpenSans-Bold",
                                            color: Theme.of(context)
                                                .secondaryHeaderColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer<MyBlessingProvider>(
                                    builder: (context, myProvider, child) {
                                  return TagTextField(
                                      tags: myProvider.temporaryBlessing.tags,
                                      onTap: () => _showTagDialog(context));
                                })
                              ],
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        FocusScope.of(context).requestFocus();
                                        ScriptureProvider prov =
                                            Provider.of<ScriptureProvider>(
                                                context,
                                                listen: false);
                                        FlutterClipboard.paste().then((value) {
                                          setState(() {
                                            blessingController.text +=
                                                value ?? "";
                                            blessingProv
                                                .setTemporaryBlessingText(
                                                    blessingController.text);
                                          });
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                "assets/images/BlessingApp_Icons_48x48_PasteVerse.png"),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Text(
                                                "PASTE VERSE",
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                  fontSize: 14,
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
                                            provider.temporaryBlessing);
                                        User user = userProvider.user;
                                        if (validation != null) {
                                          Toast.show(validation, context,
                                              duration: Toast.LENGTH_SHORT);
                                          return;
                                        }
                                        setState(() => loading = true);
                                        try {
                                          bool newId =
                                              await provider.saveNewBlessing(
                                                  user,
                                                  provider.temporaryBlessing);
                                          tagProvider.updateTagLists(
                                              userProvider.user);

                                          if (tagProvider.selectedTag != null) {
                                            String selectedTag =
                                                tagProvider.selectedTag.tagText;
                                            await provider
                                                .updateFilteredBlessings(
                                                    user, selectedTag);
                                          }
                                          setState(() => loading = false);
                                          Navigator.pop(context);
                                        } catch (e) {} finally {
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Text(
                                                "SAVE MY BLESSING",
                                                style: TextStyle(
                                                  fontSize: 14,
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
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _showTagDialog(BuildContext context) {
    MyBlessingProvider blessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);

    MyBlessing temporary = blessingProvider.temporaryBlessing;
    tagProvider.setTemporaryLists(tagProvider.tagsText, temporary.tags);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TagsPopup(context,
              blessingData: blessingProvider.temporaryBlessing,
              onTapOk: (BuildContext context, List<String> newTags) {
            blessingProvider.setTempBlessingTags(newTags);
          }, onError: (BuildContext context, var error) {
            Toast.show("Something went wrong", context);
          });
        });
  }

  _validate(MyBlessing blessing) {
    if (blessing.title == '') return "Reference cannot be empty";
    if (blessing.body.trim() == '') return 'Blessing text can not be empty';
    return;
  }

  _showDirectionDialog(BuildContext context, String url) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return RedirectionPopup(
              url: url,
              title: "ADD BLESSING",
              // cancelText: "killer",
              message: """You are being redirected biblegateway.com
Highlight the text, then use your phone’s copy function.  
Press Done to return to A Father’s Blessing App and Paste verse(s) into App
""",
              onTapOk: (BuildContext context) async {
                await canLaunch(url)
                    ? await launch(url)
                    : throw 'Could not launch $widget.url';
                copied = true;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("redirectAware", true);
                redirectAware = true;
                Navigator.pop(context);
              });
        });
    //TODO: make refresher function
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      0,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints - 200;
    if (overlap >= 20) {
      setState(() {
        _overlap = overlap - 10;
      });
    } else
      setState(() => _overlap = 10);
  }

  parseUrl(String ref) => Utils.parseGatewayUrl(Uri.encodeFull(ref));

  Future getClipboard() async {
    var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    print(clipboardData);
    print(clipboardData?.text);
  }

  _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
