import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/truthBlessingsView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/blessings/SingularMyBlessingsView.dart';

class TaggedBlessings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          bottom: ColoredTabBar(
            color: Colors.white,
            tabBar: TabBar(
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Colors.yellowAccent[800],
              unselectedLabelColor: Theme.of(context).primaryColor,
              automaticIndicatorColorAdjustment: true,
              // indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: "Truth78 Blessings",
                ),
                Tab(text: "My Blessings"),
              ],
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Text(
                  "TAGGED BLESSINGS",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      color: Colors.white,
                      fontSize: 23),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<TruthBlessingProvider>(
              builder: (context, truthBlessingProvider, child) {
                return TruthBlessingView(context, _truthBlessingRequester,
                    truthBlessings: truthBlessingProvider.filteredBlessings);
              },
            ),
            Consumer<MyBlessingProvider>(
              builder: (context, myBlessingProvider, child) {
                return TileMyBlessingView(
                    context,
                    _myBlessingRequester,
                    myBlessingProvider
                        .filteredBlessings); //TODO: make requester function
              },
            ),
          ],
        ),
      ),
    );
  }

  _truthBlessingRequester(context) async {
    print("NEXT PAGE REQUESTED =======================");
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    TruthBlessingProvider blessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String selectedTag = tagProvider.selectedTag.tagText;

    List<TruthBlessing> blessings = await blessingProvider
        .getMoreTaggedBlessings(user.user, [selectedTag], filter: true);
    return blessings.length > 0;
  }

  _myBlessingRequester(context) async {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    MyBlessingProvider blessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String selectedTag = tagProvider.selectedTag.tagText;

    // List<MyBlessing> blessing = await blessingProvider.getTaggedBlessings(blessingIds, user.user);
    List<MyBlessing> blessings = await blessingProvider
        .getMoreTaggedBlessings(user.user, [selectedTag], filter: true);
    return blessings.length > 0;
  }
}

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar}) : super(color: color, child: tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;
}
