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

class TruthBlessingView extends StatefulWidget {
  BuildContext context;
  final List<TruthBlessing> truthBlessings; // stores fetched products
  final Function requester;
  final String onTimeout;
  Function refresher;
  TruthBlessingView(this.context, this.requester,
      {this.truthBlessings = const [], this.refresher, this.onTimeout});

  @override
  _TruthBlessingViewState createState() => _TruthBlessingViewState();
}

class _TruthBlessingViewState extends State<TruthBlessingView> {
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
    try {
      print("QUERYING FOR MORE");
      bool moreToDocs = await widget.requester(widget.context);
      hasMore = moreToDocs;
    } catch (e) {
      if (e is SocketException) {
        Toast.show("Couldn't connect to server", widget.context,
            duration: Toast.LENGTH_LONG);
      } else
        Toast.show("Something went wrong", widget.context,
            duration: Toast.LENGTH_LONG);
      print(e);
      rethrow;
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
        "========================= blessings length ${widget.truthBlessings.length}");
    TruthBlessingProvider truthBlessingProvider =
        Provider.of<TruthBlessingProvider>(context, listen: false);

    return Column(children: [
      Expanded(
        child: LazyLoadScrollView(
          onEndOfPage: getItems,
          scrollOffset: 50,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: widget.truthBlessings != null
                ? widget.truthBlessings.length + 1
                : 0,
            itemBuilder: (context, index) {
              if (index == widget.truthBlessings.length)
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
                  widget.truthBlessings[index].title,
                  widget.truthBlessings[index].body,
                  widget.truthBlessings[index].tags,
                  () {
                    String selectedId = widget.truthBlessings[index].docId;
                    print(selectedId);
                    truthBlessingProvider.selectedBlessing =
                        widget.truthBlessings[index];
                    truthBlessingProvider.makeTempFromSelected();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlessingScreen(),
                        settings: RouteSettings(
                            arguments: widget.truthBlessings[index]),
                      ),
                    );
                  },
                ),
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
