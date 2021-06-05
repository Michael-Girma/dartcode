// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truth_blessing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TruthBlessingAdapter extends TypeAdapter<TruthBlessing> {
  @override
  final int typeId = 2;

  @override
  TruthBlessing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TruthBlessing(
      docId: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
    )..tags = (fields[3] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, TruthBlessing obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.docId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TruthBlessingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
