import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Utils{
  static convertResponseToTag(List<dynamic> response) {
    List<Tag> tags = [];
    for (dynamic tag in response) {
      tags.add(convertMapToTag(tag));
    }
    return tags;
  }

  static convertMapToTag(tagMap) {
    String tagText = tagMap["_id"];
    int myBlessings = tagMap["myBlessings"];
    int truthBlessings = tagMap["truthBlessings"];
    return Tag(
        tagText: tagText,
        myBlessings: myBlessings,
        truthBlessings: truthBlessings);
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

  static convertDynamicToTags(var list) {
    print(list.runtimeType);
    List<Tag> tags = [];
    for (var item in list) {
      tags.add(item as Tag);
    }
    print(list.runtimeType);
    return tags;
  }

  static bool tagExists(String text ,{List<String> allTags, List<Tag> allTagObjects}){
    if(allTags != null ) return tagListForComparison(allTags).contains(text.trim());
    if(allTagObjects != null) return tagsToTagText(allTagObjects, comparison: true).contains(text.toLowerCase().trim());
    return false;
  }

  static List<String> tagsToTagText(List<Tag> allTags, {comparison = false}){
    if(!comparison) return allTags.map((e) => e.tagText).toList();
    else return tagListForComparison(allTags.map((e) => e.tagText).toList());
  }

  static List<String> tagListForComparison(List<String> list){
    // return list.map((e) => e.toLowerCase().trim()).toList();
    return list.map((e) => e.trim()).toList();
  }

  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // static Future<List<Tag>> getAllTags({email}) async{
  //   List<Tag> tags= [];
    
  //   Query query = _firestore.collection('tags').where("email", isEqualTo: email);

  //   var snapshot = await query.get();
  //   // print(snapshot.size);
  //   tags = tagSnapshotToList(snapshot);
  //   return tags;  
  // }

  // static Future<List<Tag>> getBlessingTags({email, blessingId, truthBlessing=false}) async{
  //   List<Tag> tags= [];
    
  //   String container = "";
  //   if(truthBlessing)
  //     container = "truthBlessings";
  //   else
  //     container = "myBlessings";

  //   print("""
      
  //     $blessingId,
  //     $email,
  //     $container

  //   """);

  //   Query query = _firestore.collection('tags').where("email", isEqualTo: email);
  //   query = query.where(container, arrayContains: blessingId);

  //   var snapshot = await query.get();
  //   // print(snapshot.size);
  //   tags = tagSnapshotToList(snapshot);
  //   return tags;  
  // }

  // static List<Tag> tagSnapshotToList(snapshot){
  //   List<Tag> tags = [];
  //   for(var tagDoc in snapshot.docs){
  //     Tag tag = tagDocToModel(tagDoc);
  //     tags.add(tag);
  //   }
  //   return tags;
  // }

  // static Map<String, dynamic> tagToMap(Tag tag, ){
  //   return <String, dynamic>{
  //     // "email": tag.email,
  //     "myBlessings": tag.myBlessings,
  //     "truthBlessings": tag.truthBlessings,
  //     "tagText": tag.tagText
  //   };
  // }

  // static Tag tagDocToModel(tagDoc){
  //   var tagData = tagDoc.data();

  //   String id = tagDoc.id;
  //   String text = tagData["tagText"];
  //   String email = tagData["email"];
  //   List<String> truthBlessings = [];
  //   List<String> myBlessings = [];
  //   if(tagData["truthBlessings"] != null){
  //     for(var text in tagData["truthBlessings"]){
  //       truthBlessings.add(text.toString());
  //     }
  //   }
  //   if(tagData["myBlessings"] != null){
  //     for(var text in tagData["myBlessings"]){
  //       myBlessings.add(text.toString());
  //     }
  //   }
  //   // for(var text in tagData["truthBlessings"]){
  //   //   truthBlessings.add(text.toString());
  //   // }
  //   // for(var text in tagData["myBlessings"]){
  //   //   myBlessings.add(text.toString());
  //   // }

  //   return Tag();
  // }

  // static List<String> tagTextFromTagList(tagList){
  //   List<String> tagText = [];
  //   for(Tag tag in tagList){
  //     tagText.add(tag.tagText);
  //   } 
  //   return tagText;
  // }

  // static List<Tag> getTagsForBlessing(List<Tag> tags, {TruthBlessing truthBlessing, MyBlessing myBlessing}){
  //   List<Tag> blessingTags = [];
    
  //   if(truthBlessing != null){
  //     //blessingTags += tags.where((tag)=>tag.truthBlessings.contains(truthBlessing.getDocId)).toList();
  //     print("truth blessing tags $blessingTags");
  //   }
  //   else if(myBlessing != null){
  //    // blessingTags += tags.where((tag)=>tag.myBlessings.contains(myBlessing.docId)).toList();
  //   }

  //   return blessingTags;
  // }

  // static WriteBatch removeTagBatch({WriteBatch batch, String blessingId, List<Tag> toBeDeleted, truthBlessing = false}){
  //   CollectionReference allTags = _firestore.collection("tags");
  //   String container = "myBlessings";
  //   if(truthBlessing){
  //     container = "truthBlessings";
  //   }

  //   for(Tag tag in toBeDeleted){
  //     //DocumentReference docRef = allTags.doc(tag.tagId);
  //     // batch.update(docRef, {
  //     //   container: FieldValue.arrayRemove([blessingId])
  //     // });
  //   }

  //   return batch;
  // }

  // static WriteBatch addExistingTagBatch({WriteBatch batch, String blessingId, List<Tag> toBeAdded, truthBlessing = false}){
  //   CollectionReference allTags = _firestore.collection("tags");
  //   String container = "myBlessings";
  //   if(truthBlessing){
  //     container = "truthBlessings";
  //   }
    
  //   print(toBeAdded);
  //   for(Tag tag in toBeAdded){
  //     // DocumentReference docRef = allTags.doc(tag.tagId);
  //     // batch.update(docRef, {
  //     //   container: FieldValue.arrayUnion([blessingId])
  //     // });
  //   }
  //   return batch;
  // }

  // static WriteBatch addNewTagBatch({WriteBatch batch, List<Tag> toBeAdded, String docId, truthBlessing = false}){
  //   CollectionReference allTags = _firestore.collection("tags");
    
  //   for(Tag tag in toBeAdded){
  //     DocumentReference docRef = allTags.doc();
  //     batch.set(docRef, newTagToMap(tag, docId, truthBlessing: truthBlessing));
  //     // batch.set(document, data)
  //   }
  //   return batch;
  // }

  // static Map<String,dynamic> newTagToMap(Tag tag, String docId, {bool truthBlessing = false}){
  //   // tag.myBlessings = [];
  //   // tag.truthBlessings = [];
  //   Map<String,dynamic> docMap = tagToMap(tag);
  //   if(truthBlessing) docMap["truthBlessings"] = [docId];
  //   else docMap["myBlessings"] = [docId];
  //   return docMap;
  // }

  // static List<Tag> switchBlessingTags(List<Tag> tags){
  //   for(Tag tag in tags){
  //     // List<String> temp = <String>[]+tag.myBlessings;
  //     // tag.myBlessings = tag.truthBlessings;
  //     // tag.truthBlessings = temp;
  //   }
  //   return tags;
  // }

  // static Tag makeNewTag(String tagText, String email, String blessingId, {truthBlessing = false}){
  //   // Tag newTag = Tag(tagId: "--$tagText", tagText: tagText, email: email);
  //   // if (truthBlessing){
  //   //   newTag.setTruthBlessings = [blessingId];
  //   // }else{
  //   //   newTag.setMyBlessings = [blessingId];
  //   // }
  //   return Tag();
  // }



  // static List<String> getCommonBlessings(List<Tag> tags, {truthBlessing = false}){
  //   List<String> blessings = [];

  //   // if(tags.length > 0 && truthBlessing){
  //   //   blessings = <String>[] + tags[0].truthBlessings;
  //   //   for(Tag tag in tags){
  //   //     blessings.removeWhere((blessing) => !tag.truthBlessings.contains(blessing));
  //   //   } 
  //   // }if(tags.length > 0 && !truthBlessing){
  //   //   blessings = <String>[] + tags[0].myBlessings;
  //   //   print("selected for searchin $blessings ======================");
  //   //   for(Tag tag in tags){
  //   //     blessings.removeWhere((blessing) => !tag.myBlessings.contains(blessing));
  //   //   } 
  //   // }

  //   return blessings;
  // }
}

