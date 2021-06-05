import 'package:a_fathers_blessing_app/models/scripture/bible.dart';
import 'package:a_fathers_blessing_app/models/scripture/book.dart';
import 'package:a_fathers_blessing_app/models/scripture/chapter.dart';
import 'package:a_fathers_blessing_app/models/scripture/verse.dart';

class Utils {
  static createBibleFromDynamic(dynamic response) {
    String id = response["id"];
    String abbrev = response["abbreviationLocal"];
    String name = response["name"];

    return Bible(id: id, abbreviation: abbrev, name: name);
  }

  static createVerseFromDynamic(dynamic response) {
    String id = response["id"];
    String reference = response["reference"];
    String bookId = response["bookId"];
    String text = '';
    if (response["content"] != null) if (response["content"] != null) {
      text = response["content"].trim();
      text = removeRefNumbers(text).trim();
    }
    return Verse(id: id, reference: reference, bookId: bookId, text: text);
  }

  static createBookFromDynamic(dynamic response) {
    String id = response["id"];
    String abbrev = response["abbreviation"];
    String name = response["name"];
    String nameLong = response["nameLong"];

    return Book(id: id, abbreviation: abbrev, name: name, nameLong: nameLong);
  }

  static createChapterFromDynamic(dynamic response) {
    String id = response["id"];
    String reference = response["reference"];
    String bookId = response["bookId"];

    return Chapter(id: id, reference: reference, bookId: bookId);
  }

  static List<Bible> convertResponseToBible(List<dynamic> response) {
    List<Bible> bibles = [];
    for (dynamic bible in response) {
      bibles.add(createBibleFromDynamic(bible));
    }
    return bibles;
  }

  static convertResponseToBook(List<dynamic> response) {
    List<Book> books = [];
    for (dynamic book in response) {
      books.add(createBookFromDynamic(book));
    }
    return books;
  }

  static convertResponseToChapter(List<dynamic> response) {
    List<Chapter> chapters = [];
    for (dynamic chapter in response) {
      chapters.add(createChapterFromDynamic(chapter));
    }
    return chapters;
  }

  static convertResponseToVerse(List<dynamic> response) {
    List<Verse> verses = [];
    for (dynamic verse in response) {
      verses.add(createVerseFromDynamic(verse));
    }
    return verses;
  }

  static bool allVersesHaveText(List<Verse> verses) {
    List<Verse> cases =
        verses.where((verse) => verse.text.trim() == "").toList();
    return cases.length == 0;
  }

  static String getBlessingText(List<Verse> verses) {
    if (verses.length > 0) {
      List<String> verseTexts = verses.map((verse) => verse.text).toList();
      return verseTexts.join(' ');
    } else
      return '';
  }

  static generateReference(String chapter, List<int> verses) {
    List<String> verseRefs = verses.map((verse) => verse.toString()).toList();
    String refs = verseRefs.join("-");
    return "$chapter:$refs";
  }

  static String removeRefNumbers(String verse) {
    List<String> parts = verse.split(new RegExp(r"\[\d*\]"));
    return parts.join(" ");
  }

  static List<Chapter> removeBookDescription(List<Chapter> chapters) {
    print('refining');
    List<Chapter> refined = [];
    for (Chapter chapter in chapters) {
      List<String> refParts = chapter.reference.split(" ");
      String last = refParts.last;
      double chapterNumber = double.tryParse(last);
      if (chapterNumber == null) continue;
      refined.add(chapter);
    }
    return refined;
  }

  static hasBible(Bible bible, List<Bible> bibles) {
    return bibles.any((bibleElement) =>
        (bible.abbreviation == bibleElement.abbreviation) &&
        (bible.name == bibleElement.name) &&
        (bible.id == bibleElement.id));
  }

  static parseGatewayUrl(String ref) {
    return "https://www.biblegateway.com/passage/?search=${ref}";
  }
}
