import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myapp/page/list/list_page.dart';
import 'package:myapp/page/map/filter/filter_page.dart';
import 'package:myapp/page/map/hotplace/hotplace_page.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
import 'package:myapp/page/map/search/search_page.dart';
import 'package:myapp/page/map/search/search_page_controller.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final _SearchPageController = Get.put(SearchPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ), // 기존 앱바 지우기
      extendBodyBehindAppBar: true, // 기존 앱바 지우기
      body: Obx(() {
        return Stack(
          children: [
            NaverMapPage(), // 네이버 맵
            Column(
              children: [
                SizedBox(height: height * 0.075),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          SizedBox(width: 30),
                          Container(
                            width: width - 115,
                            height: 43,
                            padding: EdgeInsets.only(left: 12, right: 11),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 35,
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      _NaverMapPageController.processDetailRestaurantData();
                                      Get.to(() => ListPage());
                                    },
                                    icon: Image.asset('assets/button_image/list_button.png'),
                                  ),
                                ),
                                Container(
                                  width: width * 0.72 - 91,
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(() => SearchPage());
                                    },
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    ),
                                    child: Text(
                                      _SearchPageController.searchedWord.value == ''
                                          ? '나의 지도'
                                          : _SearchPageController.searchedWord.value,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: _SearchPageController.searchedWord.value == '' ? Color(0xff787878) : Color(0xfff42957), fontSize: 18),
                                    ),
                                  ),
                                ),
                                _SearchPageController.searchedWord.value == ''
                                    ? SizedBox(
                                  width: 33,
                                  child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        Get.to(() => SearchPage());
                                      },
                                      icon: Image.asset('assets/button_image/search_button.png')
                                  ),
                                )
                                    : SizedBox(
                                  width: 31,
                                  child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () async {
                                        _SearchPageController.searchedWord.value = '';
                                        await _NaverMapPageController.fetchAbstractRestaurantData(context);
                                      },
                                      icon: Image.asset('assets/button_image/close_button.png')
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Container(
                          height: 43,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return HotPlacePage();
                                },
                              );
                            },
                            icon: Image.asset('assets/button_image/hot_place_button.png'),
                          ),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ],
                ), // 앱바
                SizedBox(height: 2.5),
                FilterPage() // 필터
              ],
            ),
            if (_NaverMapPageController.markerLoading.value == true)
              Container(
                  color: Colors.black.withOpacity(0.5),
                  width: width,
                  height: height,
                  child: Center(child: CircularProgressIndicator(color: Color(0xfff42957)))
              )
          ],
        );
      })
    );
  }
}
