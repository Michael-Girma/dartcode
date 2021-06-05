import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/scripture/scripture.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/scripture/bible.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/add_blessing/display_list.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/truthBlessingsView.dart';
import 'package:flutter/material.dart';
import 'package:a_fathers_blessing_app/models/blessings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:a_fathers_blessing_app/pages/single_blessing.dart';
import 'package:a_fathers_blessing_app/models/pass_data.dart';
import 'package:synchronized/synchronized.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SelectBible extends StatefulWidget {
  SelectBible({Key key}) : super(key: key);
  final String title = "SELECT BIBLE";

  @override
  _SelectBibleState createState() => _SelectBibleState();
}

class _SelectBibleState extends State<SelectBible> {
  String filterText = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

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
          )),
      body: Consumer<TruthBlessingProvider>(
        builder: (context, truthBlessingProvider, child) {
          return FutureBuilder(
              future: _getBibles(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<ScriptureProvider>(
                      builder: (context, scriptur, child) {
                    return DisplayList(
                        scripture.filteredBibles,
                        getTitle,
                        getSubtitle,
                        _onTap,
                        _filter,
                        "FILTER BIBLES BY ABBREVIATION");
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

  _getBibles(BuildContext context) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);
    await scripture.getBibles();
    scripture.bibles.addAll(RemoteConfig.config.gatewayVersions);
    scripture.sortBibles();
    scripture.filterBibleByAbbreviation(startingString: "");
  }

  Future<bool> _onTap(Bible bible, BuildContext context) async {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.selectedBible = bible;
    scripture.books = [];
    scripture.filteredBooks = [];
    Navigator.pushNamed(context, '/select_book', arguments: bible.id);
  }

  String getTitle(Bible item) {
    return item.abbreviation;
  }

  String getSubtitle(Bible item) {
    return item.name;
  }

  _filter(BuildContext context, String text) {
    ScriptureProvider scripture =
        Provider.of<ScriptureProvider>(context, listen: false);

    scripture.filterBibleByAbbreviation(startingString: text);
  }

  //TODO: make refresher function
}
