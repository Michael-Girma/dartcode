import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/config.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/api.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/utils.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:synchronized/synchronized.dart';

class TruthBlessingProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _lock = new Lock();
  List<TruthBlessing> truthBlessings = [];
  DocumentSnapshot lastBlessingDocument;
  final int FETCHLIMIT = 30;

  bool fetchedLastDoc = false;
  bool fetchedLastTagSearch = false;
  bool fetchedLastTagFilter = false;
  bool fetchedLasttxtSearch = false;
  String lastSearchTerm = '';

  List<Tag> userTags = [];

  List<TruthBlessing> filteredBlessings = [];
  int tagFilterPage;

  List<TruthBlessing> tagSearched = [];
  int tagSearchPage;

  List<TruthBlessing> textSearched = [];
  int textSearchPage;

  TruthBlessing selectedBlessing;
  TruthBlessing temporaryBlessing;
  User user;

  TruthBlessingProvider({this.user});

  //new code base
  //

  Future<List<TruthBlessing>> getMoreTruthBlessings(User user,
      {Map<String, dynamic> params}) async {
    return await _lock.synchronized(() async {
      if (!fetchedLastDoc)
      // if(true)
      {
        List<TruthBlessing> blessings = [];
        int start = truthBlessings.length;
        if (params == null)
          params =
              Utils.buildParams(sort: "order", skip: start, limit: FETCHLIMIT);
        try {
          blessings = await Api.getBlessings(user, params);
          if (blessings.length < FETCHLIMIT) fetchedLastDoc = true;
          truthBlessings.addAll(blessings);
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
        return <TruthBlessing>[];
    });
  }

  updateTruthBlessings(User user, {TruthBlessing blessing}) async {
    int initialLength = truthBlessings.length;
    Map<String, dynamic> params = Utils.buildParams(
        skip: truthBlessings.length, limit: initialLength, sort: "title");
    fetchedLastDoc = false;
    await getMoreTruthBlessings(user, params: params);
    return true;
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
        List<TruthBlessing> blessings = await Api.getBlessings(user, params);
        if (filter) {
          if (blessings.length < FETCHLIMIT) fetchedLastTagFilter = true;
          filteredBlessings.addAll(blessings);
        } else {
          if (blessings.length < FETCHLIMIT) fetchedLastTagSearch = true;
          tagSearched.addAll(blessings);
        }
        notifyListeners();
        return blessings;
      }
      return <TruthBlessing>[];
    });
  }

  getMoreSearchResults(User user, String query) async {
    if (query.trim() == '') return <TruthBlessing>[];
    return await _lock.synchronized(() async {
      if (query != lastSearchTerm) resetTextSearch();
      if (!fetchedLasttxtSearch) {
        lastSearchTerm = query;
        int start = textSearched.length;
        Map<String, dynamic> params = Utils.buildParams(
            sort: "score", query: query, skip: start, limit: FETCHLIMIT);
        List<TruthBlessing> blessings =
            await Api.getBlessings(user, params, urlExt: "/search");
        textSearched.addAll(blessings);
        if (blessings.length < FETCHLIMIT) fetchedLasttxtSearch = true;
        notifyListeners();
        return blessings;
      } else
        return <TruthBlessing>[];
    });
  }

  Future<bool> persistTags(User user, TruthBlessing blessing) async {
    //converts blessing to map
    Map blessingMap = Utils.convertBlessingToMap(blessing, forEdit: true);
    String urlExt = Utils.getModifyingUrlExtension(blessing.docId);
    bool status = await Api.modifyBlessing(user, urlExt, body: blessingMap);
    return status; //TODO: make blessing idless if bad request
    //make request to save blessing
    //return bool of whether its created
  }

  updateFilteredBlessings(User user, String tag) async {
    clearBlessings(blessings: filteredBlessings);
    Map<String, dynamic> params =
        Utils.buildParams(hasTags: [tag], limit: filteredBlessings.length);
    List<TruthBlessing> blessings = await Api.getBlessings(user, params);
    filteredBlessings.addAll(blessings);
    notifyListeners();
  }

  persistProvToHive(List<TruthBlessing> blessings) async {
    var box = Hive.box(Config.truthBlessingBox);
    await box.clear();
    await box.add(blessings);
    return;
  }

  Future<bool> saveTags(User user, TruthBlessing blessing) async {
    //try to persist blessing
    bool status = await persistTags(user, blessing);
    if (status) {
      // if(status) print("wowpopwopwowpowp owpo pwo pwo pwo wpo pwowpowp owp owpo wpow pwo wpopwo");

      List<TruthBlessing> blessings =
          findAndUpdateBlessingTagsById(truthBlessings, blessing);
      findAndUpdateBlessingTagsById(tagSearched, blessing);
      findAndUpdateBlessingTagsById(textSearched, blessing);
      await persistProvToHive(blessings);

      //update search notifiers
      //update filter prov
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  findAndUpdateBlessingTagsById(
      List<TruthBlessing> blessings, TruthBlessing newBlessing) {
    TruthBlessing oldBlessing = blessings.firstWhere(
        (blessing) => blessing.docId == newBlessing.docId,
        orElse: () => null);
    if (oldBlessing != null) {
      oldBlessing.tags = newBlessing.tags;
    }
    return blessings;
  }

  findIndexOfBlessingByTitle(
      List<TruthBlessing> blessings, TruthBlessing blessing) {
    return blessings.indexWhere((bless) => bless.title == blessing.title);
  }

  replaceMyBlessings(List<TruthBlessing> blessings) {
    truthBlessings.removeWhere((blessing) => true);
    print(truthBlessings);

    truthBlessings.addAll(blessings);
  }

  clearBlessings({List<TruthBlessing> blessings}) {
    if (blessings != null)
      blessings.removeWhere((blessing) => true);
    else
      truthBlessings.removeWhere((blessing) => true);
    //remove all array items with built in objects
  }

  clearTruthBlessings() {
    clearBlessings();
    fetchedLastDoc = false;
  }

  deleteTruthBlessings() async {
    clearBlessings(blessings: truthBlessings);
    fetchedLastDoc = false;
    await persistProvToHive(truthBlessings);
  }

  saveBlessingsInHive() async {
    var box = Hive.box(Config.truthBlessingBox);
    await box.clear();
    await box.add(<TruthBlessing>[] + truthBlessings);
  }

  makeTempSelected() {
    selectedBlessing.title = temporaryBlessing.title;
    selectedBlessing.docId = temporaryBlessing.docId;
    selectedBlessing.body = temporaryBlessing.body;
    selectedBlessing.tags = temporaryBlessing.tags;
    notifyListeners();
  }

  setTempBlessingTags(List<String> tags) {
    temporaryBlessing.tags.removeWhere((element) => true);
    temporaryBlessing.tags.addAll(tags);
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
    fetchedLasttxtSearch = false;
    textSearched.removeWhere((blessing) => true);
  }

  loadFromBox() async {
    var box = await Hive.openBox(Config.truthBlessingBox);
    if (box.isNotEmpty) {
      print("========================= BOX VALUES");
      print(box.values);
      var list = box.values.toList()[0];
      truthBlessings = Utils.convertDynamicToTruthBlessing(list);
    }
  }

  void makeTempFromSelected() {
    temporaryBlessing = TruthBlessing(
        docId: selectedBlessing.docId,
        title: selectedBlessing.title,
        body: selectedBlessing.body,
        tags: <String>[] + selectedBlessing.tags);
  }

  void clearSearches() {
    resetTextSearch();
    resetTagSearch();
    notifyListeners();
  }
}
