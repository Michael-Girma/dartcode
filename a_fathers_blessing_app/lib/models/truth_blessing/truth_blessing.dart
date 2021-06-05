import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:hive/hive.dart';

part 'truth_blessing.g.dart';
@HiveType(typeId: 2)
class TruthBlessing{
  @HiveField(0)
  String docId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;
  // List<Tag> tagObjects = [];
  @HiveField(3)
  List<String> tags = [];
  
  TruthBlessing({this.docId, this.title, this.body, this.tags});

  @override
  int get typeId => 0;
}