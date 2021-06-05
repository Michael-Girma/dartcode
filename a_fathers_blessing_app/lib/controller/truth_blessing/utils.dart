import 'package:a_fathers_blessing_app/controller/tag/utils.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';

class Utils{
  static convertBlessingToMap(TruthBlessing blessing, {forEdit = false}) {
    //make empty object
    Map blessingMap = {};
    if (!forEdit) blessingMap["title"] = blessing.title;
    blessingMap["body"] = blessing.body;
    blessingMap["tags"] = blessing.tags.runtimeType == <String>[""].runtimeType
        ? blessing.tags
        : [];
    return blessingMap;
  }

  static convertMapToBlessing(dynamic blessingMap) {
    //convert _id to docId
    String docId = blessingMap["_id"];
    String title = blessingMap["title"];
    String body = blessingMap["body"];
    List<dynamic> tagObjects = blessingMap["tags"];
    List<String> tags = [];
    for (Map tag in tagObjects) {
      print("==================== $tag");
      tags.add(tag["tagText"]);
    }
    return TruthBlessing(docId: docId, title: title, body: body, tags: tags);
  }

  static convertResponseToBlessing(List<dynamic> response) {
    List<TruthBlessing> blessings = [];
    for (dynamic blessing in response) {
      blessings.add(convertMapToBlessing(blessing));
    }
    return blessings;
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

  static String getModifyingUrlExtension(String id, {bool delete}) {
    if (delete != null)
      return '/$id/delete';
    else
      return '/$id/saveTags';
  }

  
  static convertDynamicToTruthBlessing(var list) {
    print(list.runtimeType);
    List<TruthBlessing> blessings = [];
    for (var item in list) {
      blessings.add(item as TruthBlessing);
    }
    print(list.runtimeType);
    return blessings;
  }

}