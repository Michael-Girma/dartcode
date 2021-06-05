import 'package:a_fathers_blessing_app/models/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteConfig{
  static Config config = Config();

  FirebaseFirestore _instance = FirebaseFirestore.instance;

  RemoteConfig() {
    config = Config();
    addChangeListener();
  }

  addChangeListener() {
    CollectionReference reference = _instance.collection('settings');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        print("checking changes for the configs");
        if (change.doc.id == "config") {
          Map<String, dynamic> fetchedDoc = change.doc.data();
          config = Config.fromJson(fetchedDoc);
          print("Fetched new config document $config");
        }
      });
    });
  }


}
