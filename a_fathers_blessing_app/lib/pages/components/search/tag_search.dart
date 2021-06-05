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
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class TagSearch extends StatefulWidget {
  @override
  _TagSearchState createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> with TickerProviderStateMixin {
  MyBlessingProvider myBlessings;
  TruthBlessingProvider truthBlessings;
  TagProvider tagProvider;

  TabController _nestedTabController;
  bool searching = false;

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myBlessings = Provider.of<MyBlessingProvider>(context, listen: false);
    truthBlessings = Provider.of<TruthBlessingProvider>(context, listen: false);
    tagProvider = Provider.of<TagProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
            child: SearchableDropdown.single(
              selectedValueWidgetFn: (value) {
                return Row(children: [
                  Text("Select Tags", textAlign: TextAlign.center)
                ]);
              },
              items: makeTagDropdownList(context),
              hint: Text("Select Tags"),
              isExpanded: true,
              onChanged: (String selectedIndex) {
                if (selectedIndex != null) {
                  tagProvider.addTagSearchItem(selectedIndex);
                  _refreshSearches(context);
                }

                //print("=====selected blessings==== ${tagProvider.tagSearch}");
              },
              onClear: () {
                tagProvider.clearSearches();
                myBlessings.clearSearches();
                truthBlessings.clearSearches();
              },
            )),
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child:
                Consumer<TagProvider>(builder: (context, tagProvider, child) {
              return ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: tagProvider.tagSearch.length > 0
                    ? List<Widget>.generate(tagProvider.tagSearch.length,
                        (int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 3.0, left: 3),
                          child: Chip(
                            label: Text(tagProvider.tagSearch[index]),
                            deleteIcon: Icon(Icons.highlight_remove_rounded),
                            onDeleted: () {
                              tagProvider.removeTagSearchItem(
                                  tagProvider.tagSearch[index]);
                              _refreshSearches(context);
                              // print("deleted");
                            },
                          ),
                        );
                      }).toList()
                    : [
                        Text(
                          "No Tags Selected",
                          textAlign: TextAlign.center,
                        )
                      ],
              );
            }),
          ),
        ),
        Consumer2<MyBlessingProvider, TruthBlessingProvider>(
          builder: (context, myBlessings, truthBlessings, _) {
            int myBlessingsResults = myBlessings.tagSearched.length;
            int truthBlessingResults = truthBlessings.tagSearched.length;
            if (tagProvider.tagSearch.length == 0) {
              myBlessingsResults = 0;
              truthBlessingResults = 0;
            }
            return TabBar(
              controller: _nestedTabController,
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.black54,
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  text: "My Blessings ($myBlessingsResults)",
                ),
                Tab(
                  text: "Truth78 Blessings ($truthBlessingResults)",
                )
              ],
            );
          },
        ),
        Expanded(
          flex: 20,
          child: Container(
            // height: screenHeight * 0.65,
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
                          child: Consumer<TagProvider>(
                              builder: (context, tagProvider, child) {
                            return Consumer<MyBlessingProvider>(
                              builder: (context, myBlessingProvider, child) {
                                if (searching) {
                                  return SpinKitFadingCircle(
                                      color: Theme.of(context).primaryColor);
                                }
                                return tagProvider.tagSearch.length > 0
                                    ? TileMyBlessingView(
                                        context,
                                        _myBlessingRequester,
                                        myBlessingProvider.tagSearched)
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Select Tags to Search",
                                          textAlign: TextAlign.center,
                                        ),
                                      ); //TODO: make requester function
                              },
                            );
                          }),
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          // flex: 12,
                          child: Consumer<TagProvider>(
                              builder: (context, tagProvider, child) {
                            return Consumer<TruthBlessingProvider>(
                              builder: (context, truthBlessingProvider, child) {
                                return tagProvider.tagSearch.length > 0
                                    ? TruthBlessingView(
                                        context, _truthBlessingRequester,
                                        truthBlessings:
                                            truthBlessingProvider.tagSearched)
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Select Tags to Search",
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                              },
                            );
                          }),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        )
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

    myBlessingProvider.resetTagSearch();
    truthBlessingProvider.resetTagSearch();

    List<String> search = tagProvider.tagSearch;

    if (search.length == 0) {
      truthBlessings.resetTagSearch();
      myBlessings.resetTagSearch();
    } else if (search.length > 0) {
      try {
        setState(() => searching = true);
        await myBlessingProvider.getMoreTaggedBlessings(user.user, search,
            filter: false);
        await truthBlessingProvider.getMoreTaggedBlessings(user.user, search,
            filter: false);
      } catch (e) {
        Toast.show("Something went wrong", context,
            duration: Toast.LENGTH_LONG);
      } finally {
        if (this.mounted) setState(() => searching = false);
      }
    }
  }

  _truthBlessingRequester(BuildContext context) async {
    print("NEXT PAGE REQUESTED =======================");
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    TruthBlessingProvider blessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    List<String> tags = tagProvider.tagSearch;

    List<TruthBlessing> blessings =
        await blessingProvider.getMoreTaggedBlessings(user.user, tags);
    return blessings.length > 0;
  }

  _myBlessingRequester(BuildContext context) async {
    print("NEXT PAGE REQUESTED =======================");
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    MyBlessingProvider blessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    // List<String> blessingIds = tagProvider.selectedTag.myBlessings;

    // List<MyBlessing> blessings = await blessingProvider.getTaggedBlessings(blessingIds, user.user);
    // return blessings.length > 0;
  }

  List<DropdownMenuItem<dynamic>> makeTagDropdownList(context) {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);

    List<DropdownMenuItem> list = [];
    for (Tag tag in tagProvider.tags) {
      list.add(DropdownMenuItem(child: Text(tag.tagText), value: tag.tagText));
    }

    return list;
  }
}
