import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/map/bottomsheet/bottomsheet_page.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/map_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_marker.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapPageController extends GetxService {

  final _MapPageController = Get.put(MapPageController());
  final _FilterPageController = Get.put(FilterPageController());

  // 백에서 가져온 데이터 저장 후 이후 다른 페이지에서 이 데이터들 사용
  var restaurants = <NaverMapPageRestaurant>[].obs;
  // 위에 데이터들로 CustomMarker 생성후 markers에 저장
  var markers = <CustomMarker>[].obs;

  // 백에서 데이터 가져오기
  Future<void> fetchRestaurantData(context, value) async {

    restaurants.value = [];
    markers.value = [];

    if (_FilterPageController.FilterSelected.value.contains(true) || value != '') {
      // 이거는 가져왔다는 가정하에 데이터 추가한거
      List<NaverMapPageRestaurant> processedRestaurantData = [];

      // List filter = read_all();
      // Network network = Network(filter, value);
      // var RawRestaurantData = await network.getJsonData();
      print('================================================================');
      // print(RawRestaurantData);
      print('================================================================');

      // 백에서 가져온 map 데이터
      var RawRestaurantData = {
        0: {
          'uid': '17',
          'store_name': '서촌 백년화로',
          'road_address': '서울 종로구 새문안로7길',
          'jibun_address': '서울 종로구 당주동 24-2',
          'latitude': 37.49369555120038,
          'longitude': 127.01370530988898,
          'call': '027305709',
          'category': '고기(구이)',
          'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
          'open': 'close',
          'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
          'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
          'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
          'theme': ['단체석', '친절한', '가성비', '이색적인'],
          'service': ['예약'],
          'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
          'store_image': ['assets/background_image/taroya.jpeg'],
          'kakao_star': 4.3,
          'kakao_cnt': 24,
          'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
          'google_star': 4.3,
          'google_cnt': 24,
          'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
          'naver_star': 4.3,
          'naver_cnt': 24,
          'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
        },
        1: {
          'uid': '128',
          'store_name': '서촌 백년화로',
          'road_address': '서울 종로구 새문안로7길',
          'jibun_address': '서울 종로구 당주동 24-2',
          'latitude': 37.49351987761151,
          'longitude': 126.98649261194777,
          'call': '027305709',
          'category': '고기(구이)',
          'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
          'open': 'breaktime',
          'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
          'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
          'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
          'theme': ['단체석', '친절한', '가성비', '이색적인'],
          'service': ['예약'],
          'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
          'store_image': ['assets/background_image/taroya.jpeg'],
          'kakao_star': 4.3,
          'kakao_cnt': 24,
          'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
          'google_star': 4.3,
          'google_cnt': 24,
          'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
          'naver_star': 4.3,
          'naver_cnt': 24,
          'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
        },
      };

      final Position currentPosition = await Geolocator.getCurrentPosition();

      // map 데이터 변형해서 리스트에 추가
      RawRestaurantData.values.forEach((res) {
        processedRestaurantData.add(
            NaverMapPageRestaurant(
              uid: res['uid'] as String, // 음식점 고유 번호
              store_name: res['store_name'] as String, // 음식점 이름
              jibun_address: res['jibun_address'] as String, // 음식점 주소
              position: LocationClass(latitude: res['latitude'] as double, longitude: res['longitude'] as double),
              call: res['call'] as String, // 음식점 전화번호
              category: res['category'] as String, // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
              main_category: res['main_category'] as String, // 음식점 마커 이미지
              open: res['open'] as String,
              opening_hour: res['opening_hour'] as Map<String, String>, // 음식점 영업 시간
              opening_breaktime: res['opening_breaktime'] as Map<String, String>,
              opening_lastorder: res['opening_lastorder'] as Map<String, String>,
              theme: res['theme'] as List<String>, // 음식점 분위기
              service: res['service'] as List<String>, // 음식점 서비스
              menu: res['menu']  as Map<String, int>, // 음식점 메뉴
              store_image: res['store_image'] as List<String>, // 음식점 외부 이미지
              distance: get_distance(LatLng(res['latitude'] as double, res['longitude'] as double), LatLng(currentPosition.latitude, currentPosition.longitude)), // 음식점의 현 위치와의 거리
              naver_star: res['naver_star'] as double, // 음식점 네이버 평점
              naver_cnt: res['naver_cnt'] as int, // 음식점 네이버 리뷰 개수
              naver_review_url: res['naver_review_url'] as String,
              google_star: res['google_star'] as double, // 음식점 구글 평점
              google_cnt: res['google_cnt'] as int, // 음식점 구글 리뷰 개수
              google_review_url: res['google_review_url'] as String,
              kakao_star: res['kakao_star'] as double, // 음식점 카카오 평점
              kakao_cnt: res['kakao_cnt'] as int, // 음식점 카카오 리뷰 개수
              kakao_review_url: res['kakao_review_url'] as String,
            )
        );
      });

      // restaurants 변수에 백에서 가져온 데이터 restaurants list에 넣기
      restaurants.assignAll(processedRestaurantData);

      restaurants.forEach((NaverMapPageModel restaurant) async {
        CustomMarker customMarker = CustomMarker(
          restaurant: restaurant,
          position: restaurant.position,
        );
        await customMarker.createImage(context);
        customMarker.onMarkerTab = customMarker.setOnMarkerTab((marker, iconSize) async {
          final NaverMapPageModel selectedRestaurant = restaurants.firstWhere((NaverMapPageModel restaurant) => restaurant.uid == marker.markerId);
          final NaverMapController naverMapController = await naverMapCompleter.future;
          await naverMapController.moveCamera(CameraUpdate.scrollTo(marker.position));
          if (_MapPageController.bS == false) {
            _MapPageController.ChangeState();
          }
          showBottomSheet(
            context: context,
            builder: (context) => GestureDetector(
                onTap: () {
                  Get.to(DetailPage(), arguments: selectedRestaurant);
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 3;
                  if (details.delta.dy < -sensitivity) {
                    Get.to(DetailPage(), arguments: selectedRestaurant);
                  }
                  if (details.delta.dy > sensitivity) {
                    _MapPageController.ChangeState();
                    Get.back();
                  }
                },
                child: BottomsheetPage(selectedRestaurant: selectedRestaurant)
            ),
          );
        });
        markers.add(customMarker);
      });
    }
  }
}