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

  var rawAbstractRestaurantData = {};

  RxBool fetchingRawAbstractRestaurant = false.obs;
  RxBool processingRawAbstractRestaurant = false.obs;

  var abstractRestaurants = <AbstractNaverMapPageRestaurant>[].obs;
  var loadingMarkers = <CustomMarker>[];
  var markers = <CustomMarker>[].obs;

  RxBool processingAbstractRestaurant = false.obs;

  var detailRestaurants = <DetailNaverMapPageRestaurant>[].obs;
  var selectedDetailRestaurant = DetailNaverMapPageRestaurant(
      uid: '',
      main_category: '',
      store_image: [],
      store_name: '',
      open: '',
      opening_hour: {},
      opening_breaktime: {},
      category: [],
      distance: 0,
      theme: [],
      naver_star: 0,
      naver_cnt: 0,
      naver_review_url: '',
      google_star: 0,
      google_cnt: 0,
      google_review_url: '',
      kakao_star: 0,
      kakao_cnt: 0,
      kakao_review_url: '',
      service: [],
      jibun_address: '',
      call: '',
      position: LocationClass(longitude: 0.0, latitude: 0.0),
      menu: {}

  ).obs;

  RxBool getMoreAbstractRestaurantData = false.obs; // 음식점 더 보기

  // process raw abstract 전부 (검색 -> 리스트)
  Future<void> processRawAbstractRestaurantDataBySearch() async {
    if (rawAbstractRestaurantData.length != 0) {
      processingRawAbstractRestaurant.value = true;
      detailRestaurants.value = [];

      for (int i=0 ; i<rawAbstractRestaurantData.length; i++) {
        uid_Network uid_network = await uid_Network(rawAbstractRestaurantData[i]['uid']);
        var uid_store = await uid_network.getJsonData();

        final Position currentPosition = await Geolocator.getCurrentPosition();
        DetailNaverMapPageRestaurant detailRestaurant = await DetailNaverMapPageRestaurant(
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

        print('detailRestaurants.length: ${detailRestaurants.length}개');
      }

      print('================================================================');
      print('검색으로 인한 총 detail 데이터 수: ${detailRestaurants.length}개');
      print('================================================================');

      processingRawAbstractRestaurant.value = false;
    }
  }

  // process abstract 전부 (마커 -> 리스트)
  Future<void> processAbstractRestaurantData() async {

    processingAbstractRestaurant.value = true;

    detailRestaurants.value = [];

    for (int i=0 ; i<abstractRestaurants.length; i++) {
      uid_Network uid_network = await uid_Network(abstractRestaurants[i].uid);
      var uid_store = await uid_network.getJsonData();

      final Position currentPosition = await Geolocator.getCurrentPosition();
      DetailNaverMapPageRestaurant detailRestaurant = await DetailNaverMapPageRestaurant(
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

      print('detailRestaurants.length: ${detailRestaurants.length}개');
    }

    print('================================================================');
    print('필터로 인한 총 detail 데이터 수: ${detailRestaurants.length}개');
    print('================================================================');

    processingAbstractRestaurant.value = false;
  }

  // process raw abstract 10개씩 (필터 -> 마커)
  Future<void> processRawAbstractRestaurantDataByFilter(context) async {
    if (rawAbstractRestaurantData.length != 0) {
      processingRawAbstractRestaurant.value = true;
      loadingMarkers = <CustomMarker>[];

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

        abstractRestaurants.add(AbstractNaverMapPageRestaurant(
          uid: rawAbstractRestaurantData[i]['uid'] as String, // 움식점 고유 id
          main_category: rawAbstractRestaurantData[i]['main_category'] as String, // 음식점 마커 이미지
          position: LocationClass(latitude: rawAbstractRestaurantData[i]['latitude'] as double, longitude: rawAbstractRestaurantData[i]['longitude'] as double),
        ));
        CustomMarker customMarker = CustomMarker(
          abstractRestaurant: abstractRestaurants[i],
          position: abstractRestaurants[i].position,
        );
        await customMarker.createImage(context);
        customMarker.onMarkerTab = customMarker.setOnMarkerTab((marker, iconSize) async {
          final AbstractNaverMapPageRestaurant selectedAbstractRestaurant = abstractRestaurants.firstWhere((AbstractNaverMapPageRestaurant abstractRestaurant) => abstractRestaurant.uid == marker.markerId);
          final NaverMapController naverMapController = await naverMapCompleter.future;
          await naverMapController.moveCamera(CameraUpdate.scrollTo(marker.position));

          selectedDetailRestaurant.value = DetailNaverMapPageRestaurant(
              uid: '',
              main_category: '',
              store_image: [],
              store_name: '',
              open: '',
              opening_hour: {},
              opening_breaktime: {},
              category: [],
              distance: 0,
              theme: [],
              naver_star: 0,
              naver_cnt: 0,
              naver_review_url: '',
              google_star: 0,
              google_cnt: 0,
              google_review_url: '',
              kakao_star: 0,
              kakao_cnt: 0,
              kakao_review_url: '',
              service: [],
              jibun_address: '',
              call: '',
              position: LocationClass(longitude: 0.0, latitude: 0.0),
              menu: {}

          );

          if (_MapPageController.bottomSheet == false) {
            _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
          }

          showBottomSheet(
              context: context,
              builder: (context) => GestureDetector(
                  onTap: () {
                    Get.to(DetailPage());
                  },
                  onVerticalDragUpdate: (details) {
                    int sensitivity = 3;
                    if (details.delta.dy < -sensitivity) {
                      Get.to(DetailPage());
                    }
                    if (details.delta.dy > sensitivity) {
                      _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
                      Get.back();
                    }
                  },
                  child: BottomsheetPage()
              )
          );

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
          print('theme: ${uid_store['theme'].length}');
          print('service: ${uid_store['service'].length}');
          print('==================');

          final Position currentPosition = await Geolocator.getCurrentPosition();
          selectedDetailRestaurant.value = DetailNaverMapPageRestaurant(
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

        });
        loadingMarkers.add(customMarker);
      }
      print('================================================================');
      print('필터로 인한 총 abstract 데이터 수: ${abstractRestaurants.length}');
      print('필터로 인한 총 marker 수: ${loadingMarkers.length}');
      print('================================================================');

      markers.addAll(loadingMarkers);
      processingRawAbstractRestaurant.value = false;
    }
  }

  // fetch raw abstract 30개
  Future<void> fetchRawAbstractRestaurantData(context) async {

    fetchingRawAbstractRestaurant.value = true;

    abstractRestaurants.value = [];
    markers.value = [];

    if (_FilterPageController.FilterSelected.value.contains(true) || _SearchPageController.searchedWord.value != '') {

      List filter = read_all();
      Network network = Network(filter, _SearchPageController.searchedWord);
      rawAbstractRestaurantData = await network.getJsonData(); // 30개 받기
      print('================================================================');
      for (int i=0 ; i<rawAbstractRestaurantData.length ; i++)
        print(rawAbstractRestaurantData[i]);
      print('총 raw 데이터: ${rawAbstractRestaurantData.length}개');
      print('================================================================');
    }

    if (rawAbstractRestaurantData.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('만족하는 음식점이 없습니다. 필터와 검색 단어를 다시 확인해주세요.'),
        backgroundColor: Color(0xfff42957),
      ));
    }

    fetchingRawAbstractRestaurant.value = false;
  }

}