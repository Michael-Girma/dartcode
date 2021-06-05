import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/config.dart';
import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/tag/api.dart';
import 'package:a_fathers_blessing_app/controller/tag/utils.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:synchronized/synchronized.dart';

class TagProvider extends ChangeNotifier {
  List<Tag> tags = [];
  List<String> tagsText = [];
  List<Tag> filteredTags = [];
  String filterTitle = "";
  Tag selectedTag;
  List<String> tagSearch = [];
  bool fetchedLastDoc = false;
  List<String> allTempTags = [];
  List<String> selectedTempTags = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int FETCHLIMIT = 40;
  var _lock = Lock();

  Future<List<Tag>> getMoreTags(User user,
      {Map<String, dynamic> params}) async {
    return await _lock.synchronized(() async {
      // if (!fetchedLastDoc)
      if (true) {
        List<Tag> newTags = [];
        // int start = tags.length; for the sake of searching
        if (params == null)
          params = Utils.buildParams(
            sort: "_id",
          );
        try {
          newTags = await Api.getTags(user, params);
          if (newTags.length < FETCHLIMIT) fetchedLastDoc = true;
          // tags.addAll(newTags); // for the sake of searching smoothly
          tags.removeWhere((element) => true);
          tagsText.removeWhere((element) => true);
          tags.addAll(newTags);
          tagsText.addAll(tags.map((tag) => tag.tagText));
          await saveTagsInHive(tags);
        } catch (SocketException) {
          await loadFromBox();
          filterTagsByTitle(startingString: '');
          notifyListeners();
          rethrow;
        }
        //TODO: resset this where necessary
        notifyListeners();
        return newTags;
      }
    });
  }

  persistTag(User user, String oldTag, String newTag) async {
    // Map blessingMap = convertTagToMap(blessing, forEdit: true);
    // String urlExt = getModifyingUrlExtension(blessing.docId, false);
    bool status = await Api.modifyTag(user, "/edit",
        body: {"oldTag": oldTag, "newTag": newTag});
    findAndUpdateTag(oldTag, newTag);
    selectedTag = null;
    filterTagsByTitle();
    notifyListeners();
    return status;
  }

  findAndUpdateTag(String oldTag, String newTag) {
    Tag toBeUpdated = tags.firstWhere((element) => element.tagText == oldTag,
        orElse: () => null);
    if (toBeUpdated != null) toBeUpdated.tagText = newTag;
    return;
  }

  deleteTag(User user, String toBeDeleted) async {
    String urlExt = "/delete";
    bool status = await Api.modifyTag(user, urlExt,
        body: {"tag": toBeDeleted}, delete: true);
    if (status) {
      tags.removeWhere((tag) => tag.tagText == toBeDeleted);
      filterTagsByTitle();
      await saveTagsInHive(tags);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  saveTagsInHive(List<Tag> tags) async {
    var box = Hive.box(Config.tagBox);
    await box.clear();
    await box.add(<Tag>[] + tags);
    return;
  }

  void filterTagsByTitle({String startingString}) {
    if (startingString != null) {
      filterTitle = startingString;
    }
    filteredTags =
        tags.where((tag) => tag.tagText.startsWith(filterTitle)).toList();
    print("[X] filteredTags $filteredTags");
    notifyListeners();
  }

  updateTags(User user) async {
    clearTags();
    await getMoreTags(user);
  }

  clearTags() {
    tags.removeWhere((element) => true);
    fetchedLastDoc = false;
  }

  clearAllTags() {
    clearTags();
    filterTagsByTitle();
    notifyListeners();
  }

  updateTagLists(User user) async {
    await updateTags(user);
    filterTagsByTitle();
    notifyListeners();
  }

  deleteTags() async {
    clearAllTags();
    await saveTagsInHive(tags);
  }

  loadFromBox() async {
    var box = await Hive.openBox(Config.tagBox);
    if (box.isNotEmpty) {
      print("========================= BOX VALUES");
      print(box.values);
      var list = box.values.toList()[0];
      tags = Utils.convertDynamicToTags(list);
      filterTagsByTitle();
    }
  }

  resetTagFilters() {
    selectedTag = null;
    filteredTags = [];
  }

  setTemporaryLists(List<String> allTags, List<String> selectedTags) {
    List<String> listOfUnique = [];
    for (String tag in allTags) {
      if (!listOfUnique.contains(tag)) listOfUnique.add(tag);
    }
    // listOfUnique = allTags.where((tag) => !listOfUnique.contains(tag)).toList();
    allTempTags = <String>[] + listOfUnique;
    selectedTempTags = <String>[] + selectedTags;
  }

  void addToAllTemporaryTags(String tag, {int position}) {
    position = position == null ? allTempTags.length : position;
    print("before adding ==========================================");
    allTempTags.insert(position, tag);
    print("after adding ==========================================");
    print(allTempTags);
    notifyListeners();
  }

  void removeFromSelectedTemporaryTags(String removed) {
    selectedTempTags = selectedTempTags.where((tag) => tag != removed).toList();
    notifyListeners();
  }

  void addToSelectedTemporaryTags(String added, {int position}) {
    position = position == null ? selectedTempTags.length : position;
    print("before adding ==========================================");
    selectedTempTags.insert(position, added);
    print("after adding ==========================================");
    print(selectedTempTags);
    notifyListeners();
  }

  clearTagSearch() {
    tagSearch.removeWhere((element) => true);
    notifyListeners();
  }

  Future<bool> refreshTags(User user) async {
    await getMoreTags(user);
    filterTagsByTitle(startingString: filterTitle);
    notifyListeners();
  }

  void removeTagSearchItem(String toBeRemoved) {
    tagSearch.removeWhere((tag) => tag == toBeRemoved);
    notifyListeners();
  }

  void addTagSearchItem(String tag) {
    if (tagSearch.contains(tag)) {
      //tagSearch.removeWhere((element) => element.tagId == selected.tagId);
    } else {
      tagSearch.add(tag);
    }
    notifyListeners();
  }

  void clearSearches() {
    clearTagSearch();
    notifyListeners();
  }
}
