import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 1)
class Tag{
  @HiveField(0)
  String tagText;

  @HiveField(1)
  int truthBlessings = 0;
  
  @HiveField(2)
  int myBlessings = 0;

  Tag({this.tagText, this.truthBlessings, this.myBlessings});

  
  @override
  String toString() {
    return this.tagText;
  }

  @override
  int get typeId => 0;
}