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
import 'package:naver_map_plugin/naver_map_plugin.dart';

class NaverMapPage extends StatefulWidget {

  @override
  _NaverMapPageState createState() => _NaverMapPageState();
}

class _NaverMapPageState extends State<NaverMapPage> {

  Completer<NaverMapController> _controller = Completer();

  final _MapPageController = Get.put(MapPageController());
  final _FilterPageController = Get.put(FilterPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController()); // 데이터 생성 완료(리스트에 추가되면서)

  @override
  void initState() {
    // sleep(Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!this.mounted) return;
      _NaverMapPageController.restaurants.forEach((NaverMapPageModel restaurant) async {
        CustomMarker customMarker = CustomMarker(
            restaurant: restaurant,
            position: restaurant.position,
        );
        customMarker.createImage(context);
        customMarker.onMarkerTab = customMarker.setOnMarkerTab((marker, iconSize) {
          final NaverMapPageModel _selectedRestaurant = _NaverMapPageController.restaurants.firstWhere((NaverMapPageModel restaurant) => restaurant.uid == marker.markerId);
          setState(() async {
            final controller = await _controller.future;
            await controller.moveCamera(CameraUpdate.scrollTo(marker.position));
            if (_MapPageController.bS == false) {
              _MapPageController.ChangeState();
            }
            showBottomSheet(
              context: context,
              builder: (context) => GestureDetector(
                  onTap: () {
                    Get.to(DetailPage(), arguments: _selectedRestaurant);
                  },
                  onVerticalDragUpdate: (details) {
                    int sensitivity = 3;
                    if (details.delta.dy < -sensitivity) {
                      Get.to(DetailPage(), arguments: _selectedRestaurant);
                    }
                    if (details.delta.dy > sensitivity) {
                      _MapPageController.ChangeState();
                      Get.back();
                    }
                  },
                  child: BottomsheetPage(selectedRestaurant: _selectedRestaurant)
              ),
            );
          });
        });
        _NaverMapPageController.markers.add(customMarker);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _MapPageController.dispose();
    _FilterPageController.dispose();
    _NaverMapPageController.dispose();
    super.dispose();
  }

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
              // initialCameraPosition: CameraPosition(target: LatLng(position.latitude, position.longitude)),
              onCameraChange: _onCameraChange,
              onCameraIdle: _onCameraIdle,
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
                          child: Icon(
                            Icons.people_alt_outlined,
                            color: Color(0xfff42957),
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
                          child: Icon(
                            Icons.gps_fixed,
                            color: Color(0xfff42957),
                          ),
                          backgroundColor: Colors.white,
                          onPressed: () async {
                            final controller = await _controller.future;
                            final Position position = await Geolocator.getCurrentPosition();
                            CameraUpdate cameraUpdate = CameraUpdate.scrollTo(LatLng(position.latitude, position.longitude));
                            controller.moveCamera(cameraUpdate);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            ), // 우측 아래 동그라미 버튼 두개
            Positioned(
              left: width * 0.5 - 95,
              bottom: 68,
              child: Container(
                    width: 190,
                    height: 36,
                    child: ElevatedButton(
                        onPressed: (){},
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

  Future<void> onMapCreated(NaverMapController controller) async {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);

    // 위치정보 허락 받고 허락 받으면 맵 생성시 현 위치로 위치 옮겨주기
    LocationService locationService = LocationService();
    if (await locationService.canGetCurrentLocation()){
      final Position position = await Geolocator.getCurrentPosition();
      controller.moveCamera(CameraUpdate.scrollTo(LatLng(position.latitude, position.longitude)));
    }


  }
  Future<void> _onCameraChange(LatLng latLng, CameraChangeReason reason, bool isAnimated) async {
    print('카메라 움직임 >>> 위치 : ${latLng.latitude}, ${latLng.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated'
    );

    NaverMapController Controller = await _controller.future;
    LatLngBounds bound = await Controller.getVisibleRegion();
    CameraPosition position = await Controller.getCameraPosition();
    print("========================================");
    print('중심: ${position.target}');
    print('북동쪽: ${bound.northeast}');
    print('남서쪽: ${bound.southwest}');
  }
  void _onCameraIdle() {
    print('카메라 움직임 멈춤');
  }
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


