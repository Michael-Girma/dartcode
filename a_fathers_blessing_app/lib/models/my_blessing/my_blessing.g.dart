// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_blessing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyBlessingAdapter extends TypeAdapter<MyBlessing> {
  @override
  final int typeId = 0;

  @override
  MyBlessing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyBlessing(
      docId: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      email: fields[3] as String,
    )..tags = (fields[4] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, MyBlessing obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.docId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyBlessingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
