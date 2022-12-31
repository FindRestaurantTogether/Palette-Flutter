// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:myapp/page/detail/detail_page.dart';
// import 'package:myapp/page/map/bottomsheet/bottomsheet_page.dart';
// import 'package:myapp/page/map/filter/filter_page_controller.dart';
// import 'package:myapp/page/map/map_page_controller.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class KakaoMapPage extends StatefulWidget {
//   KakaoMapPage({Key? key}) : super(key: key);
//
//   @override
//   State<KakaoMapPage> createState() => _KakaoMapPageState();
// }
//
// class _KakaoMapPageState extends State<KakaoMapPage> {
//   String url = "https://kakaomapflutter.neocities.org";
//   late WebViewController _webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }
//
//   void getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     Position position =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     await _webViewController.runJavascript(
//       '''
//       var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png', // 마커이미지의 주소입니다
//           imageSize = new kakao.maps.Size(64, 69), // 마커이미지의 크기입니다
//           imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
//
//       // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
//       var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
//           markerPosition = new kakao.maps.LatLng(${position.latitude}, ${position.longitude}); // 마커가 표시될 위치입니다
//
//       // 마커를 생성합니다
//       var marker = new kakao.maps.Marker({
//           position: markerPosition,
//           image: markerImage // 마커이미지 설정
//       });
//
//       // 마커가 지도 위에 표시되도록 설정합니다
//       marker.setMap(map);
//
//       // 지도 중심좌표를 접속위치로 변경합니다
//       map.panTo(markerPosition);
//
//       '''
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final _MapPageController = Get.put(MapPageController());
//     final _FilterPageController = Get.put(FilterPageController());
//     double ratio = 1.8;
//
//     return WillPopScope(
//       onWillPop: () async {
//         _MapPageController.ChangeState();
//         Get.back();
//         return false;
//       },
//       child: Stack(
//         children: [
//           Transform.scale(
//             scale: ratio,
//             child: WebView(
//               initialUrl: url,
//               javascriptMode: JavascriptMode.unrestricted,
//               onWebViewCreated: (WebViewController webViewController) {
//                 _webViewController = webViewController;
//                 _webViewController.clearCache();
//               },
//               javascriptChannels: Set.from([
//                 JavascriptChannel(
//                     name: 'JavaScriptChannel',
//                     onMessageReceived: (JavascriptMessage message) {
//                       if (message.message == 'map is clicked' &&
//                           _MapPageController.bS == false) {
//                         setState(() {
//                           _FilterPageController.ChangeCurrentOuterIndex(5);
//                         });
//                       }
//                       if (message.message == 'map is clicked' &&
//                           _MapPageController.bS == true) {
//                         setState(() {
//                           _MapPageController.ChangeState();
//                         });
//                         Get.back();
//                       }
//                       if (message.message == 'marker is clicked' &&
//                           _MapPageController.bS == false) {
//                         setState(() {
//                           _MapPageController.ChangeState();
//                         });
//                         showBottomSheet(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           context: context,
//                           builder: (context) => GestureDetector(
//                             onTap: () {
//                               Get.to(DetailPage());
//                             },
//                             onVerticalDragUpdate: (details) {
//                               int sensitivity = 3;
//                               if (details.delta.dy < -sensitivity) {
//                                 Get.to(DetailPage());
//                               }
//                               if (details.delta.dy > sensitivity) {
//                                 setState(() {
//                                   _MapPageController.ChangeState();
//                                 });
//                                 Get.back();
//                               }
//                             },
//                             child: BottomsheetPage()
//                           ),
//                         );
//                       }
//                     })
//               ]),
//             ),
//           ),
//           GetBuilder<MapPageController>(
//             builder: (_) {
//               return Positioned(
//                 right: 10,
//                 bottom: _MapPageController.bS ? 240 : 20,
//                 child: Column(
//                   children: [
//                     GoToAppointmentMapButton(),
//                     SizedBox(height: 20),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       child: FloatingActionButton(
//                         heroTag: null,
//                         child: Icon(
//                           Icons.gps_fixed,
//                           color: Colors.grey,
//                         ),
//                         backgroundColor: Colors.white,
//                         onPressed: () {
//                           getCurrentLocation();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget GoToAppointmentMapButton() => PopupMenuButton<int>(
//     offset: Offset(-60, -30),
//     shape: StadiumBorder(),
//     itemBuilder: (context) => [
//       PopupMenuItem(
//         value: 1,
//         child: Center(child: Text("9월 23일 대면회의",style: TextStyle(color: Colors.black54))),
//       ),
//       PopupMenuItem(
//         value: 2,
//         child: Center(child: Text("9월 30일 대면회의",style: TextStyle(color: Colors.black54))),
//       ),
//     ],
//     child: Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//           color: Colors.black87,
//           shape: BoxShape.circle
//       ),
//       child: Icon(
//         Icons.person_search,
//         color: Colors.white,
//       ),
//     ),
//   );
// }
