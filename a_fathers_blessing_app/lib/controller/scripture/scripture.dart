import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/scripture/utils.dart';
import 'package:a_fathers_blessing_app/models/scripture/bible.dart';
import 'package:a_fathers_blessing_app/models/scripture/book.dart';
import 'package:a_fathers_blessing_app/models/scripture/chapter.dart';
import 'package:a_fathers_blessing_app/models/scripture/verse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScriptureProvider extends ChangeNotifier {
  List<Bible> bibles = [];
  List<Book> books = [];
  List<Chapter> chapters = [];
  List<Verse> verses = [];

  Book selectedBook;
  Bible selectedBible;
  Chapter selectedChapter;
  Verse selectedVerse = Verse();

  String bibleFilter = '';
  String chapterFiler = '';
  String bookFilter = '';
  String verseFilter = '';

  List<Bible> filteredBibles = [];
  List<Book> filteredBooks = [];
  List<Chapter> filteredChapters = [];
  List<Verse> filteredVerses = [];

  String copiedText = '';

  Future<List<Bible>> getBibles() async {
    final Map<String, String> params = {
      "language": "eng",
      "include-full-details": "false"
    };
    final String endpoint = RemoteConfig.config.bibleApiUrl;
    final String apiKey = RemoteConfig.config.apiKey;
    final response = await http.get(Uri.https(endpoint, '/v1/bibles', params),
        headers: {
          'api-key': apiKey,
          HttpHeaders.contentTypeHeader: "application/json"
        }).timeout(Duration(seconds: 10));
    print(response);
    final responseJson = jsonDecode(response.body);
    List<Bible> temp = Utils.convertResponseToBible(responseJson["data"]);
    clearBibles(bibles);
    bibles.addAll(temp);

    return bibles;
  }

  Future<List<Book>> getBooks(String bibleId) async {
    final String endpoint = RemoteConfig.config.bibleApiUrl;
    final String apiKey = RemoteConfig.config.apiKey;
    final response = await http
        .get(Uri.https(endpoint, '/v1/bibles/$bibleId/books'), headers: {
      'api-key': apiKey,
      HttpHeaders.contentTypeHeader: "application/json"
    }).timeout(Duration(seconds: 10));
    print(response);
    final responseJson = jsonDecode(response.body);
    List<Book> temp = Utils.convertResponseToBook(responseJson["data"]);
    books.addAll(temp);

    return books;
  }

  Future<List<Chapter>> getChapters(String bibleId, String bookId) async {
    final String endpoint = RemoteConfig.config.bibleApiUrl;
    final String apiKey = RemoteConfig.config.apiKey;
    final response = await http.get(
        Uri.https(endpoint, '/v1/bibles/$bibleId/books/$bookId/chapters'),
        headers: {
          'api-key': apiKey,
          HttpHeaders.contentTypeHeader: "application/json"
        }).timeout(Duration(seconds: 10));
    print(response);
    final responseJson = jsonDecode(response.body);
    List<Chapter> temp = Utils.convertResponseToChapter(responseJson["data"]);
    List<Chapter> refinedChapters = Utils.removeBookDescription(temp);
    chapters.addAll(refinedChapters);

    return chapters;
  }

  Future<List<Verse>> getVerses(String bibleId, String chapterId) async {
    final String endpoint = RemoteConfig.config.bibleApiUrl;
    final String apiKey = RemoteConfig.config.apiKey;
    final response = await http.get(
        Uri.https(endpoint, '/v1/bibles/$bibleId/chapters/$chapterId/verses'),
        headers: {
          'api-key': apiKey,
          HttpHeaders.contentTypeHeader: "application/json"
        }).timeout(Duration(seconds: 10));
    print(response);
    final responseJson = jsonDecode(response.body);
    List<Verse> temp = Utils.convertResponseToVerse(responseJson["data"]);
    verses.removeWhere((element) => true);
    verses.addAll(temp);

    return verses;
  }

  Future<Verse> getVerse(String bibleId, String verseId) async {
    final String endpoint = RemoteConfig.config.bibleApiUrl;
    final String apiKey = RemoteConfig.config.apiKey;
    Map<String, String> params = {"content-type": "text"};
    final response = await http.get(
        Uri.https(endpoint, '/v1/bibles/$bibleId/verses/$verseId', params),
        headers: {
          'api-key': apiKey,
          HttpHeaders.contentTypeHeader: "application/json"
        }).timeout(Duration(seconds: 10));
    final responseJson = jsonDecode(response.body);
    Verse temp = Utils.createVerseFromDynamic(responseJson["data"]);
    return temp;
  }

  setSelectedVerse({String id, String text, String ref}) {
    if (id != null) selectedVerse.id = id;
    if (text != null) selectedVerse.text = text;
    if (ref != null) selectedVerse.reference = ref;
    notifyListeners();
  }

  filterBibleByAbbreviation({String startingString}) {
    if (startingString != null)
      filteredBibles = bibles
          .where((bible) => bible.abbreviation
              .toLowerCase()
              .startsWith(startingString.toLowerCase()))
          .toList();
    else
      filteredBibles = bibles
          .where((bible) => bible.abbreviation
              .toLowerCase()
              .startsWith(bibleFilter.toLowerCase()))
          .toList();
    notifyListeners();
  }

  filterBooksByName({String startingString}) {
    if (startingString != null)
      filteredBooks = books
          .where((book) =>
              book.name.toLowerCase().startsWith(startingString.toLowerCase()))
          .toList();
    else
      filteredBooks = books
          .where((book) =>
              book.name.toLowerCase().startsWith(bookFilter.toLowerCase()))
          .toList();
    notifyListeners();
  }

  filterChaptersByRef({String startingString}) {
    if (startingString != null)
      filteredChapters = chapters
          .where((chapter) => chapter.reference
              .toLowerCase()
              .startsWith(startingString.toLowerCase()))
          .toList();
    else
      filteredChapters = chapters
          .where((chapter) => chapter.reference
              .toLowerCase()
              .startsWith(chapterFiler.toLowerCase()))
          .toList();
    notifyListeners();
  }

  filterVersesByRef({String startingString}) {
    if (startingString != null)
      filteredVerses = verses
          .where((verse) => verse.reference
              .toLowerCase()
              .startsWith(startingString.toLowerCase()))
          .toList();
    else
      filteredVerses = verses
          .where((verse) => verse.reference
              .toLowerCase()
              .startsWith(startingString.toLowerCase()))
          .toList();
    notifyListeners();
  }

  clearBibles(List toBeCleared) {
    toBeCleared.removeWhere((element) => true);
  }

  sortBibles() {
    bibles.sort((a, b) =>
        a.abbreviation.toLowerCase().compareTo(b.abbreviation.toLowerCase()));
  }
}
