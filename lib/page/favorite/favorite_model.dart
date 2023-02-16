import 'package:hive/hive.dart';
part 'favorite_model.g.dart';

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
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final String call;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String main_category;

  @HiveField(8)
  final String open;

  @HiveField(9)
  final Map<String, String> opening_hour;

  @HiveField(10)
  final Map<String, String> opening_breaktime;

  @HiveField(11)
  final Map<String, String> opening_lastorder;

  @HiveField(12)
  final List<String> theme;

  @HiveField(13)
  final List<String> service;

  @HiveField(14)
  final Map<String, int> menu;

  @HiveField(15)
  final List<String> store_image;

  @HiveField(16)
  final double naver_star;

  @HiveField(17)
  final int naver_cnt;

  @HiveField(18)
  final String naver_review_url;

  @HiveField(19)
  final double google_star;

  @HiveField(20)
  final int google_cnt;

  @HiveField(21)
  final String google_review_url;

  @HiveField(22)
  final double kakao_star;

  @HiveField(23)
  final int kakao_cnt;

  @HiveField(24)
  final String kakao_review_url;


  RestaurantModel({
    required this.uid,
    required this.store_name,
    required this.jibun_address,
    required this.latitude,
    required this.longitude,
    required this.call,
    required this.category,
    required this.main_category,
    required this.open,
    required this.opening_hour,
    required this.opening_breaktime,
    required this.opening_lastorder,
    required this.theme,
    required this.service,
    required this.menu,
    required this.store_image,
    required this.naver_star,
    required this.naver_cnt,
    required this.naver_review_url,
    required this.google_star,
    required this.google_cnt,
    required this.google_review_url,
    required this.kakao_star,
    required this.kakao_cnt,
    required this.kakao_review_url
  });
}