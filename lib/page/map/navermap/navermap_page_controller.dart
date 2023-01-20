import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_marker.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';

class NaverMapPageController extends GetxController {

  // 백에서 가져온 데이터 저장 후 이후 다른 페이지에서 이 데이터들 사용
  var restaurants = <NaverMapPageRestaurant>[].obs;
  // 위에 데이터들로 CustomMarker 생성후 markers에 저장
  var markers = <CustomMarker>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // 백에서 데이터 가져오기
  void fetchData() {

    // await Future.delayed(Duration(seconds: 1));

    // 이거는 가져왔다는 가정하에 데이터 추가한거
    List<NaverMapPageRestaurant> restaurantData = [
      NaverMapPageRestaurant(
        uid: '1',
        markerImage: 'assets/marker_image/japan_image/japan_ramen.png',
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
        uid: '2',
        markerImage: 'assets/marker_image/japan_image/japan_udon.png',
        exteriorImage: 'assets/background_image/taroya.jpeg',
        name: '타로야2',
        open: false,
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
        position: LocationClass(latitude: 37.49351762541697, longitude: 126.9864954393495),
        menu: {'모둠 사시미': [26000,4.3,16], '광어 사시미': [22000,3.1,240], '참치 와사비': [20000,3.0,10], '모둠 초회': [18000,2.0,70]},
      ),
    ];

    // restaurants 변수에 백에서 가져온 데이터 넣기
    restaurants.assignAll(restaurantData); // 데이터 받아서 restaurants list에 데이터 추가
  }
}