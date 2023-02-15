// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recentsearch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentSearchModelAdapter extends TypeAdapter<RecentSearchModel> {
  @override
  final int typeId = 0;

  @override
  RecentSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearchModel(
      recentSearchWord: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSearchModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recentSearchWord);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
