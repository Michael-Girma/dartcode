import 'dart:async';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/blessing_tile/list_tile.dart';
import 'package:a_fathers_blessing_app/pages/single_blessing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TileMyBlessingView extends StatefulWidget {
  BuildContext context;
  final List<MyBlessing> myBlessings; // stores fetched products
  final Function requester;
  Function refresher;
  TileMyBlessingView(this.context, this.requester, this.myBlessings,
      {this.refresher});

  @override
  _TileMyBlessingViewState createState() => _TileMyBlessingViewState();
}

class _TileMyBlessingViewState extends State<TileMyBlessingView> {
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  bool hasMore;
  static const int DOCLIMIT = 20;

  getItems() async {
    // print("REached here");
    // if(hasMore != null && !hasMore) return;
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
  void initState() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(widget.context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getItems();
      }
    });
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    // getItems();
    print(
        "========================= blessings length ${widget.myBlessings.length}");
    MyBlessingProvider myBlessingProvider =
        Provider.of<MyBlessingProvider>(context, listen: false);

    return Column(children: [
      Expanded(
        child: LazyLoadScrollView(
          onEndOfPage: getItems,
          scrollOffset: 50,
          child: ListView.separated(
            controller: _scrollController,
            itemCount:
                widget.myBlessings != null ? widget.myBlessings.length + 1 : 0,
            itemBuilder: (context, index) {
              if (index == widget.myBlessings.length)
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
              return Container(
                child: BlessingTile(
                  widget.myBlessings[index].title,
                  widget.myBlessings[index].body,
                  widget.myBlessings[index].tags,
                  () {
                    String selectedId = widget.myBlessings[index].docId;
                    print(selectedId);
                    // truthBlessingProvider.changeBlessing();
                    myBlessingProvider.selectedBlessing =
                        widget.myBlessings[index];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlessingScreen(),
                        settings:
                            RouteSettings(arguments: widget.myBlessings[index]),
                      ),
                    );
                  },
                )
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
              );
            },
          ),
        ),
      )
    ]);
  }
}
