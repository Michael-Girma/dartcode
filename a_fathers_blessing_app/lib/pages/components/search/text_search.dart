import 'dart:async';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/tag/utils.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/SingularMyBlessingsView.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/myBlessingsView.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/truthBlessingsView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class TextSearch extends StatefulWidget {
  @override
  _TextSearchState createState() => _TextSearchState();
}

class _TextSearchState extends State<TextSearch> with TickerProviderStateMixin {
  TagProvider tagProvider;
  MyBlessingProvider myBlessings;
  TruthBlessingProvider truthBlessings;

  TabController _nestedTabController;
  bool searching = false;
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tagProvider = Provider.of<TagProvider>(context, listen: false);
    truthBlessings = Provider.of<TruthBlessingProvider>(context, listen: true);
    myBlessings = Provider.of<MyBlessingProvider>(context, listen: true);
    Debouncer _debouncer = Debouncer(milliseconds: 750);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              TextFormField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: "Search Blessing",
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w300),
                ),
                onChanged: (String text) {
                  _debouncer.run(() {
                    _refreshSearches(context);
                  });
                },
              ),
              Icon(Icons.search),
            ],
          ),
        ),
        searching
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child:
                    SpinKitFadingCircle(color: Theme.of(context).primaryColor),
              )
            : Column(children: [
                TabBar(
                  controller: _nestedTabController,
                  indicatorColor: Colors.teal,
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.black54,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      text: "My Blessings (${myBlessings.textSearched.length})",
                    ),
                    Tab(
                      text:
                          "Truth78 Blessings(${truthBlessings.textSearched.length})",
                    )
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  margin: EdgeInsets.only(left: 3.0, right: 3.0),
                  child: TabBarView(
                    controller: _nestedTabController,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  // flex: 12,
                                  child: Consumer2(
                                builder: (context,
                                    TagProvider tagProvider,
                                    MyBlessingProvider blessingProvider,
                                    child) {
                                  return TileMyBlessingView(
                                      context,
                                      _myBlessingRequester,
                                      blessingProvider
                                          .textSearched); //TODO: make _requester function
                                },
                              )),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  // flex: 12,
                                  child: Consumer2(
                                builder: (context,
                                    TagProvider tagProvider,
                                    TruthBlessingProvider blessingProvider,
                                    child) {
                                  return TruthBlessingView(
                                      context, _truthBlessingRequester,
                                      truthBlessings:
                                          blessingProvider.textSearched);
                                },
                              )),
                            ],
                          )),
                    ],
                  ),
                )
              ])
      ],
    );
  }

  Future<void> _refreshSearches(BuildContext context) async {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    MyBlessingProvider myBlessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);

    myBlessingProvider.resetTextSearch();
    truthBlessingProvider.resetTextSearch();

    String search = searchTextController.text;

    if (search.length > 0) {
      try {
        setState(() => searching = true);
        await myBlessingProvider.getMoreSearchResults(user.user, search);
        await truthBlessingProvider.getMoreSearchResults(user.user, search);
      } catch (e) {
        Toast.show("Something went wrong", context,
            duration: Toast.LENGTH_LONG);
      } finally {
        setState(() => searching = false);
      }
    }
  }

  _truthBlessingRequester(BuildContext context) async {
    print("NEXT PAGE REQUESTED =======================");
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    TruthBlessingProvider blessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String text = searchTextController.text;

    List<TruthBlessing> blessings =
        await blessingProvider.getMoreSearchResults(user.user, text);
    return blessings.length > 0;
  }

  _myBlessingRequester(BuildContext context) async {
    print("NEXT PAGE REQUESTED =======================");
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    MyBlessingProvider blessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String text = searchTextController.text;

    List<MyBlessing> blessings =
        await blessingProvider.getMoreSearchResults(user.user, text);
    return blessings.length > 0;
  }

}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
