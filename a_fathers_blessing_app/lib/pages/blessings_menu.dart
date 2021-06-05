import 'package:a_fathers_blessing_app/controller/config.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/more_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BlessingsMenu extends StatefulWidget {
  static const List<Choice> choices = const <Choice>[
    const Choice(title: 'Manage Tags', icon: Icons.paste_rounded),
  ];

  @override
  _BlessingsMenuState createState() => _BlessingsMenuState();
}

class _BlessingsMenuState extends State<BlessingsMenu> {
  final String screenTitle = "BLESSINGS";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    MyBlessingProvider provider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            screenTitle,
            style: TextStyle(
                fontFamily: 'OpenSans-Bold', color: Colors.white, fontSize: 23),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/BlessingApp_WheatBackground_Blue.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  TruthBlessingProvider provider =
                      Provider.of<TruthBlessingProvider>(context,
                          listen: false);
                  // await provider.deleteMyBlessings();
                  provider.clearTruthBlessings();
                  Navigator.pushNamed(context, "/truth78_blessing_list");
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 50.0, 15, 0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage(
                            'assets/images/BlessingApp_Icons_100x100_Blessings.png'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'TRUTH78 BLESSINGS',
                        style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  MyBlessingProvider provider =
                      Provider.of<MyBlessingProvider>(context, listen: false);
                  // await provider.deleteMyBlessings();
                  // provider.fetchedLastDoc = false;
                  var box = Hive.box(Config.myBlessingBox);
                  print(box.values);
                  provider.clearMyBlessings();
                  Navigator.pushNamed(context, "/my_blessings_list_screen");
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage(
                            'assets/images/BlessingApp_Icons_100x100_MyBlessings.png'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'MY BLESSINGS',
                        style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          await _getTags(context);
                          Navigator.pushNamed(context, "/search_blessing");
                        } catch (e) {
                          Toast.show("Something went wrong", context);
                        } finally {
                          if (this.mounted) {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                  'assets/images/BlessingApp_Icons_100x100_Search.png'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'SEARCH',
                              style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        TagProvider prov =
                            Provider.of<TagProvider>(context, listen: false);
                        prov.clearAllTags();
                        Navigator.pushNamed(context, '/tags');
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                  'assets/images/BlessingApp_Icons_100x100_SaveTags.png'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'MANAGE\nTAGS',
                              style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        ScriptureProvider scripture =
                            Provider.of<ScriptureProvider>(context,
                                listen: false);
                        scripture.copiedText = "";
                        provider.initTempBlessing(userProvider.user);
                        setState(() {
                          loading = true;
                        });
                        try {
                          await _getTags(context);
                          Navigator.pushNamed(context, "/add_blessing");
                        } catch (e) {
                          Toast.show("Something went wrong", context);
                        } finally {
                          if (this.mounted) {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 35.0,
                              backgroundImage: AssetImage(
                                  'assets/images/BlessingApp_Icons_100x100_AddBlessing.png'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ADD\nBLESSING',
                              style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getTags(BuildContext context) async {
    TagProvider prov = Provider.of<TagProvider>(context, listen: false);
    UserProvider userProv = Provider.of<UserProvider>(context, listen: false);
    await prov.getMoreTags(userProv.user);
  }
}
