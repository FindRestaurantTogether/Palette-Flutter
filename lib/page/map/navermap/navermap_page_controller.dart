import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_marker.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapPageController extends GetxController {

  var restaurants = <NaverMapPageRestaurant>[].obs;
  var markers = <CustomMarker>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {

    // await Future.delayed(Duration(seconds: 1));

    List<NaverMapPageRestaurant> restaurantData = [
      NaverMapPageRestaurant(
          markerId: '1',
          markerImage: 'assets/marker_image/japanesebowlfourstar.png',
          anchor: AnchorPoint(0.5, 0.7),
          exteriorImage: 'assets/background_image/taroya.jpeg',
          name: '타로야1',
          open: true,
          classification: '이자카야',
          distance: 1.5,
          folder: '',
          atmosphere: ['데이트', '조용한'],
          overallRating: 4.38,
          numberOfOverallRating: 108,
          menuRating: 4.4,
          numberOfMenuRating: 74,
          restaurantRating: 4.1,
          numberOfRestaurantRating: 34,
          service: ['주차', '24시영업','포장'],
          address: '서울 마포구 상수동 93-44번지 2층',
          phoneNumber: 01054538839,
          position: LocationClass(latitude: 37.49369555120038, longitude: 127.01370530988898),
          menu: {'모둠 사시미': [26000,4.3,16], '광어 사시미': [22000,3.1,240], '참치 와사비': [20000,3.0,10], '모둠 초회': [18000,2.0,70]},
      ),
      NaverMapPageRestaurant(
          markerId: '2',
          markerImage: 'assets/marker_image/japanesebowlfourstar.png',
          anchor: AnchorPoint(0.5, 0.7),
          exteriorImage: 'assets/background_image/taroya.jpeg',
          name: '타로야2',
          open:  false,
          classification: '이자카야',
          distance: 1.5,
          folder: '',
          atmosphere: ['데이트', '조용한', '고급스러운'],
          overallRating: 4.38,
          numberOfOverallRating: 108,
          menuRating: 4.4,
          numberOfMenuRating: 74,
          restaurantRating: 4.1,
          numberOfRestaurantRating: 34,
          service: ['주차', '24시영업'],
          address: '서울 마포구 상수동 93-44번지 2층',
          phoneNumber: 01054538839,
          position: LocationClass(latitude: 37.49351987696494, longitude: 126.98648695795542),
          menu: {'모둠 사시미': [26000,4.3,16], '광어 사시미': [22000,3.1,240], '참치 와사비': [20000,3.0,10], '모둠 초회': [18000,2.0,70]},
      ),
    ];

    restaurants.assignAll(restaurantData); // 데이터 받아서 restaurants list에 데이터 추가
  }
}