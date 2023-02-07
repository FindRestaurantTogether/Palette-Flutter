import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/map/bottomsheet/bottomsheet_page.dart';
import 'package:myapp/page/map/dialog/dialog_page.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/map_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_marker.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
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

  // 사용자가 움직여서 카메라가 움직였나 확인하기 위해
  bool cameraChange = false;
  var filter = new List.empty(growable: true);

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!this.mounted) return;
      // restaurants 데이터들로 CustomMarker 생성 후 markers에 저장
      _NaverMapPageController.restaurants.forEach((NaverMapPageModel restaurant) async {
        CustomMarker customMarker = CustomMarker(
          restaurant: restaurant,
          position: restaurant.position,
        );
        customMarker.createImage(context);
        customMarker.onMarkerTab = customMarker.setOnMarkerTab((marker, iconSize) {
          final NaverMapPageModel selectedRestaurant = _NaverMapPageController.restaurants.firstWhere((NaverMapPageModel restaurant) => restaurant.uid == marker.markerId);
          setState(() async {
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
        });
        _NaverMapPageController.markers.add(customMarker);
      });
    });
    super.initState();
  }

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
        if (_MapPageController.bS == true) {
          _MapPageController.ChangeState();
          Get.back();
        } // 안드리이드 백 버튼 누르면 바텀시트 state 변경
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            NaverMap(
              onMapCreated: onMapCreated,
              mapType: MapType.Basic,
              initialCameraPosition: CameraPosition(target: LatLng(37.49369555120038, 127.01370530988898)),
              onCameraChange: _onCameraChange,
              // onCameraIdle: _onCameraIdle,
              markers: _NaverMapPageController.markers,
              onMapTap: _onMapTap,
            ),
            GetBuilder<MapPageController>(
                builder: (_MapPageController) {
                  return Positioned(
                    right: 20,
                    bottom: _MapPageController.bS ? 230 : 30,
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
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                  isDismissible: true,
                                  barrierColor: Colors.black54,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogPage();
                                  }
                              );
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
                              final Position position = await Geolocator.getCurrentPosition();
                              CameraUpdate cameraUpdate = CameraUpdate.scrollTo(LatLng(position.latitude, position.longitude));
                              naverMapController.moveCamera(cameraUpdate);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ), // 우측 아래 동그라미 버튼 두개
            if (cameraChange == true && _FilterPageController.FilterSelected.contains(true))
              Positioned(
                left: width * 0.5 - 95,
                bottom: 68,
                child: Container(
                    width: 190,
                    height: 36,
                    child: ElevatedButton(
                        onPressed: () async {
                          print("========================================");
                          filter = read_all();
                          Network network = Network(filter, '');
                          var store = await network.getJsonData();
                          print(store);
                          print("========================================");
                          print(store.length);
                          print(store['1']['call']);
                          print("========================================");
                        }, // 이 지도에서 재검색 버튼
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.grey.withOpacity(0.8)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: Colors.white),
                            Text(
                              '  이 지도에서 재검색',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                          ],
                        )
                    )
                ),
              ) // 이 지도에서 재검색
          ],
        ),
      ),
    );
  }

  Future<void> onMapCreated(NaverMapController naverMapController) async {
    if (naverMapCompleter.isCompleted) naverMapCompleter = Completer();
    naverMapCompleter.complete(naverMapController);

    // 위치정보 허락 받고 허락 받으면 맵 생성시 현 위치로 위치 옮겨주기
    LocationService locationService = LocationService();
    if (await locationService.canGetCurrentLocation()){
      final Position position = await Geolocator.getCurrentPosition();
      naverMapController.moveCamera(CameraUpdate.scrollTo(LatLng(position.latitude, position.longitude)));
    }

    LatLngBounds bound = await naverMapController.getVisibleRegion();
    setState(() {
      rightUpPosition = bound.northeast;
      leftDownPosition = bound.southwest;
    });
  }
  Future<void> _onCameraChange(LatLng latLng, CameraChangeReason reason, bool isAnimated) async {
    // print('카메라 움직임 >>> 위치 : ${latLng.latitude}, ${latLng.longitude}'
    //     '\n원인: $reason'
    //     '\n에니메이션 여부: $isAnimated'
    // );

    if (cameraChange == false)
      setState(() {cameraChange = true;});

    NaverMapController naverMapController = await naverMapCompleter.future;
    LatLngBounds bound = await naverMapController.getVisibleRegion();
    setState(() {
      rightUpPosition = bound.northeast;
      leftDownPosition = bound.southwest;
    });
    // print("========================================");
    // print('중심: ${position.target}');
    // print('북동쪽: ${bound.northeast}');
    // print('남서쪽: ${bound.southwest}');
  }
  // void _onCameraIdle() {
  //   // print('카메라 움직임 멈춤');
  // }
  void _onMapTap(LatLng latLng) {

    // 바텀시트 상태 변경
    if (_MapPageController.bS == false) {
      var currentIndex = _FilterPageController.CurrentOuterIndex.toInt();
      setState(() {
        _FilterPageController.ChangeOuterSelected(currentIndex, false);
        _FilterPageController.ChangeCurrentOuterIndex(5);
      });
    }
    if (_MapPageController.bS == true) {
      setState(() {
        _MapPageController.ChangeState();
        Get.back();
      });
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

