import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/blessing_tile/list_subtitle.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/blessing_tile/list_tile.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/blessing_tile/list_title.dart';
import 'package:a_fathers_blessing_app/pages/single_blessing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class MyBlessingView extends StatefulWidget {
  final List<MyBlessing> myBlessings;
  final Function requester;
  final BuildContext context;
  List<MyBlessing> data = [];

  MyBlessingView(this.context, this.requester, this.myBlessings);

  @override
  _MyBlessingViewState createState() => _MyBlessingViewState();
}

class _MyBlessingViewState extends State<MyBlessingView> {
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  bool hasMore = true;

  List<List<int>> titles = [];

  @override
  void initState() {
    getItems();
    super.initState();
  }

  getItems() async {
    // print("REached here");
    if (hasMore != null && !hasMore) return;
    // return;
    setState(() {
      isLoading = true;
    });
    print("QUERYING FOR MORE");
    try {
      bool moreToDocs = await widget.requester(widget.context);
      hasMore = moreToDocs;
    } catch (e) {
      if (e is SocketException) {
        Toast.show("Couldn't connect to server", widget.context,
            duration: Toast.LENGTH_LONG);
      } else
        Toast.show("Something went wrong", widget.context,
            duration: Toast.LENGTH_LONG);
    } finally {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.data = <MyBlessing>[] + widget.myBlessings;

    titles = [];
    _groupByTitle(titles, widget.data);

    return LazyLoadScrollView(
      onEndOfPage: getItems,
      scrollOffset: 40,
      child: ListView.builder(
          key: GlobalKey(),
          // controller: _scrollController,

          itemCount: titles.length + 1,
          itemBuilder: (context, index) {
            if (index == titles.length)
              return ListTile(
                  title: isLoading == true
                      ? SpinKitFadingCircle(
                          color: Theme.of(context).primaryColor)
                      : index == 0
                          ? Text(
                              "No Blessings to Display",
                              textAlign: TextAlign.center,
                            )
                          : SizedBox());

            if (titles[index].length > 1)
              return Column(
                children: [
                  expand(context, titles[index]),
                  Divider(color: Theme.of(context).primaryColor)
                ],
              );
            else
              return Column(
                children: [
                  list(context, titles[index][0]),
                  Divider(color: Theme.of(context).primaryColor),
                ],
              );
          }),
    );
  }

  Widget list(BuildContext context, int index) {
    MyBlessingProvider myBlessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);
    return BlessingTile(widget.data[index].title, widget.data[index].body,
        widget.data[index].tags, 
        () {//routing function
          String selectedId = widget.data[index].docId;
          myBlessingProvider.setSelectedBlessing(selectedId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlessingScreen(),
              settings: RouteSettings(arguments: widget.data[index]),
            ),
          );
       }
    );
  }

  Container expand(BuildContext context, List<int> elements) {
    int firstIndex = elements[0];

    return Container(
      child: ExpansionTile(
        key: GlobalKey(),
        trailing: Icon(
          Icons.list_rounded,
          color: Color(0xffcf993d),
        ),
        title: TileTitle(widget.data[firstIndex].title),
        subtitle: TileSubtitle(
          widget.data[firstIndex].body,
          tags: widget.data[firstIndex].tags,
          expandable: true,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: new ListView.separated(
                key: GlobalKey(),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(color: Theme.of(context).primaryColor),
                itemCount: elements.length,
                itemBuilder: (context, index) {
                  return Container(child: list(context, elements[index]));
                }),
          ),
        ],
      ),
    );
  }

  _groupByTitle(List<List<int>> titles, List<MyBlessing> blessings) {
    String currTitle = '';
    for (int i = 0; i < widget.data.length; i++) {
      MyBlessing curr = widget.data[i];
      if (curr.title != currTitle) {
        titles.add([i]);
      } else {
        titles[titles.length - 1].add(i);
      }
      currTitle = curr.title;
    }
  }
}
