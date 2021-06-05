import 'package:flutter/material.dart';

import 'guide.dart';

class ChaptersScreen extends StatefulWidget {
  @override
  _ChaptersScreenState createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final String screenTitle = "GUIDE";
  String pathPDF = "";

  @override
  Widget build(BuildContext context) {
    List<List> chapters = [
      [ "Beginning a Pattern of Blessing", 1 ],
      [ "What is a Blessing?", 2 ],
      [ "Biblical Understanding of Blessing", 3 ],
      [ "Responsibility and Authority to Bless", 4 ],
      [ "The Fruits of a Blessing", 5 ],
      [ "Blessing Suggestions", 6 ],
      [ "One Final Thought", 7 ]
    ];
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                screenTitle,
                    style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 27,
                      color: Colors.white
                    ),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: chapters.length,
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuidePage(initialChapter: chapters[index][1])),
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 15, 15, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text("${index + 1}. ",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontFamily: "OpenSans-Bold",
                          fontSize: 20
                        )
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${chapters[index][0]} ",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontFamily: "OpenSans-Bold",
                          fontSize: 20
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                      child: Image.asset("assets/images/BlessingApp_Icons_24x24_Arrow.png"),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider( color: Theme.of(context).primaryColor, thickness: 1,);
          },
        )
      ),
    );
  }
}