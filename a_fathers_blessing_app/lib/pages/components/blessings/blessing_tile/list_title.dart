import 'package:flutter/material.dart';

class TileTitle extends StatelessWidget {
  bool expandable;
  String title;

  TileTitle(this.title, {this.expandable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                // "title",
                title,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontFamily: 'OpenSans-Bold',
                  fontSize: 20.0,
                ),
              ),
            ),
            expandable == true
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.all(5),
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           CircleAvatar(
                      //             radius: 14.0,
                      //             backgroundImage: AssetImage(
                      //                 'assets/images/BlessingApp_Icons_100x100_Play.png'),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //     padding: EdgeInsets.all(5),
                      //     child: GestureDetector(
                      //       onTap: () {},
                      //       child: Container(
                      //         child: Column(
                      //           children: <Widget>[
                      //             CircleAvatar(
                      //               radius: 14.0,
                      //               backgroundImage: AssetImage(
                      //                   'assets/images/BlessingApp_Icons_100x100_Stop.png'),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     )),
                      // Padding(
                      //   padding: EdgeInsets.all(5),
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       child: Column(
                      //         children: <Widget>[
                      //           CircleAvatar(
                      //             radius: 14.0,
                      //             backgroundImage: AssetImage(
                      //                 'assets/images/BlessingApp_Icons_100x100_Memorized.png'),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
