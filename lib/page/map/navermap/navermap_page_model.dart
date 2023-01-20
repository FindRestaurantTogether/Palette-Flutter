import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';

abstract class NaverMapPageModel {
  final String uid = '';
  final String markerImage = '';
  final String exteriorImage = '';
  final String name = '';
  final bool open = false;
  final String classification = '';
  final double distance = 0.0;
  RxBool favorite = false as RxBool;
  final String folder = '';
  final List<String> atmosphere = [];
  final double overallRating = 0.0;
  final int numberOfOverallRating = 0;
  final double menuRating = 0.0;
  final int numberOfMenuRating = 0;
  final double restaurantRating = 0.0;
  final int numberOfRestaurantRating = 0;
  final List<String> service = [];
  final String address = '';
  final int phoneNumber = 0;
  final LocationClass position = LocationClass(longitude: 0.0, latitude: 0.0);
  final Map<String,List<double>> menu = {};
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
  final String classification;
  @override
  RxBool favorite = false.obs;
  @override
  final String folder;
  @override
  final double distance;
  @override
  final List<String> atmosphere;
  @override
  final double overallRating;
  @override
  final int numberOfOverallRating;
  @override
  final double menuRating;
  @override
  final int numberOfMenuRating;
  @override
  final double restaurantRating;
  @override
  final int numberOfRestaurantRating;
  @override
  final List<String> service;
  @override
  final String address;
  @override
  final int phoneNumber;
  @override
  final LocationClass position;
  @override
  final Map<String,List<double>> menu;

  NaverMapPageRestaurant({
    required this.uid,
    required this.markerImage,
    required this.exteriorImage,
    required this.name,
    required this.open,
    required this.classification,
    required this.distance,
    favorite,
    required this.folder,
    required this.atmosphere,
    required this.overallRating,
    required this.numberOfOverallRating,
    required this.restaurantRating,
    required this.numberOfRestaurantRating,
    required this.menuRating,
    required this.numberOfMenuRating,
    required this.service,
    required this.address,
    required this.phoneNumber,
    required this.position,
    required this.menu,
  });
}
