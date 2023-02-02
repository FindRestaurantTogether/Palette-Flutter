import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';

abstract class NaverMapPageModel {
  final String uid = '';
  final String markerImage = '';
  final String exteriorImage = '';
  final String name = '';
  final bool open = false;
  final Map<String, String> open_hour = {};
  final String classification = '';
  final double distance = 0.0;
  RxBool favorite = false as RxBool;
  final List<String> atmosphere = [];
  final double naverRating = 0.0;
  final int numberOfNaverRating = 0;
  final double googleRating = 0.0;
  final int numberOfGoogleRating = 0;
  final double kakaoRating = 0.0;
  final int numberOfKakaoRating = 0;
  final List<String> service = [];
  final String address = '';
  final int phoneNumber = 0;
  final LocationClass position = LocationClass(longitude: 0.0, latitude: 0.0);
  final Map<String,int> menu = {};
}

class NaverMapPageRestaurant implements NaverMapPageModel {
  @override
  final String uid;
  @override
  final String markerImage;
  @override
  final String exteriorImage;
  @override
  final String name;
  @override
  final bool open;
  @override
  Map<String, String> open_hour;
  @override
  final String classification;
  @override
  RxBool favorite = false.obs;
  @override
  final double distance;
  @override
  final List<String> atmosphere;
  @override
  final double naverRating;
  @override
  final int numberOfNaverRating;
  @override
  final double googleRating;
  @override
  final int numberOfGoogleRating;
  @override
  final double kakaoRating;
  @override
  final int numberOfKakaoRating;
  @override
  final List<String> service;
  @override
  final String address;
  @override
  final int phoneNumber;
  @override
  final LocationClass position;
  @override
  final Map<String,int> menu;

  NaverMapPageRestaurant({
    required this.uid,
    required this.markerImage,
    required this.exteriorImage,
    required this.name,
    required this.open,
    required this.open_hour,
    required this.classification,
    required this.distance,
    favorite,
    required this.atmosphere,
    required this.naverRating,
    required this.numberOfNaverRating,
    required this.googleRating,
    required this.numberOfGoogleRating,
    required this.kakaoRating,
    required this.numberOfKakaoRating,
    required this.service,
    required this.address,
    required this.phoneNumber,
    required this.position,
    required this.menu,
  });
}
