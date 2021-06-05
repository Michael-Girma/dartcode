import 'package:a_fathers_blessing_app/pages/components/blessings/blessing_tile/list_subtitle.dart';
import 'package:a_fathers_blessing_app/pages/components/blessings/blessing_tile/list_title.dart';
import 'package:flutter/material.dart';

class BlessingTile extends StatelessWidget {
  final String title;
  final String body;
  List<String> tags = [];
  Function onTap;
  bool expandable;

  BlessingTile(this.title, this.body, this.tags, this.onTap,
      {this.expandable = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TileTitle(
        title,
        expandable: this.expandable,
      ),
      subtitle: TileSubtitle(
        body,
        tags: tags,
      ),
      onTap: () {
        onTap();
      });
  }
}
