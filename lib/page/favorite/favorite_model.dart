import 'package:hive/hive.dart';
part 'favorite_model.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 1)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  String favoriteFolderName;

  @HiveField(1)
  List<RestaurantModel> favoriteFolderRestaurantList;

  FavoriteModel({
    required this.favoriteFolderName,
    required this.favoriteFolderRestaurantList
  });
}

@HiveType(typeId: 2)
class RestaurantModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String store_name;

  @HiveField(2)
  final String jibun_address;

  @HiveField(3)
  final List<String> category;

  @HiveField(4)
  final String open;

  @HiveField(5)
  final List<String> store_image;

  @HiveField(6)
  final double naver_star;

  @HiveField(7)
  final int naver_cnt;


  RestaurantModel({
    required this.uid,
    required this.store_name,
    required this.jibun_address,
    required this.category,
    required this.open,
    required this.store_image,
    required this.naver_star,
    required this.naver_cnt,
  });
}