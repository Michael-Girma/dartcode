import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:hive/hive.dart';

part 'my_blessing.g.dart' ;

@HiveType(typeId: 0)
class MyBlessing{
  @HiveField(0)
  String docId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  String email;
  // List<Tag> tagObjects = []
  // 
  @HiveField(4)
  List<String> tags = [];


  MyBlessing({this.docId, this.title, this.body, this.email, this.tags});

  @override
  int get typeId => 0;
}