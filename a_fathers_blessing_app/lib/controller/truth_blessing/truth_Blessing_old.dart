
  // //old code base
  // //Getting data from firestore
  // Future<void> getBlessingsFromFirestore(User user) async{
  //   Query query = _firestore.collection('truth78blessings');
  //   final blessings = await query.get();
  //   List<Tag> userTags = await TagUtils.getAllTags(email: user.email);
  //   truthBlessings = await blessingSnapshotToList(blessings, setTags: true, userTags: userTags);

  //   notifyListeners();
  // }

  // Future<List<TruthBlessing>> blessingSnapshotToList(snapshot, {setTags = false, List<Tag>userTags}) async{
  //   List<TruthBlessing> blessings = [];

  //   for(var blessingDoc in snapshot.docs){
  //     TruthBlessing blessing = TruthBlessingUtils.blessingDocToModel(blessingDoc);
  //     if(setTags){
  //       List<Tag> blessingTags= TagUtils.getTagsForBlessing(userTags, truthBlessing: blessing);
  //       print("=-==========0=0=0=0=0= fetched blessing tags $blessingTags");
  //       //blessing.tagObjects = blessingTags;
  //       refreshBlessingTags(blessing);
  //     }
  //     blessings.add(blessing);
  //   }
  //   return blessings;
  // }

  // void setSelectedBlessing(String selectedId){
  //   selectedBlessing = truthBlessings.firstWhere((blessing) => blessing.docId == selectedId);

  //   notifyListeners();
  // }

  // void refreshBlessingTags(blessing){
  //   blessing.setTags = TagUtils.tagTextFromTagList(blessing.tagObjects);
  // }

  // Future<List<TruthBlessing>> getBlessingsById(List<String> blessingIds, User user) async {
  //   Query query = _firestore.collection('truth78blessings')
  //     .orderBy("title")
  //     .where("docId", whereIn: blessingIds);
  //   final blessings = await query.get();
  //   List<Tag> userTags = await TagUtils.getAllTags(email: user.email);
  //   return await blessingSnapshotToList(blessings, setTags: true, userTags: userTags);
  // }

  // // Future<List<TruthBlessing>> getTaggedBlessings(List<String> blessingIds, User user) async{
  // //   return await _lock.synchronized(()async{
  // //     if(blessingIds!= null){
  // //     // filteredBlessings = myBlessings.where((blessing) => blessingIds.contains(blessing.docId)).toList();
  // //     List<List<String>> fetches = getIdsByChunks(blessingIds, 9);
  // //     if(tagFilterPage == null) filteredBlessings = [];

  // //     int next = tagFilterPage==null? 0 : tagFilterPage + 1;
  // //     if( fetches.length > next){
  // //       print("featching truth");
  // //       List<TruthBlessing> blessings = await getBlessingsById(fetches[next], user);
  // //       filteredBlessings.addAll(blessings);
  // //       tagFilterPage = next;
  // //       notifyListeners();
  // //       return blessings;
  // //     }
  // //     print("iauiaugbri briuagb iurbg uibg uibg iabg ubgai uuia iuag ${filteredBlessings.length}");
  // //     return [];
  // //   }
  // //   return [];
  // //   });
  // // }
  // Future<List<TruthBlessing>> getTaggedBlessings(List<String> blessingIds, User user) async{
  //   return await _lock.synchronized(()async{
  //     if(blessingIds!= null){
  //     // filteredBlessings = myBlessings.where((blessing) => blessingIds.contains(blessing.docId)).toList();
  //     List<List<String>> fetches = getIdsByChunks(blessingIds, 9);
  //     if(tagFilterPage == null) filteredBlessings = [];

  //     int next = tagFilterPage==null? 0 : tagFilterPage + 1;
  //     if(fetches.length > next){
  //       print("featching truth");
  //       List<TruthBlessing> blessings = await getBlessingsById(fetches[next], user);
  //       print("featching the blessings ${blessings.length}");
  //       filteredBlessings.addAll(blessings);
  //       tagFilterPage = next;
  //       notifyListeners();
  //       return blessings;
  //     }
  //     return [];
  //   }
  //   return [];
  //   });
  // }

  // List<List<String>> getIdsByChunks(List<String> blessingIds, int size){
  //   List<List<String>> chunks = [];
  //   int len = blessingIds.length;

  //   for(var i = 0; i< len; i+= size){
  //     var end = (i+size<len)?i+size:len;
  //     chunks.insert(0,blessingIds.sublist(i,end));
  //   }

  //   return chunks;
  // }

  // Future<void> reloadFilteredBlessings(List<String> blessingIds, User user) async{
  //   if(blessingIds != null && tagFilterPage!=null){
  //     filteredBlessings = [];
  //     List<List<String>> chunks = getIdsByChunks(blessingIds, 9);
  //     for(int i = 0 ; i < tagFilterPage ; i++){
  //       filteredBlessings.addAll(await getBlessingsById(chunks[i], user));
  //     }
  //     // for(List<String> list in chunks ){
  //     //   filteredBlessings.addAll(await getBlessingsById(list, user));
  //     // }
  //     notifyListeners();
  //   }
  // }

  // void setTagObjects(List<Tag> tags){
  //   //this.temporaryBlessing.tagObjects = tags;
  //   this.temporaryBlessing.tags = tags.map((blessingTag) => blessingTag.tagText).toList();
  //   notifyListeners();
  // }

  // List<Map<String, Object>> mapBlessingBody(){
  //   List<Map<String, String>> mappedBlessings = [];
  //   mappedBlessings = truthBlessings.map((blessing){
  //     return {
  //       'docId': blessing.docId,
  //       'body': blessing.body
  //     };
  //   }).toList();
  //   return mappedBlessings;
  // }

  // Future<void> updateFilterFromFirestore(List<String> blessingIds, User user) async{
  //   if(blessingIds!= null && blessingIds.length > 0) filteredBlessings = await getBlessingsById(blessingIds, user);
  //   else filteredBlessings = [];
  //   notifyListeners();
  // }

  // Future<List<TruthBlessing>> getMoreBlessings(int docLimit, user) async{
  //   List<TruthBlessing> blessings = await _lock.synchronized(() async {
  //     // Only this block can run (once) until done
  //     QuerySnapshot querySnapshot;
  //     if(!fetchedLastDoc){
  //       if (lastBlessingDocument == null) {
  //         truthBlessings = [];
  //         querySnapshot = await _firestore
  //             .collection('truth78blessings')
  //             .orderBy('title')
  //             .limit(docLimit)
  //             .get();
  //       } else{
  //         querySnapshot = await _firestore
  //             .collection('truth78blessings')
  //             .orderBy('title')
  //             .startAfterDocument(lastBlessingDocument)
  //             .limit(docLimit)
  //             .get();
  //       }
  //       // print("-=-=-=-=-=-=-=-=-=-= recieved doc numbers ${querySnapshot.docs.length}");
  //       if(querySnapshot.docs.length > 0){
  //         if(lastBlessingDocument == null ) userTags = await TagUtils.getAllTags(email: user.email);
  //         lastBlessingDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
  //         List<TruthBlessing> blessings = await blessingSnapshotToList(querySnapshot, setTags: true, userTags: userTags);
  //         truthBlessings.addAll(blessings);

  //         return blessings;
  //       }
  //       fetchedLastDoc = true;
  //       return [];
  //     }else{
  //       return [];
  //     }
  //   });
  //   notifyListeners();
  //   return blessings;
  // }

  // reloadBlessings(User user) async{
  //   fetchedLastDoc = false;
  //   QuerySnapshot querySnapshot;
  //   if(lastBlessingDocument == null) return;

  //   truthBlessings = [];

  //   querySnapshot = await _firestore
  //       .collection('truth78blessings')
  //       .where("email", isEqualTo: user.email)
  //       .orderBy('title')
  //       .endBeforeDocument(lastBlessingDocument)
  //       .get();

  //   if(querySnapshot.docs.length > 0){
  //     userTags = await TagUtils.getAllTags(email: user.email);
  //     lastBlessingDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
  //     List<TruthBlessing> blessings = await blessingSnapshotToList(querySnapshot, setTags: true, userTags: userTags);
  //     truthBlessings.addAll(blessings);
  //     notifyListeners();
  //     return blessings;
  //   }

  // }

  // // makeTempSelected(){
  // //   refreshBlessingTags(temporaryBlessing);
  // //   //selectedBlessing.tagObjects = temporaryBlessing.tagObjects;
  // //   selectedBlessing.tags = temporaryBlessing.tags;
  // //   notifyListeners();
  // // }

  // void changeBlessing(){
  //   truthBlessings[0].tags = [""];
  //   notifyListeners();
  // }

  // Future<List<TruthBlessing>> searchTaggedBlessings(List<String> blessingIds) async{
  //   return await _lock.synchronized(()async{
  //     if(blessingIds!= null){
  //     // filteredBlessings = myBlessings.where((blessing) => blessingIds.contains(blessing.docId)).toList();
  //     List<List<String>> fetches = getIdsByChunks(blessingIds, 9);
  //     if(tagSearchPage == null) tagSearched = [];

  //     int next = tagSearchPage==null? 0 : tagSearchPage + 1;
  //     if(fetches.length > next){
  //       print("featching truth");
  //       List<TruthBlessing> blessings = await getBlessingsById(fetches[next], user);
  //       print("featching the blessings ${blessings.length}");
  //       tagSearched.addAll(blessings);
  //       tagSearchPage = next;
  //       notifyListeners();
  //       return blessings;
  //     }
  //     return [];
  //   }
  //   return [];
  //   });
  // }

  // Future<List<TruthBlessing>> searchTextBlessings(List<String> blessingIds) async{
  //   return await _lock.synchronized(()async{
  //     if(blessingIds!= null){
  //     // filteredBlessings = myBlessings.where((blessing) => blessingIds.contains(blessing.docId)).toList();
  //     List<List<String>> fetches = getIdsByChunks(blessingIds, 9);
  //     if(textSearchPage == null) tagSearched = [];

  //     int next = textSearchPage==null? 0 : textSearchPage + 1;
  //     if(fetches.length > next){
  //       print("featching truth");
  //       List<TruthBlessing> blessings = await getBlessingsById(fetches[next], user);
  //       print("featching the blessings ${blessings.length}");
  //       textSearched.addAll(blessings);
  //       textSearchPage = next;
  //       notifyListeners();
  //       return blessings;
  //     }
  //     return [];
  //   }
  //   return [];
  //   });
  // }