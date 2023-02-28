import 'package:myapp/page/map/navermap/navermap_page.dart';

abstract class AbstractNaverMapPageModel {
  final String uid = '';
  final String main_category = '';
  final LocationClass position = LocationClass(longitude: 0.0, latitude: 0.0);
}

class AbstractNaverMapPageRestaurant implements AbstractNaverMapPageModel {
  @override
  final String uid;
  @override
  final String main_category;
  @override
  final LocationClass position;

  AbstractNaverMapPageRestaurant({
    required this.uid,
    required this.main_category,
    required this.position,
  });
}
