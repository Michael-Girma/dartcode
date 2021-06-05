import 'dart:io';

import 'package:a_fathers_blessing_app/controller/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/tag/tag.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/controller/user/user.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/pages/components/tags/deleteTag.dart';
import 'package:a_fathers_blessing_app/pages/components/tags/edit_tag.dart';
import 'package:a_fathers_blessing_app/pages/tagged_blessings.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class TagScreen extends StatefulWidget {
  final String title = "BLESSING TAGS";
  BuildContext context;
  TagProvider tagProvider;
  TagScreen(this.context);

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  String filterText = "";
  bool isLoading = false;   
  ScrollController _scrollController = ScrollController();
  bool hasMore;
  static const int DOCLIMIT = 20;

  getItems()async{
    // print("REached here");
    // if(hasMore != null && !hasMore) return;
    // return;
    setState(() {
      isLoading = true;
    });
    print("QUERYING FOR MORE");
    UserProvider user = Provider.of<UserProvider>(context, listen:false);
    
    try{
      bool moreToDocs = await _getTags(context);
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
    }}
  }

  @override
  void initState(){
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
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    MyBlessingProvider myBlessingProvider = Provider.of<MyBlessingProvider>(context, listen: false);
    TruthBlessingProvider truthBlessingProvider = Provider.of<TruthBlessingProvider>(context, listen:false);
    widget.tagProvider = tagProvider;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
            widget.title,
              style: TextStyle(
                fontFamily: 'OpenSans-Bold',
                fontSize: 25,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TagProvider>(
          builder: (context, tagProvider, child){
            return Column(
              mainAxisSize: MainAxisSize.min,
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (String text){
                      filterText = text;
                      tagProvider.filterTitle = text;
                      tagProvider.filterTagsByTitle(startingString: text);
                    },
                    style: TextStyle(
                      fontSize: 18
                    ),
                    decoration:  new InputDecoration(
                      hintText: "FILTER BY TAG TITLE",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                      )
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.separated(
                    
                    shrinkWrap: true,
                    itemCount: tagProvider.filteredTags != null? tagProvider.filteredTags.length + 1 : 0,
                    itemBuilder: (context, index){
                      if(index == tagProvider.filteredTags.length) 
                        return ListTile(title: isLoading == true? SpinKitFadingCircle(color: Theme.of(context).primaryColor): SizedBox());
                      return Container(
                        child: ListTile(
                          onTap: (){
                            // String selectedId = tagProvider.tags[index].tagId;
                            myBlessingProvider.resetFilters();
                            truthBlessingProvider.resetFilters();
                            tagProvider.selectedTag = tagProvider.filteredTags[index];
                            // tagProvider.setSelectedTag(tagProvider.filteredTags[index].tagId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaggedBlessings(),
                                settings: RouteSettings(),
                              ),
                            );
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tagProvider.filteredTags[index].tagText, //TODO: 
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
                                        child: IconButton(
                                          onPressed: ((){
                                            print("edit touched");
                                            _showEditDialog(context, tagProvider.filteredTags[index].tagText);
                                          }),
                                          icon: Icon(Icons.edit),
                                          color: Theme.of(context).secondaryHeaderColor,
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(5),
                                        child: IconButton(
                                          onPressed: ((){
                                            print("delete touched");
                                            _showDeleteDialog(context, tagProvider.filteredTags[index].tagText);
                                          }),
                                          icon: Icon(Icons.delete_forever),
                                          color: Theme.of(context).secondaryHeaderColor,
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10,0),
                                    child: Image.asset(
                                      'assets/images/BlessingApp_Icons_24x24_Tag.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Text(
                                    _getNumberOfBlessings(tagProvider.filteredTags[index].myBlessings, true), //TODO::
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontFamily: "Lato-Regular",
                                        fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10,0),
                                    child: Image.asset(
                                      'assets/images/BlessingApp_Icons_24x24_Tag.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Text(
                                    _getNumberOfBlessings(tagProvider.filteredTags[index].truthBlessings, false), //TODO::
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontFamily: "Lato-Regular",
                                        fontSize: 16
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider( color: Theme.of(context).primaryColor, thickness: 1,);
                    },
                  ),
                ),
                Divider(thickness: 1)
              ],
            );
          },
        ) 
      ),
    );
  }

  @override
  void dispose(){
    widget.tagProvider.resetTagFilters();
    super.dispose();
  }

  Future<bool> _getTags(BuildContext context) async{
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen:false);
    // await tagProvider.getTagsFromFirestore(user);
    UserProvider user = Provider.of<UserProvider>(context, listen:false );
    List<Tag> tags = await tagProvider.getMoreTags(user.user);

    tagProvider.filterTagsByTitle(startingString: "");

    if(tags == null) return false;
    return tags.length > 0;
  }
  
  String _getNumberOfBlessings(int length, bool truthBlessing){
    String type = truthBlessing? "My" : "Truth78";
    if(length > 1){
      return "$length $type Blessings Tagged";
    }
    else if(length == 1){
      return "$length $type Blessing Tagged";
    }
    else{
      return "No $type Blessings Tagged";
    }
  }

  _showEditDialog(BuildContext context, String title){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return EditTagPopup(initialTag: title,);
      }
    );
  }

  _showDeleteDialog(BuildContext context, String title){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return DeleteTagPopup(initialTag: title,);
      }
    );
  }
}