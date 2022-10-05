// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasbeehModelAdapter extends TypeAdapter<TasbeehModel> {
  @override
  final int typeId = 1;

  @override
  TasbeehModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbeehModel(
      title: fields[0] as String,
      text: fields[1] as String,
      target: fields[2] as int,
      count: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TasbeehModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.target)
      ..writeByte(3)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbeehModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
