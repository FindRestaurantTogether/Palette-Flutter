import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/map/bottomsheet/bottomsheet_page.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/map_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:myapp/page/map/navermap/navermap_page_marker.dart';
import 'package:myapp/page/map/navermap/navermap_page_abstract_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
import 'package:myapp/page/map/search/search_page_controller.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapPageController extends GetxService {

  final _MapPageController = Get.put(MapPageController());
  final _FilterPageController = Get.put(FilterPageController());
  final _SearchPageController = Get.put(SearchPageController());

  // 백에서 가져온 데이터 저장 후 이후 다른 페이지에서 이 데이터들 사용
  var abstractRestaurants = <AbstractNaverMapPageRestaurant>[].obs;
  var detailRestaurants = <DetailNaverMapPageRestaurant>[].obs;
  // 위에 데이터들로 CustomMarker 생성후 markers에 저장
  var markers = <CustomMarker>[].obs;

  var rawAbstractRestaurantData = {};

  RxBool getMoreAbstractRestaurantData = false.obs;

  RxBool detailRestaurantDataLoading = false.obs;

  // process 10개씩
  Future<void> processAbstractRestaurantData(context) async {

    final int currentAbstractRestaurantsLength = abstractRestaurants.length;

    for (int i=currentAbstractRestaurantsLength ; i<currentAbstractRestaurantsLength+10; i++) {
      if (i == 30) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('한 번에 볼 수 있는 음식점의 개수는 최대 30개 입니다.'),
              backgroundColor: Color(0xfff42957),
            ));
        break;
      }
      if (i == rawAbstractRestaurantData.length)
        break;

      print(444);
      abstractRestaurants.add(AbstractNaverMapPageRestaurant(
        uid: rawAbstractRestaurantData[i]['uid'] as String, // 움식점 고유 id
        main_category: rawAbstractRestaurantData[i]['main_category'] as String, // 음식점 마커 이미지
        position: LocationClass(latitude: rawAbstractRestaurantData[i]['latitude'] as double, longitude: rawAbstractRestaurantData[i]['longitude'] as double),
      ));
      print(555);
      CustomMarker customMarker = CustomMarker(
        abstractRestaurant: abstractRestaurants[i],
        position: abstractRestaurants[i].position,
      );
      print(666);
      await customMarker.createImage(context);
      print(777);
      customMarker.onMarkerTab = customMarker.setOnMarkerTab((marker, iconSize) async {
        final AbstractNaverMapPageRestaurant selectedAbstractRestaurant = abstractRestaurants.firstWhere((AbstractNaverMapPageRestaurant abstractRestaurant) => abstractRestaurant.uid == marker.markerId);
        final NaverMapController naverMapController = await naverMapCompleter.future;
        await naverMapController.moveCamera(CameraUpdate.scrollTo(marker.position));

        uid_Network uid_network = uid_Network(selectedAbstractRestaurant.uid);
        var uid_store = await uid_network.getJsonData();

        print('==================');
        for (String i in [
          'uid'
          ,'store_name'
          ,'road_address'
          ,'jibun_address'
          ,'latitude'
          ,'longitude'
          ,'call'
          ,'category'
          ,'main_category'
          ,'open'
          ,'opening_hour'
          ,'opening_breaktime'
          ,'opening_lastorder'
          ,'theme'
          ,'service'
          ,'menu'
          ,'store_image'
          ,'kakao_star'
          ,'kakao_cnt'
          ,'kakao_review_url'
          ,'google_star'
          ,'google_cnt'
          ,'google_review_url'
          ,'naver_star'
          ,'naver_cnt'
          ,'naver_review_url'])
          print('${i} : ${uid_store[i]}\n');
        print('==================');

        final Position currentPosition = await Geolocator.getCurrentPosition();
        DetailNaverMapPageRestaurant selectedDetailRestaurant = DetailNaverMapPageRestaurant(
          uid: uid_store['uid'] as String, // 음식점 고유 번호
          store_name: uid_store['store_name'] as String, // 음식점 이름
          jibun_address: uid_store['jibun_address'] as String, // 음식점 주소
          position: LocationClass(latitude: uid_store['latitude'] as double, longitude: uid_store['longitude'] as double),
          call: uid_store['call'] as String, // 음식점 전화번호
          category: uid_store['category'] as List<String>, // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
          main_category: uid_store['main_category'] as String, // 음식점 마커 이미지
          open: uid_store['open'] as String,
          opening_hour: uid_store['opening_hour'] as Map<String, String>, // 음식점 영업 시간
          opening_breaktime: uid_store['opening_breaktime'] as Map<String, String>,
          opening_lastorder: uid_store['opening_lastorder'] as Map<String, String>,
          theme: uid_store['theme'] as List<String>, // 음식점 분위기
          service: uid_store['service'] as List<String>, // 음식점 서비스
          menu: uid_store['menu']  as Map<String, String>, // 음식점 메뉴
          store_image: uid_store['store_image'] as List<String>, // 음식점 외부 이미지
          distance: get_distance(LatLng(uid_store['latitude'] as double, uid_store['longitude'] as double), LatLng(currentPosition.latitude, currentPosition.longitude)), // 음식점의 현 위치와의 거리
          naver_star: uid_store['naver_star'] as double, // 음식점 네이버 평점
          naver_cnt: uid_store['naver_cnt'] as int, // 음식점 네이버 리뷰 개수
          naver_review_url:uid_store['naver_review_url'] as String,
          google_star: uid_store['google_star'] as double, // 음식점 구글 평점
          google_cnt: uid_store['google_cnt'] as int, // 음식점 구글 리뷰 개수
          google_review_url: uid_store['google_review_url'] as String,
          kakao_star: uid_store['kakao_star'] as double, // 음식점 카카오 평점
          kakao_cnt: uid_store['kakao_cnt'] as int, // 음식점 카카오 리뷰 개수
          kakao_review_url: uid_store['kakao_review_url'] as String,
        );

        if (_MapPageController.bottomSheet == false) {
          _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
        }

        showBottomSheet(
          context: context,
          builder: (context) => GestureDetector(
              onTap: () {
                Get.to(DetailPage(), arguments: selectedDetailRestaurant);
              },
              onVerticalDragUpdate: (details) {
                int sensitivity = 3;
                if (details.delta.dy < -sensitivity) {
                  Get.to(DetailPage(), arguments: selectedDetailRestaurant);
                }
                if (details.delta.dy > sensitivity) {
                  _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
                  Get.back();
                }
              },
              child: BottomsheetPage(selectedDetailRestaurant: selectedDetailRestaurant)
          ),
        );
      });
      print(888);
      markers.add(customMarker);
      print(999);
    }
    print(markers.length);
  }

  // fetch 30개 & process 10개
  Future<void> fetchAbstractRestaurantData(context) async {

    abstractRestaurants.value = [];
    markers.value = [];

    if (_FilterPageController.FilterSelected.value.contains(true) || _SearchPageController.searchedWord.value != '') {

      List filter = read_all();
      print(111);
      Network network = Network(filter, _SearchPageController.searchedWord);
      print(222);
      rawAbstractRestaurantData = await network.getJsonData(); // 30개 받기
      print(333);
      print('================================================================');
      // print(rawAbstractRestaurantData.length);
      // for (String i in [
      //     'uid'
      //     ,'store_name'
      //     ,'road_address'
      //     ,'jibun_address'
      //     ,'latitude'
      //     ,'longitude'
      //     ,'call'
      //     ,'category'
      //     ,'main_category'
      //     ,'open'
      //     ,'opening_hour'
      //     ,'opening_breaktime'
      //     ,'opening_lastorder'
      //     ,'theme'
      //     ,'service'
      //     ,'menu'
      //     ,'store_image'
      //     ,'kakao_star'
      //     ,'kakao_cnt'
      //     ,'kakao_review_url'
      //     ,'google_star'
      //     ,'google_cnt'
      //     ,'google_review_url'
      //     ,'naver_star'
      //     ,'naver_cnt'
      //     ,'naver_review_url'])
      //   print('${i} : ${rawRestaurantData[0][i].runtimeType}');
      print('================================================================');

      // rawRestaurantData = {
      //   0: {
      //     'uid': '0',
      //     'store_name': '가',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.5010163512359,
      //     'longitude': 127.0126096636708,
      //     'call': '027305709',
      //     'category': ['고기(구이)', '백반', '새우'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.1,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll',
      //   },
      //   1: {
      //     'uid': '1',
      //     'store_name': '나',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.494670885351994,
      //     'longitude': 126.98624362517117,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.0,
      //     'naver_cnt': 20,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   2: {
      //     'uid': '2',
      //     'store_name': '다',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.49452672424389,
      //     'longitude': 126.98624365161267,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.5,
      //     'naver_cnt': 18,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   3: {
      //     'uid': '3',
      //     'store_name': '라',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.494441091291215,
      //     'longitude': 126.98592703985251,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.2,
      //     'naver_cnt': 32,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   4: {
      //     'uid': '4',
      //     'store_name': '마',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.4942338650689,
      //     'longitude': 126.98597231110577,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 35,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   5: {
      //     'uid': '5',
      //     'store_name': '마',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.494157320578836,
      //     'longitude': 126.98632287593367,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 5.0,
      //     'naver_cnt': 42,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   6: {
      //     'uid': '6',
      //     'store_name': '바',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.493918523324226,
      //     'longitude': 126.98606283444431,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 31,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   7: {
      //     'uid': '7',
      //     'store_name': '사',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.49396360929995,
      //     'longitude': 126.98636814346536,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.0,
      //     'naver_cnt': 124,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   8: {
      //     'uid': '8',
      //     'store_name': '아',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.49374733797839,
      //     'longitude': 126.98611375234069,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 3.8,
      //     'naver_cnt': 70,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   9: {
      //     'uid': '9',
      //     'store_name': '자',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.49381496065548,
      //     'longitude': 126.98652082887946,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 3.6,
      //     'naver_cnt': 4,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   10: {
      //     'uid': '10',
      //     'store_name': '차',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.4936031821557,
      //     'longitude': 126.98615901101985,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   11: {
      //     'uid': '11',
      //     'store_name': '카',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.493522130129236,
      //     'longitude': 126.9864926115421,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   12: {
      //     'uid': '12',
      //     'store_name': '파',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.49331937482503,
      //     'longitude': 126.98624387305289,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   13: {
      //     'uid': '13',
      //     'store_name': '타',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.493269862294426,
      //     'longitude': 126.98661704439216,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   14: {
      //     'uid': '14',
      //     'store_name': '하',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.49316170317845,
      //     'longitude': 126.98628347972871,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   15: {
      //     'uid': '15',
      //     'store_name': '도',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.49302655669353,
      //     'longitude': 126.98632308213053,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   16: {
      //     'uid': '16',
      //     'store_name': '래',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.49295001496749,
      //     'longitude': 126.98670756465381,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   17: {
      //     'uid': '17',
      //     'store_name': '미',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.492841861309685,
      //     'longitude': 126.9864192328119,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   18: {
      //     'uid': '18',
      //     'store_name': '솔',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.49267517822257,
      //     'longitude': 126.98644753263595,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   19: {
      //     'uid': '19',
      //     'store_name': '시',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.492805782869915,
      //     'longitude': 126.9860913109039,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   20: {
      //     'uid': '20',
      //     'store_name': '기',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.49297695144707,
      //     'longitude': 126.98589904481106,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   21: {
      //     'uid': '21',
      //     'store_name': '니',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.49369323037149,
      //     'longitude': 126.9857179819716,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   22: {
      //     'uid': '22',
      //     'store_name': '니',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.493274272974226,
      //     'longitude': 126.98580852533118,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   23: {
      //     'uid': '23',
      //     'store_name': '디',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.494161739611386,
      //     'longitude': 126.98559915789996,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   24: {
      //     'uid': '24',
      //     'store_name': '리',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.49386441691953,
      //     'longitude': 126.98567837124533,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   25: {
      //     'uid': '25',
      //     'store_name': '미',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.493652812563866,
      //     'longitude': 126.98681486614893,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   26: {
      //     'uid': '26',
      //     'store_name': '비',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.49335098462165,
      //     'longitude': 126.98689972890404,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   27: {
      //     'uid': '27',
      //     'store_name': '피',
      //     'road_address': '서울 서초구 새문안로7길',
      //     'jibun_address': '서울 서초구 당주동 24-2',
      //     'latitude': 37.492837404888036,
      //     'longitude': 126.98684893313593,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'close',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   28: {
      //     'uid': '28',
      //     'store_name': '히',
      //     'road_address': '서울 종로구 새문안로7길',
      //     'jibun_address': '서울 종로구 당주동 24-2',
      //     'latitude': 37.494179877503,
      //     'longitude': 126.9865999198887,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      //   29: {
      //     'uid': '29',
      //     'store_name': '누',
      //     'road_address': '서울 동작구 새문안로7길',
      //     'jibun_address': '서울 동작구 당주동 24-2',
      //     'latitude': 37.4940581464032,
      //     'longitude': 126.98578576088047,
      //     'call': '027305709',
      //     'category': ['고기(구이)'],
      //     'main_category': 'assets/marker_image/alcohol_cocktail_5.0.png',
      //     'open': 'breaktime',
      //     'opening_hour': {'월': '11:00-22:00', '화': '11:00-22:00', '수': '11:00-22:00', '목': '11:00-22:00', '금': '11:00-22:00', '토': '17:00-22:00', '일': '정기휴무(매주일요일)'},
      //     'opening_breaktime': {'월': '11:30 - 21:30', '화': '11:30 - 21:30', '수': '11:30 - 21:30', '목': '11:30 - 21:30', '금': '11:30 - 21:30', '토': '11:30 - 21:30', '일': '11:30 - 21:30'},
      //     'opening_lastorder': {'월': '10:00 - 새벽 05:00', '화': '10:00 - 새벽 05:00', '수': '10:00 - 새벽 05:00', '목': '10:00 - 새벽 05:00', '금': '10:00 - 새벽 05:00', '토': '10:00 - 새벽 05:00', '일': '10:00 - 새벽 05:00'},
      //     'theme': ['단체석', '친절한', '가성비', '이색적인'],
      //     'service': ['예약'],
      //     'menu': {'통삼겹살': 16000, '양념소갈비살': 18000, '차돌박이': 18000, '우삼겹': 15000, '통목살': 16000, '양념돼지갈비': 16000, '차돌박이쌈밥정식': 13000},
      //     'store_image': ['assets/background_image/taroya.jpeg'],
      //     'kakao_star': 4.3,
      //     'kakao_cnt': 24,
      //     'kakao_review_url': 'https://place.map.kakao.com/m/11101743#comment',
      //     'google_star': 4.3,
      //     'google_cnt': 24,
      //     'google_review_url': 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko',
      //     'naver_star': 4.3,
      //     'naver_cnt': 24,
      //     'naver_review_url': 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll'
      //   },
      // };

      if (rawAbstractRestaurantData.length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('만족하는 음식점이 없습니다. 필터와 검색 단어를 다시 확인해주세요.'),
              backgroundColor: Color(0xfff42957),
            ));
      }
      else {
        await processAbstractRestaurantData(context);
        getMoreAbstractRestaurantData.value = true;
      }
    }
  }

  Future<void> processDetailRestaurantData() async {
    detailRestaurantDataLoading.value = true;

    final int currentAbstractRestaurantsLength = abstractRestaurants.length;
    final int currentDetailRestaurantsLength = detailRestaurants.length;
    if (currentDetailRestaurantsLength == 0) {
      for (int i=0 ; i<currentAbstractRestaurantsLength; i++) {
        print(i);
        uid_Network uid_network = uid_Network(abstractRestaurants[i].uid);
        var uid_store = await uid_network.getJsonData();

        final Position currentPosition = await Geolocator.getCurrentPosition();
        DetailNaverMapPageRestaurant detailRestaurant = DetailNaverMapPageRestaurant(
          uid: uid_store['uid'] as String, // 음식점 고유 번호
          store_name: uid_store['store_name'] as String, // 음식점 이름
          jibun_address: uid_store['jibun_address'] as String, // 음식점 주소
          position: LocationClass(latitude: uid_store['latitude'] as double, longitude: uid_store['longitude'] as double),
          call: uid_store['call'] as String, // 음식점 전화번호
          category: uid_store['category'] as List<String>, // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
          main_category: uid_store['main_category'] as String, // 음식점 마커 이미지
          open: uid_store['open'] as String,
          opening_hour: uid_store['opening_hour'] as Map<String, String>, // 음식점 영업 시간
          opening_breaktime: uid_store['opening_breaktime'] as Map<String, String>,
          opening_lastorder: uid_store['opening_lastorder'] as Map<String, String>,
          theme: uid_store['theme'] as List<String>, // 음식점 분위기
          service: uid_store['service'] as List<String>, // 음식점 서비스
          menu: uid_store['menu']  as Map<String, String>, // 음식점 메뉴
          store_image: uid_store['store_image'] as List<String>, // 음식점 외부 이미지
          distance: get_distance(LatLng(uid_store['latitude'] as double, uid_store['longitude'] as double), LatLng(currentPosition.latitude, currentPosition.longitude)), // 음식점의 현 위치와의 거리
          naver_star: uid_store['naver_star'] as double, // 음식점 네이버 평점
          naver_cnt: uid_store['naver_cnt'] as int, // 음식점 네이버 리뷰 개수
          naver_review_url:uid_store['naver_review_url'] as String,
          google_star: uid_store['google_star'] as double, // 음식점 구글 평점
          google_cnt: uid_store['google_cnt'] as int, // 음식점 구글 리뷰 개수
          google_review_url: uid_store['google_review_url'] as String,
          kakao_star: uid_store['kakao_star'] as double, // 음식점 카카오 평점
          kakao_cnt: uid_store['kakao_cnt'] as int, // 음식점 카카오 리뷰 개수
          kakao_review_url: uid_store['kakao_review_url'] as String,
        );

        detailRestaurants.add(detailRestaurant);
      }
    }
    else {
      for (int i=currentDetailRestaurantsLength ; i<currentAbstractRestaurantsLength; i++) {
        print(i);
        uid_Network uid_network = uid_Network(abstractRestaurants[i].uid);
        var uid_store = await uid_network.getJsonData();

        final Position currentPosition = await Geolocator.getCurrentPosition();
        DetailNaverMapPageRestaurant detailRestaurant = DetailNaverMapPageRestaurant(
          uid: uid_store['uid'] as String, // 음식점 고유 번호
          store_name: uid_store['store_name'] as String, // 음식점 이름
          jibun_address: uid_store['jibun_address'] as String, // 음식점 주소
          position: LocationClass(latitude: uid_store['latitude'] as double, longitude: uid_store['longitude'] as double),
          call: uid_store['call'] as String, // 음식점 전화번호
          category: uid_store['category'] as List<String>, // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
          main_category: uid_store['main_category'] as String, // 음식점 마커 이미지
          open: uid_store['open'] as String,
          opening_hour: uid_store['opening_hour'] as Map<String, String>, // 음식점 영업 시간
          opening_breaktime: uid_store['opening_breaktime'] as Map<String, String>,
          opening_lastorder: uid_store['opening_lastorder'] as Map<String, String>,
          theme: uid_store['theme'] as List<String>, // 음식점 분위기
          service: uid_store['service'] as List<String>, // 음식점 서비스
          menu: uid_store['menu']  as Map<String, String>, // 음식점 메뉴
          store_image: uid_store['store_image'] as List<String>, // 음식점 외부 이미지
          distance: get_distance(LatLng(uid_store['latitude'] as double, uid_store['longitude'] as double), LatLng(currentPosition.latitude, currentPosition.longitude)), // 음식점의 현 위치와의 거리
          naver_star: uid_store['naver_star'] as double, // 음식점 네이버 평점
          naver_cnt: uid_store['naver_cnt'] as int, // 음식점 네이버 리뷰 개수
          naver_review_url:uid_store['naver_review_url'] as String,
          google_star: uid_store['google_star'] as double, // 음식점 구글 평점
          google_cnt: uid_store['google_cnt'] as int, // 음식점 구글 리뷰 개수
          google_review_url: uid_store['google_review_url'] as String,
          kakao_star: uid_store['kakao_star'] as double, // 음식점 카카오 평점
          kakao_cnt: uid_store['kakao_cnt'] as int, // 음식점 카카오 리뷰 개수
          kakao_review_url: uid_store['kakao_review_url'] as String,
        );

        detailRestaurants.add(detailRestaurant);
      }
    }

    detailRestaurantDataLoading.value = false;
  }
}