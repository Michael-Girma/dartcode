import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/pages/single_blessing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class MyBlessingViewFix extends StatefulWidget {
  final List<MyBlessing> myBlessings;
  final Function requester;
  final BuildContext context;
  List<MyBlessing> data = [];

  MyBlessingViewFix(this.context, this.requester, this.myBlessings);

  @override
  _MyBlessingViewFixState createState() => _MyBlessingViewFixState();
}

class _MyBlessingViewFixState extends State<MyBlessingViewFix> {
  bool isLoading = true;   
  ScrollController _scrollController = ScrollController();
  bool hasMore = true;

  List<List<int>> titles = [];

    @override
  void initState(){
    getItems();
    super.initState();
  }

  getItems()async{
    // print("REached here");
    if(hasMore != null && !hasMore) return;
    // return;
    setState(() {
      isLoading = true;
    });
    print("QUERYING FOR MORE");
    try{
      bool moreToDocs = await widget.requester(widget.context);
      hasMore = moreToDocs;
    }catch(e){
      if(e is SocketException){
        Toast.show("Couldn't connect to server", widget.context, duration: Toast.LENGTH_LONG);
      }
      else Toast.show("Something went wrong", widget.context, duration: Toast.LENGTH_LONG);
    }
    finally{
      if(this.mounted){
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.data = <MyBlessing>[]+widget.myBlessings;

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
          if(index == titles.length) 
            return ListTile(title: isLoading == true? SpinKitFadingCircle(color: Theme.of(context).primaryColor): 
              index == 0?
                Text("No Blessings to Display", textAlign: TextAlign.center,):
                SizedBox()
            );

          if(titles[index].length > 1) return Column(
            children: [
              expand(context, titles[index]),
              Divider(color: Theme.of(context).primaryColor)
            ],
          );
          else return Column(
            children: [
              list(context, titles[index][0]),
              Divider(color: Theme.of(context).primaryColor),
            ],
          );
        }
      ),
    );
  }

  ListTile list(BuildContext context, int index) {
    MyBlessingProvider myBlessingProvider = Provider.of<MyBlessingProvider>(context, listen: false);
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                // "title",
                widget.data[index].title,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontFamily: 'OpenSans-Bold',
                  fontSize: 20.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      child: Image.asset(
                        'assets/images/BlessingApp_Icons_24x24_Play.png',
                        fit: BoxFit.contain,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      child: Image.asset(
                        'assets/images/BlessingApp_Icons_24x24_Stop.png',
                        fit: BoxFit.contain,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      child: Image.asset(
                        'assets/images/BlessingApp_Icons_24x24_Memorized.png',
                        fit: BoxFit.contain,
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              // "body",
              widget.data[index].body,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Aleo-Regular',
                fontSize: 18.0,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Image.asset(
                  'assets/images/BlessingApp_Icons_24x24_Tag.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                // "here",
                _getTags(widget.data[index].tags),
                //widget.data[index].tags.join(", "),
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontFamily: "Lato-Regular",
                    fontSize: 16),
              ),
            ],
          )
        ],
      ),
      onTap: () {
        String selectedId = widget.data[index].docId;
        myBlessingProvider.setSelectedBlessing(selectedId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlessingScreen(),
            settings: RouteSettings(
                arguments: widget.data[index]
            ),
          ),
        );
      },
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
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  // "title",
                  widget.data[firstIndex].title,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 20.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: InkWell(
                        child: Image.asset(
                          'assets/images/BlessingApp_Icons_24x24_Play.png',
                          fit: BoxFit.contain,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: InkWell(
                        child: Image.asset(
                          'assets/images/BlessingApp_Icons_24x24_Stop.png',
                          fit: BoxFit.contain,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: InkWell(
                        child: Image.asset(
                          'assets/images/BlessingApp_Icons_24x24_Memorized.png',
                          fit: BoxFit.contain,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                // "body",
                widget.data[firstIndex].body,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Aleo-Regular',
                  fontSize: 18.0,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Image.asset(
                    'assets/images/BlessingApp_Icons_24x24_Tag.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  // "here",
                  "EXPAND TO VIEW",
                  // nowData.tags.join(", "),
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: "Lato-Regular",
                      fontSize: 16),
                ),
              ],
            )
          ],
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
                    return Container(
                        child: list(context, elements[index])
                        
                    );
                }),
          ),
        ],
      ),
    );
  }

  _getTags(List<String> tags){
    print(tags);
    String tagString;
    if(tags.length == 0) tagString = "NO TAGS";
    else tagString = tags.join(", ");
    print(tagString);
    return tagString;
  }

  _groupByTitle(List<List<int>> titles, List<MyBlessing> blessings){
    String currTitle = '';
    for(int i = 0; i<widget.data.length; i++){
      MyBlessing curr = widget.data[i];
      if(curr.title != currTitle){
        titles.add([i]);
      }else{
        titles[titles.length - 1].add(i);
      }
      currTitle = curr.title;
    }
  }
}