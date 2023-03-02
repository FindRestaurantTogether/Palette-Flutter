import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/map_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/search/search_page_controller.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

// 중심 좌표
late LatLng centerPosition;
// 우측 위 좌표
late LatLng rightUpPosition;
// 좌측 밑 좌표
late LatLng leftDownPosition;

Completer<NaverMapController> naverMapCompleter = Completer();

class NaverMapPage extends StatefulWidget {

  @override
  _NaverMapPageState createState() => _NaverMapPageState();
}

class _NaverMapPageState extends State<NaverMapPage> {

  final _MapPageController = Get.put(MapPageController());
  final _FilterPageController = Get.put(FilterPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _SearchPageController = Get.put(SearchPageController());

  var filter = new List.empty(growable: true);

  // @override
  // void dispose() {
  //   _MapPageController.dispose();
  //   _FilterPageController.dispose();
  //   _NaverMapPageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (_MapPageController.bottomSheet.value == true) {
          _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
          Get.back();
        } // 안드리이드 백 버튼 누르면 바텀시트 state 변경
        return false;
      },
      child: Scaffold(
        body: Obx(() {
          return Stack(
            children: [
              NaverMap(
                onMapCreated: onMapCreated,
                mapType: MapType.Basic,
                initialCameraPosition: CameraPosition(target: LatLng(37.49369555120038, 127.01370530988898)),
                onCameraChange: _onCameraChange,
                onCameraIdle: _onCameraIdle,
                markers: _NaverMapPageController.markers.value,
                onMapTap: _onMapTap,
              ),
              Positioned(
                right: 20,
                bottom: _MapPageController.bottomSheet.value ? 230 : 30,
                child: Column(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        heroTag: null,
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child: Image.asset('assets/button_image/current_page_button.png')
                        ),
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final naverMapController = await naverMapCompleter.future;
                          naverMapController.moveCamera(CameraUpdate.zoomOut());
                          // showMaterialModalBottomSheet(
                          //     isDismissible: true,
                          //     barrierColor: Colors.black54,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.vertical(
                          //         top: Radius.circular(30),
                          //       ),
                          //     ),
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return DialogPage();
                          //     }
                          // );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        heroTag: null,
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child: Image.asset('assets/button_image/current_position_button.png')
                        ),
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final naverMapController = await naverMapCompleter.future;
                          final Position currentPosition = await Geolocator.getCurrentPosition();
                          CameraUpdate cameraUpdate = CameraUpdate.scrollTo(LatLng(currentPosition.latitude, currentPosition.longitude));
                          naverMapController.moveCamera(cameraUpdate);
                        },
                      ),
                    ),
                  ],
                ),
              ), // 우측 아래 동그라미 버튼 두개
              if (_SearchPageController.searchedWord.value != '' || _FilterPageController.FilterSelected.contains(true))
                Positioned(
                  left: width * 0.5 - 95,
                  bottom: 68,
                  child: Container(
                      width: 190,
                      height: 36,
                      child: ElevatedButton(
                          onPressed: () async {
                            _NaverMapPageController.getMoreAbstractRestaurantData.value
                                ? await _NaverMapPageController.processAbstractRestaurantData(context)
                                : await _NaverMapPageController.fetchAbstractRestaurantData(context);
                          }, // 이 지도에서 재검색 버튼
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.grey.withOpacity(0.8)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_NaverMapPageController.getMoreAbstractRestaurantData.value == false)
                                Icon(Icons.refresh, color: Colors.white),
                              Text(
                                _NaverMapPageController.getMoreAbstractRestaurantData.value
                                    ? '음식점 결과 더보기'
                                    : '  이 지도에서 재검색',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                            ],
                          )
                      )
                  ),
                )// 이 지도에서 재검색
            ],
          );
        })
      ),
    );
  }

  Future<void> onMapCreated(NaverMapController naverMapController) async {
    if (naverMapCompleter.isCompleted) naverMapCompleter = Completer();
    naverMapCompleter.complete(naverMapController);

    // 위치정보 허락 받고 허락 받으면 맵 생성시 현 위치로 위치 옮겨주기
    LocationService locationService = LocationService();
    if (await locationService.canGetCurrentLocation()){
      final Position currentPosition = await Geolocator.getCurrentPosition();
      naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(currentPosition.latitude, currentPosition.longitude)));
    }

    LatLngBounds bound = await naverMapController.getVisibleRegion();
    CameraPosition position = await naverMapController.getCameraPosition();
    setState(() {
      centerPosition = position.target;
      rightUpPosition = bound.northeast;
      leftDownPosition = bound.southwest;
    });
  }
  Future<void> _onCameraChange(LatLng latLng, CameraChangeReason reason, bool isAnimated) async {
    // print('카메라 움직임 >>> 위치 : ${latLng.latitude}, ${latLng.longitude}'
    //     '\n원인: $reason'
    //     '\n에니메이션 여부: $isAnimated'
    // );
    if (_NaverMapPageController.getMoreAbstractRestaurantData.value == true)
      _NaverMapPageController.getMoreAbstractRestaurantData.value = false;

  }
  Future<void> _onCameraIdle() async {
    NaverMapController naverMapController = await naverMapCompleter.future;
    LatLngBounds bound = await naverMapController.getVisibleRegion();
    CameraPosition position = await naverMapController.getCameraPosition();
    setState(() {
      centerPosition = position.target;
      rightUpPosition = bound.northeast;
      leftDownPosition = bound.southwest;
    });

    print("========================================");
    print('중심: ${centerPosition}');
    print('북동쪽: ${rightUpPosition}');
    print('남서쪽: ${leftDownPosition}');
    print("========================================");


  }
  void _onMapTap(LatLng latLng) {
    // 바텀시트 상태 변경
    if (_MapPageController.bottomSheet.value == false) {
      var currentIndex = _FilterPageController.CurrentOuterIndex.toInt();
      _FilterPageController.ChangeOuterSelected(currentIndex, false);
      _FilterPageController.ChangeCurrentOuterIndex(5);
    }
    if (_MapPageController.bottomSheet.value == true) {
      _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
      Get.back();
    }
  }
}


class LocationClass extends LatLng {
  final double latitude;
  final double longitude;

  const LocationClass({required this.latitude, required this.longitude}) : super(latitude, longitude);
}
class LocationService {
  Future<LocationPermission> hasLocationPermission() async => await Geolocator.checkPermission();
  Future<bool> isLocationEnabled() async => await Geolocator.isLocationServiceEnabled();
  Future<LocationPermission> requestLocation() async => await Geolocator.requestPermission();

  Future<bool> canGetCurrentLocation() async {
    final LocationPermission _permission = await this.hasLocationPermission();
    if (_permission == LocationPermission.always || _permission == LocationPermission.whileInUse) {
      final bool _enabled = await this.isLocationEnabled();
      if (_enabled) return true;
    }
    return false;
  }
}

