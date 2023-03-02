import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/list/list_page.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_abstract_model.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class ListviewPage extends StatefulWidget {

  ListviewPage({Key? key}) : super(key: key);

  @override
  State<ListviewPage> createState() => _ListviewPageState();
}

class _ListviewPageState extends State<ListviewPage> {

  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _ScrollController = ScrollController();

  @override
  void initState() {
    _ScrollController.addListener(_ScrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {});
    List<DetailNaverMapPageRestaurant> restaurantList = _NaverMapPageController.detailRestaurants.value;

    if (listDropdownSelected == '평점순') {
      if (listOpen == true) {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else {
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
      }
      else {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
        else {
          restaurantList.sort((a, b){
            return b.naver_star.compareTo(a.naver_star);
          });
        }
      }
    } else if (listDropdownSelected == '리뷰순') {
      if (listOpen == true) {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else {
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
      }
      else {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
        else {
          restaurantList.sort((a, b){
            return b.naver_cnt.compareTo(a.naver_cnt);
          });
        }
      }
    } else if (listDropdownSelected == '거리순') {
      if (listOpen == true) {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else {
          restaurantList = restaurantList.where((e) => e.open == true).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
      }
      else {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
        else {
          restaurantList.sort((a, b){
            return a.distance.compareTo(b.distance);
          });
        }
      }
    } else {
      if (listOpen == true) {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
          restaurantList = restaurantList.where((e) => e.open == true).toList();
        }
        else {
          restaurantList = restaurantList.where((e) => e.open == true).toList();
        }
      }
      else {
        if (listDropdownSelected2 == '3.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.0).toList();
        }
        else if (listDropdownSelected2 == '3.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 3.5).toList();
        }
        else if (listDropdownSelected2 == '4.0') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.0).toList();
        }
        else if (listDropdownSelected2 == '4.5') {
          restaurantList = restaurantList.where((e) => e.naver_star >= 4.5).toList();
        }
      }
    }

    return Expanded(
      child: RawScrollbar(
        controller: _ScrollController,
        thumbColor: Color(0xfff42957),
        radius: Radius.circular(10),
        thickness: 5,
        child: ListView.separated(
          controller: _ScrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(3),
          itemCount: restaurantList.length,
          itemBuilder: (context, index){

            return ExpandTapWidget(
              onTap: () async {
                uid_Network uid_network = uid_Network(restaurantList[index].uid);
                var uid_store = await uid_network.getJsonData();
                print(uid_store);
                Get.to(() => DetailPage(), arguments: restaurantList[index]);
              },
              tapPadding: EdgeInsets.all(25),
              child: Container(
                  padding: EdgeInsets.only(
                      left: 10, right: 25, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, bottom: 10, top: 15),
                          child: Column(
                            children: [
                              Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        child: Text(
                                          '${restaurantList[index]
                                              .store_name}',
                                          style: TextStyle(
                                              color: Color(0xff464646),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                      if (restaurantList[index].open ==
                                          'open')
                                        Container(
                                          height: 20,
                                          child: Align(
                                            alignment: Alignment
                                                .topCenter,
                                            child: Container(
                                              width: 5,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                  color: Color(
                                                      0xff57dde0),
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        )
                                      else
                                        if (restaurantList[index].open ==
                                            'close')
                                          Container(
                                            height: 20,
                                            child: Align(
                                              alignment: Alignment
                                                  .topCenter,
                                              child: Container(
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                    color: Color(
                                                        0xfff42957),
                                                    shape: BoxShape
                                                        .circle),
                                              ),
                                            ),
                                          )
                                        else
                                          if (restaurantList[index].open ==
                                              'breaktime')
                                            Container(
                                              height: 20,
                                              child: Align(
                                                alignment: Alignment
                                                    .topCenter,
                                                child: Container(
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .yellow,
                                                      shape: BoxShape
                                                          .circle),
                                                ),
                                              ),
                                            )
                                          else
                                            if (restaurantList[index]
                                                .open == 'null')
                                              Container(
                                                height: 20,
                                                child: Align(
                                                  alignment: Alignment
                                                      .topCenter,
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .white,
                                                        shape: BoxShape
                                                            .circle),
                                                  ),
                                                ),
                                              ),
                                      Container(
                                        height: 20,
                                        padding: EdgeInsets.only(
                                            bottom: 1),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end,
                                          children: [
                                            Row(
                                              children: [
                                                for (int i = 0; i <
                                                    restaurantList[index]
                                                        .category
                                                        .length; i++)
                                                  if (i == 0)
                                                    Text(
                                                      '  ${restaurantList[index]
                                                          .category[i]}',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xff838383),
                                                          fontSize: 10),
                                                    )
                                                  else
                                                    Text(
                                                      ',${restaurantList[index]
                                                          .category[i]}',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xff838383),
                                                          fontSize: 10),
                                                    )
                                              ],
                                            ),
                                            SizedBox(height: 1)
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ), // 음식점 이름(높이 20)
                              Container(
                                height: 30,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xfff42957),
                                      size: 14,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      '${restaurantList[index]
                                          .naver_star}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff464646)
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      '(${restaurantList[index]
                                          .naver_cnt}건)',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xff464646)
                                      ),
                                    )
                                  ],
                                ),
                              ), // 별점(높이 30)
                              Container(
                                height: 20,
                                child: Row(
                                  children: [
                                    Text(
                                      '${restaurantList[index]
                                          .jibun_address.split(' ')
                                          .getRange(0, 3)
                                          .join(' ')}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff464646)
                                      ),
                                    )
                                  ],
                                ),
                              ), // 주소(높이 20)
                            ],
                          ),
                        ),
                      ), // 음식점 정보(패딩 포함 높이 100 패딩 미포함 높이 70)
                      Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(restaurantList[index].store_image[0]),
                              fit: BoxFit.fill
                          ),
                        ),
                      ), // 이미지
                    ],
                  )
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 1);
          },
        ),
      ),
    );
  }

  Future<void> _ScrollListener() async {
    // await _NaverMapPageController.processAbstractRestaurantData(context);
    //
    // if (_ScrollController.position.pixels == _ScrollController.position.maxScrollExtent) {
    //   int currentDetailRestaurantsLength = _NaverMapPageController.detailRestaurants.length;
    //
    //   for (int i=currentDetailRestaurantsLength ; i<currentDetailRestaurantsLength+10 ; i++) {
    //     if (i == _NaverMapPageController.abstractRestaurants.length)
    //       break;
    //
    //     uid_Network uid_network = uid_Network(_NaverMapPageController.abstractRestaurants[i].uid);
    //     var uid_store = await uid_network.getJsonData();
    //
    //     final Position currentPosition = await Geolocator.getCurrentPosition();
    //     DetailNaverMapPageRestaurant detailRestaurant = DetailNaverMapPageRestaurant(
    //       uid: uid_store['uid'] as String, // 음식점 고유 번호
    //       store_name: uid_store['store_name'] as String, // 음식점 이름
    //       jibun_address: uid_store['jibun_address'] as String, // 음식점 주소
    //       position: LocationClass(latitude: uid_store['latitude'] as double, longitude: uid_store['longitude'] as double),
    //       call: uid_store['call'] as String, // 음식점 전화번호
    //       category: uid_store['category'] as List<String>, // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
    //       main_category: uid_store['main_category'] as String, // 음식점 마커 이미지
    //       open: uid_store['open'] as String,
    //       opening_hour: uid_store['opening_hour'] as Map<String, String>, // 음식점 영업 시간
    //       opening_breaktime: uid_store['opening_breaktime'] as Map<String, String>,
    //       opening_lastorder: uid_store['opening_lastorder'] as Map<String, String>,
    //       theme: uid_store['theme'] as List<String>, // 음식점 분위기
    //       service: uid_store['service'] as List<String>, // 음식점 서비스
    //       menu: uid_store['menu']  as Map<String, String>, // 음식점 메뉴
    //       store_image: uid_store['store_image'] as List<String>, // 음식점 외부 이미지
    //       distance: get_distance(LatLng(uid_store['latitude'] as double, uid_store['longitude'] as double), LatLng(currentPosition.latitude, currentPosition.longitude)), // 음식점의 현 위치와의 거리
    //       naver_star: uid_store['naver_star'] as double, // 음식점 네이버 평점
    //       naver_cnt: uid_store['naver_cnt'] as int, // 음식점 네이버 리뷰 개수
    //       naver_review_url:uid_store['naver_review_url'] as String,
    //       google_star: uid_store['google_star'] as double, // 음식점 구글 평점
    //       google_cnt: uid_store['google_cnt'] as int, // 음식점 구글 리뷰 개수
    //       google_review_url: uid_store['google_review_url'] as String,
    //       kakao_star: uid_store['kakao_star'] as double, // 음식점 카카오 평점
    //       kakao_cnt: uid_store['kakao_cnt'] as int, // 음식점 카카오 리뷰 개수
    //       kakao_review_url: uid_store['kakao_review_url'] as String,
    //     );
    //
    //     _NaverMapPageController.detailRestaurants.add(detailRestaurant);
    //   }
    // }
  }
}