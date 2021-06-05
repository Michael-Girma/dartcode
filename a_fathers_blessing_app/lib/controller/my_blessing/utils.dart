import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/tag/utils.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Utils {
  
  static convertDynamicToMyBlessing(var list) {
    print(list.runtimeType);
    List<MyBlessing> blessings = [];
    for (var item in list) {
      blessings.add(item as MyBlessing);
    }
    print(list.runtimeType);
    return blessings;
  }

  static String getModifyingUrlExtension(String id, bool delete) {
    if (delete)
      return '/$id/delete';
    else
      return '/$id/edit';
  }
  
  static buildParams(
      {List<String> hasTags, int skip, int limit, String sort, String query}) {
    Map<String, dynamic> params = {};
    if (hasTags != null) params["hasTags"] = hasTags;
    if (skip != null) params["skip"] = '$skip';
    if (limit != null) params["limit"] = '$limit';
    if (sort != null) params["sort"] = sort;
    if (query != null) params["query"] = query;

    return params;
  }

  static convertResponseToBlessing(List<dynamic> response) {
    List<MyBlessing> blessings = [];
    for (dynamic blessing in response) {
      blessings.add(convertMapToBlessing(blessing));
    }
    return blessings;
  }

  static convertMapToBlessing(dynamic blessingMap) {
    //convert _id to docId
    String docId = blessingMap["_id"];
    String title = blessingMap["title"];
    String body = blessingMap["body"];
    String email = blessingMap["email"];
    List<dynamic> tagObjects = blessingMap["tags"];
    List<String> tags = [];
    for (Map tag in tagObjects) {
      print("==================== $tag");
      tags.add(tag["tagText"]);
    }
    return MyBlessing(
        docId: docId, title: title, body: body, email: email, tags: tags);
  }

  static MyBlessing convertTruthToMyBlessing(TruthBlessing blessing, {User user}) {
    String title = blessing.title;
    String body = blessing.body;
    List<String> tags = <String>[] + blessing.tags;
    String email = user.email;
    return MyBlessing(body: body, title: title, email: email, tags: tags);
    //map blessing title
    //map blessing tags
    //return blessing
  }

  static convertBlessingToMap(MyBlessing blessing, {forEdit = false}) {
    //make empty object
    Map blessingMap = {};
    if (!forEdit) blessingMap["title"] = blessing.title;
    if (!forEdit) blessingMap["email"] = blessing.email;
    blessingMap["body"] = blessing.body;
    blessingMap["tags"] = blessing.tags.runtimeType == <String>[""].runtimeType
        ? blessing.tags
        : <String>[];
    print(blessingMap);
    return blessingMap;
  }

  static MyBlessing copyObject(MyBlessing blessing) {
    return MyBlessing(
        docId: blessing.docId,
        title: blessing.title,
        email: blessing.email,
        body: blessing.body,
        tags: <String>[] + blessing.tags);
  }

  static findInsertionIndex(List<MyBlessing> blessings, MyBlessing blessing) {
    int index = findIndexOfBlessingByTitle(blessings, blessing);
    if (index == -1) return 0;
    return index;
  }

  static findIndexOfBlessingByTitle(List<MyBlessing> blessings, MyBlessing blessing) {
    return blessings.indexWhere((bless) => bless.title == blessing.title);
  }
}
