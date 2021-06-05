import 'package:a_fathers_blessing_app/controller/all_provs.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/search/tag_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/search/text_search.dart';

class SearchBlessing extends StatefulWidget {
  @override
  _SearchBlessingState createState() => _SearchBlessingState();
}

class _SearchBlessingState extends State<SearchBlessing>
    with SingleTickerProviderStateMixin {
  MyBlessingProvider myBlessings;
  TruthBlessingProvider truthBlessings;
  TagProvider tags;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);

    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    myBlessings.clearSearches();
    truthBlessings.clearSearches();
    tags.clearSearches();
    //empty tag search
  }

  TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  @override
  Widget build(BuildContext context) {
    myBlessings = Provider.of<MyBlessingProvider>(context, listen: false);
    truthBlessings = Provider.of<TruthBlessingProvider>(context, listen: false);
    tags = Provider.of<TagProvider>(context, listen: false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Text(
                  "SEARCH BLESSINGS",
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      color: Colors.white,
                      fontSize: 23),
                ),
              )
            ],
          ),
          bottom: ColoredTabBar(
            color: Color(0xFFF9F9F9),
            tabBar: TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.black54,

              // isScrollable: true,
              // indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: "Search By Tags",
                ),
                Tab(
                  text: "Search By Text",
                ),
              ],
            ),
          ),
        ),
        // bottomSheet:
        body: Builder(builder: (context) {
          return TabBarView(
            controller: _tabController,
            children: [TagSearch(), new TextSearch()],
          );
        }));
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          myBlessings.resetTextSearch();
          truthBlessings.resetTextSearch();
          break;
        case 1:
          myBlessings.resetTagSearch();
          truthBlessings.resetTagSearch();
          tags.clearTagSearch();
          break;
      }
    }
  }
}

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar}) : super(color: color, child: tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;
}
