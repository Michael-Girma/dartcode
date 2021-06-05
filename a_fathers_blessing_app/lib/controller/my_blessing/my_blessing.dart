import 'dart:async';

import 'package:a_fathers_blessing_app/controller/my_blessing/api.dart';
import 'package:hive/hive.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/utils.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:synchronized/synchronized.dart';

import '../config.dart';

class MyBlessingProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final int FETCHLIMIT = 50;

  List<MyBlessing> myBlessings = [];

  bool fetchedLastDoc = false;
  bool fetchedLastTagSearch = false;
  bool fetchedLastTagFilter = false;
  bool fetchedLasttxtSearch = false;
  String lastSearchTerm = "";

  DocumentSnapshot lastBlessingDocument;
  List<Tag> userTags;

  List<MyBlessing> filteredBlessings = [];
  List<MyBlessing> tagSearched = [];
  List<MyBlessing> textSearched = [];

  MyBlessing selectedBlessing;
  MyBlessing temporaryBlessing;
  User user;
  bool inAsyncCall = false;

  var _lock = Lock();
  // MyBlessingProvider({this.user});

  //Getting data from firestore

  //Future<void>

// refactored code base

  Future<List<MyBlessing>> getMoreMyBlessings(User user,
      {Map<String, dynamic> params}) async {
    return await _lock.synchronized(() async {
      if (!fetchedLastDoc)
      // if(true)
      {
        List<MyBlessing> blessings = [];
        int start = myBlessings.length;
        if (params == null)
          params =
              Utils.buildParams(sort: "title", skip: start, limit: FETCHLIMIT);
        try {
          blessings = await Api.getBlessings(user, params);
          if (blessings.length < FETCHLIMIT) fetchedLastDoc = true;
          myBlessings.addAll(blessings);
          await saveBlessingsInHive();
        } catch (SocketException) {
          await loadFromBox();
          notifyListeners();
          rethrow;
        }
        //TODO: resset this where necessary
        notifyListeners();
        return blessings;
      } else
        return <MyBlessing>[];
    });
  }

  getMoreTaggedBlessings(User user, List<String> tags, {filter = true}) async {
    return await _lock.synchronized(() async {
      bool cond = filter ? fetchedLastTagFilter : fetchedLastTagSearch;
      if (!cond) {
        int start = 0;
        if (filter)
          start = filteredBlessings.length;
        else
          start = tagSearched.length;

        Map<String, dynamic> params = Utils.buildParams(
            hasTags: tags, sort: "title", skip: start, limit: FETCHLIMIT);
        List<MyBlessing> blessings = await Api.getBlessings(user, params);
        if (filter) {
          if (blessings.length < FETCHLIMIT) fetchedLastTagFilter = true;
          filteredBlessings.addAll(blessings);
        } else {
          if (blessings.length < FETCHLIMIT) fetchedLastTagFilter = true;
          tagSearched.addAll(blessings);
        }
        notifyListeners();
        return blessings;
      } else
        return <MyBlessing>[];
    });
  }

  Future<List<MyBlessing>> getMoreSearchResults(User user, String query) async {
    if (query.trim() == '') return [];
    return await _lock.synchronized(() async {
      if (query != lastSearchTerm) resetTextSearch();
      if (!fetchedLasttxtSearch) {
        lastSearchTerm = query;
        int start = textSearched.length;
        Map<String, dynamic> params = Utils.buildParams(
            sort: "score", query: query, skip: start, limit: FETCHLIMIT);
        List<MyBlessing> blessings =
            await Api.getBlessings(user, params, urlExt: "/search");
        if (blessings.length < FETCHLIMIT) fetchedLasttxtSearch = true;
        textSearched.addAll(blessings);
        notifyListeners();
        return blessings;
      } else
        return <MyBlessing>[];
    });
  }

  persistBlessing(User user, MyBlessing blessing) async {
    //converts blessing to map
    Map blessingMap = Utils.convertBlessingToMap(blessing, forEdit: true);
    String urlExt = Utils.getModifyingUrlExtension(blessing.docId, false);
    bool status =
        await Api.modifyBlessing(user, urlExt, body: {"blessing": blessingMap});
    return status; //TODO: make blessing idless if bad request
    //make request to save blessing
    //return bool of whether its created
  }

  deleteBlessing(User user, MyBlessing blessing) async {
    String urlExt = Utils.getModifyingUrlExtension(blessing.docId, true);
    bool status = await Api.modifyBlessing(user, urlExt);
    if (status) {
      myBlessings
          .removeWhere((myBlessing) => myBlessing.docId == blessing.docId);
      filteredBlessings
          .removeWhere((myBlessing) => myBlessing.docId == blessing.docId);
      textSearched
          .removeWhere((myBlessing) => myBlessing.docId == blessing.docId);
      tagSearched
          .removeWhere((myBlessing) => myBlessing.docId == blessing.docId);
      await persistProvToHive(myBlessings);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  updateFilteredBlessings(User user, String tag) async {
    clearBlessings(blessings: filteredBlessings);
    Map<String, dynamic> params =
        Utils.buildParams(hasTags: [tag], limit: FETCHLIMIT);
    List<MyBlessing> blessings = await Api.getBlessings(user, params);
    filteredBlessings.addAll(blessings);
    notifyListeners();
  }

  persistProvToHive(List<MyBlessing> blessings) async {
    var box = Hive.box(Config.myBlessingBox);
    await box.clear();
    await box.add(blessings);
    return;
  }

  saveTags(User user, MyBlessing blessing, List<String> tags) async {
    //try to persist blessing
    MyBlessing copiedBlessing = Utils.copyObject(blessing);
    copiedBlessing.tags = <String>[] + tags;
    bool status = await persistBlessing(user, copiedBlessing);
    if (status) {
      List<MyBlessing> blessings =
          findAndUpdateBlessingById(myBlessings, blessing);
      await persistProvToHive(blessings);

      //update search notifiers
      //update filter prov
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  saveBlessing(User user, MyBlessing blessing) async {
    //try to persist blessing
    bool status = await persistBlessing(user, blessing);
    if (status) {
      if (status) print("saving Blessing");

      List<MyBlessing> blessings =
          findAndUpdateBlessingById(myBlessings, blessing);
      findAndUpdateBlessingById(tagSearched, blessing);
      findAndUpdateBlessingById(textSearched, blessing);
      await persistProvToHive(blessings);

      //update search notifiers
      //update filter prov
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  findAndUpdateBlessingById(
      List<MyBlessing> blessings, MyBlessing newBlessing) {
    MyBlessing oldBlessing = blessings.firstWhere(
        (blessing) => blessing.docId == newBlessing.docId,
        orElse: () => null);
    if (oldBlessing != null) {
      oldBlessing.body = newBlessing.body;
      oldBlessing.tags = newBlessing.tags;
      return blessings;
    }
    return blessings;
  }

  Future<bool> saveTruthBlessing(User user, TruthBlessing blessing) async {
    MyBlessing newBlessing =
        Utils.convertTruthToMyBlessing(blessing, user: user);
    bool status = await saveNewBlessing(user, newBlessing);
    return status;
    //convert truthBlessing to MyBlessing
    //save as a NewBlessing
  }

  updateFiltered(User user, List<String> tags) async {
    resetFilters();
    await getMoreTaggedBlessings(user, tags);
  }

  Future<bool> saveNewBlessing(User user, MyBlessing blessing) async {
    MyBlessing newBlessing = await Api.addBlessing(user, blessing);
    if (newBlessing.docId != "") {
      await updateMyBlessings(user, blessing: newBlessing);
      //refresh tags and filter
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateMyBlessings(User user, {MyBlessing blessing}) async {
    int index = 0;
    if (blessing != null)
      index = Utils.findInsertionIndex(myBlessings, blessing);
    List<MyBlessing> subList = myBlessings.sublist(0, index);
    int initialLength = myBlessings.length;
    replaceMyBlessings(subList);
    Map<String, dynamic> params = Utils.buildParams(
        skip: myBlessings.length, limit: initialLength, sort: "title");
    fetchedLastDoc = false;
    await getMoreMyBlessings(user, params: params);

    return true;
  }

  replaceBlessings(List<MyBlessing> blessings, List<MyBlessing> newBlessings) {
    blessings.removeWhere((blessing) => true);
    // print(myBlessings);

    blessings.addAll(newBlessings);
  }

  replaceMyBlessings(List<MyBlessing> blessings) {
    myBlessings.removeWhere((blessing) => true);
    print(myBlessings);

    myBlessings.addAll(blessings);
  }

  clearBlessings({List<MyBlessing> blessings}) {
    if (blessings != null)
      blessings.removeWhere((blessing) => true);
    else
      myBlessings.removeWhere((blessing) => true);
    //remove all array items with built in objects
  }

  clearMyBlessings() {
    clearBlessings();
    fetchedLastDoc = false;
  }

  deleteMyBlessings() async {
    clearMyBlessings();
    await persistProvToHive(myBlessings);
  }

  saveBlessingsInHive() async {
    var box = Hive.box(Config.myBlessingBox);
    await box.clear();
    await box.add(<MyBlessing>[] + myBlessings);
    print(box.values);

    var box2 = Hive.box(Config.myBlessingBox);
    print(box2.values);
  }

  makeTempSelected() {
    selectedBlessing.title = temporaryBlessing.title;
    selectedBlessing.docId = temporaryBlessing.docId;
    selectedBlessing.body = temporaryBlessing.body;
    selectedBlessing.tags = temporaryBlessing.tags;
    notifyListeners();
  }

  loadFromBox() async {
    var box = await Hive.openBox(Config.myBlessingBox);
    if (box.isNotEmpty) {
      print("========================= BOX VALUES");
      print(box.values);
      var list = box.values.toList()[0];
      myBlessings = Utils.convertDynamicToMyBlessing(list);
    }
  }

  setTempBlessingTags(List<String> tags) {
    temporaryBlessing.tags.removeWhere((element) => true);
    temporaryBlessing.tags.addAll(tags);
    notifyListeners();
  }

  setSeletedBlessingTags(List<String> tags) {
    selectedBlessing.tags = tags;
    notifyListeners();
  }

  resetFilters() {
    // tagFilterPage = null;
    filteredBlessings.removeWhere((blessing) => true);
    fetchedLastTagFilter = false;
  }

  resetTagSearch() {
    // tagSearchPage = null;
    tagSearched.removeWhere((blessing) => true);
    fetchedLastTagSearch = false;
    notifyListeners();
  }

  resetTextSearch() {
    // textSearchPage = null;
    lastSearchTerm = '';
    textSearched.removeWhere((blessing) => true);
    fetchedLasttxtSearch = false;
  }

  void makeTempFromSelected() {
    temporaryBlessing = MyBlessing(
        docId: selectedBlessing.docId,
        title: selectedBlessing.title,
        body: selectedBlessing.body,
        email: selectedBlessing.email,
        tags: <String>[] + selectedBlessing.tags);
  }

  void setSelectedBlessing(String selectedId) {
    selectedBlessing =
        myBlessings.firstWhere((blessing) => blessing.docId == selectedId);
    notifyListeners();
  }

  void setTemporaryBlessingText(String text) {
    temporaryBlessing.body = text;
    notifyListeners();
  }

  void setTempBlessingTitle(String text) {
    temporaryBlessing.title = text;
    notifyListeners();
  }

  void initTempBlessing(User user) {
    temporaryBlessing =
        MyBlessing(title: "", body: "", email: user.email, tags: <String>[]);
    notifyListeners();
  }

  void clearSearches() {
    resetTagSearch();
    resetTextSearch();
    notifyListeners();
  }
}
