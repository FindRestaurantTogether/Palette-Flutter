import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';

abstract class NaverMapPageModel {
  final String uid = '';
  final String main_category = '';
  final List<String> store_image = [];
  final String store_name = '';
  final String open = '';
  final Map<String, String> opening_hour = {};
  final Map<String, String> opening_breaktime = {};
  final Map<String, String> opening_lastorder = {};
  final String category = '';
  final double distance = 0.0;
  RxBool favorite = false as RxBool;
  final List<String> theme = [];
  final double naver_star = 0.0;
  final int naver_cnt = 0;
  final double google_star = 0.0;
  final int google_cnt = 0;
  final double kakao_star = 0.0;
  final int kakao_cnt = 0;
  final List<String> service = [];
  final String jibun_address = '';
  final int call = 0;
  final LocationClass position = LocationClass(longitude: 0.0, latitude: 0.0);
  final Map<String,int> menu = {};
}

class NaverMapPageRestaurant implements NaverMapPageModel {
  @override
  final String uid;
  @override
  final String main_category;
  @override
  final List<String> store_image;
  @override
  final String store_name;
  @override
  final String open;
  @override
  final Map<String, String> opening_hour;
  @override
  final Map<String, String> opening_breaktime;
  @override
  final Map<String, String> opening_lastorder;
  @override
  final String category;
  @override
  RxBool favorite = false.obs;
  @override
  final double distance;
  @override
  final List<String> theme;
  @override
  final double naver_star;
  @override
  final int naver_cnt;
  @override
  final double google_star;
  @override
  final int google_cnt;
  @override
  final double kakao_star;
  @override
  final int kakao_cnt;
  @override
  final List<String> service;
  @override
  final String jibun_address;
  @override
  final int call;
  @override
  final LocationClass position;
  @override
  final Map<String,int> menu;

  NaverMapPageRestaurant({
    required this.uid,
    required this.main_category,
    required this.store_image,
    required this.store_name,
    required this.open,
    required this.opening_hour,
    required this.opening_breaktime,
    required this.opening_lastorder,
    required this.category,
    required this.distance,
    favorite,
    required this.theme,
    required this.naver_star,
    required this.naver_cnt,
    required this.google_star,
    required this.google_cnt,
    required this.kakao_star,
    required this.kakao_cnt,
    required this.service,
    required this.jibun_address,
    required this.call,
    required this.position,
    required this.menu,
  });
}
