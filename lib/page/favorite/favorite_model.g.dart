// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteModelAdapter extends TypeAdapter<FavoriteModel> {
  @override
  final int typeId = 1;

  @override
  FavoriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteModel(
      favoriteFolderName: fields[0] as String,
      favoriteFolderRestaurantList: (fields[1] as List).cast<RestaurantModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.favoriteFolderName)
      ..writeByte(1)
      ..write(obj.favoriteFolderRestaurantList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RestaurantModelAdapter extends TypeAdapter<RestaurantModel> {
  @override
  final int typeId = 2;

  @override
  RestaurantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantModel(
      uid: fields[0] as String,
      store_name: fields[1] as String,
      jibun_address: fields[2] as String,
      category: (fields[3] as List).cast<String>(),
      open: fields[4] as String,
      store_image: (fields[5] as List).cast<String>(),
      naver_star: fields[6] as double,
      naver_cnt: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.store_name)
      ..writeByte(2)
      ..write(obj.jibun_address)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.open)
      ..writeByte(5)
      ..write(obj.store_image)
      ..writeByte(6)
      ..write(obj.naver_star)
      ..writeByte(7)
      ..write(obj.naver_cnt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
