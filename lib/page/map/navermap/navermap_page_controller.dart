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
    fetchRestaurantData();
  }

  // 백에서 데이터 가져오기
  void fetchRestaurantData() {

    // await Future.delayed(Duration(seconds: 1));

    // 이거는 가져왔다는 가정하에 데이터 추가한거
    List<NaverMapPageRestaurant> restaurantData = [
      NaverMapPageRestaurant(
        uid: '1', // 음식점 고유 번호
        markerImage: 'assets/marker_image/alcohol_cocktail_5.0.png', // 음식점 마커 이미지
        store_image: 'assets/background_image/taroya.jpeg', // 음식점 외부 이미지
        store_name: '타로야1', // 음식점 이름
        open: true,
        opening_hour: {'월': '12:00 - 22:00', '화': '12:00 - 22:00', '수': '12:00 - 22:00', '목': '12:00 - 22:00','금': '12:00 - 23:00', '토': '12:00 - 23:00', '일': '12:00 - 22:00'}, // 음식점 영업 시간
        category: '이자카야', // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
        distance: 1.5, // 음식점의 현 위치와의 거리
        theme: ['데이트', '조용한'], // 음식점 분위기
        naver_star: 4.1, // 음식점 네이버 평점
        naver_cnt: 101, // 음식점 네이버 리뷰 개수
        google_star: 4.2, // 음식점 구글 평점
        google_cnt: 102, // 음식점 구글 리뷰 개수
        kakao_star: 4.3, // 음식점 카카오 평점
        kakao_cnt: 103, // 음식점 카카오 리뷰 개수
        service: ['주차', '24시영업','포장'], // 음식점 서비스
        address: '서울 마포구 상수동 93-44번지 2층', // 음식점 주소
        call: 01054538839, // 음식점 전화번호
        position: LocationClass(latitude: 37.49369555120038, longitude: 127.01370530988898),
        menu: {'모둠 사시미': 26000, '광어 사시미': 22000, '참치 와사비': 20000, '모둠 초회': 18000}, // 음식점 메뉴
      ),
      NaverMapPageRestaurant(
        uid: '2', // 음식점 고유 번호
        markerImage: 'assets/marker_image/alcohol_cocktail_5.0.png', // 음식점 마커 이미지
        store_image: 'assets/background_image/taroya.jpeg', // 음식점 외부 이미지
        store_name: '타로야2', // 음식점 이름
        open: true,
        opening_hour: {'월': '12:00 - 22:00', '화': '12:00 - 22:00', '수': '12:00 - 22:00', '목': '12:00 - 22:00','금': '12:00 - 23:00', '토': '12:00 - 23:00', '일': '12:00 - 22:00'}, // 음식점 영업 시간
        category: '이자카야', // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
        distance: 1.5, // 음식점의 현 위치와의 거리
        theme: ['데이트', '조용한'], // 음식점 분위기
        naver_star: 4.1, // 음식점 네이버 평점
        naver_cnt: 101, // 음식점 네이버 리뷰 개수
        google_star: 4.2, // 음식점 구글 평점
        google_cnt: 102, // 음식점 구글 리뷰 개수
        kakao_star: 4.3, // 음식점 카카오 평점
        kakao_cnt: 103, // 음식점 카카오 리뷰 개수
        service: ['주차', '24시영업','포장'], // 음식점 서비스
        address: '서울 마포구 상수동 93-44번지 2층', // 음식점 주소
        call: 01054538839, // 음식점 전화번호
        position: LocationClass(latitude: 37.49351987761151, longitude: 126.98649261194777),
        menu: {'모둠 사시미': 26000, '광어 사시미': 22000, '참치 와사비': 20000, '모둠 초회': 18000}, // 음식점 메뉴
      ),
    ];

    // restaurants 변수에 백에서 가져온 데이터 넣기
    restaurants.assignAll(restaurantData); // 데이터 받아서 restaurants list에 데이터 추가
  }
}