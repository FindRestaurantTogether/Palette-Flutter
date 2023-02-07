import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/hotplace/hotplace_page_controller.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart' as naver;

class HotPlacePage extends StatefulWidget {

  HotPlacePage({Key? key}) : super(key: key);

  @override
  State<HotPlacePage> createState() => _HotPlacePageState();
}

class _HotPlacePageState extends State<HotPlacePage> {

  final _HotPlacePageController = Get.put(HotPlacePageController());

  List<String> hotPlaceName = [
    '이태원/한남',
    '동대문/혜화',
    '서울역/용산',
    '을지로/종로/\n 광화문',
    '건대/성수',
    '왕십리',
    '강남/신논현',
    '신사/가로수길',
    '선릉/삼성',
    '압구정로데오/\n 청담',
    '잠실',
    '등촌/마곡',
    '목동',
    '사당/이수',
    '서울대입구/\n 신림',
    '여의도/영등포',
    '신촌/홍대',
  ];
  List<double> hotPlaceLatitude = [
    37.5320851,
    37.5763477,
    37.5415225,
    37.5701711,
    37.5422108,
    37.5619913,
    37.5011706,
    37.5212472,
    37.5070476,
    37.5241203,
    37.5134484,
    37.5580485,
    37.5258933,
    37.4812085,
    37.4834383,
    37.5196882,
    37.5570545
  ];
  List<double> hotPlaceLongitude = [
    127.0011958,
    127.0053033,
    126.9700918,
    126.9826873,
    127.0638464,
    127.0385065,
    127.0260717,
    127.0228374,
    127.0564363,
    127.046364,
    127.0997688,
    126.8439202,
    126.8644512,
    126.981785,
    126.9414087,
    126.9169253,
    126.9312741
  ];
  List<double> hotPlaceZoomLevel = [
    13, // 500
    14, // 200
    13, // 500
    13, // 500
    13, // 500
    14, // 200
    14, // 200
    14,// 200
    13, // 500
    13, // 500
    14, // 200
    12, // 1000
    14, // 200
    13, // 500
    12, // 1000
    13, // 500
    13 // 500
  ];

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget hotPlaceFilter (int index) {
      return Container(
        width: 100,
        height: index == 3 || index == 9 || index == 14 ? 40 : 20,
        child: Row(
          children: [
            Material(
              color: Colors.white,
              child: Container(
                width: 30,
                child: Checkbox(
                  value: _HotPlacePageController.hotPlaceIsChecked[index],
                  onChanged: (bool? value) {
                    for (var i=0 ; i<17 ; i++) {
                      if (i != index) {
                        _HotPlacePageController.hotPlaceIsChecked[i] = false;
                      }
                    }
                    _HotPlacePageController.hotPlaceIsChecked[index] = !_HotPlacePageController.hotPlaceIsChecked[index];
                  },
                  shape: CircleBorder(),
                  checkColor: Colors.white,
                  activeColor: Color(0xfff42957),
                ),
              ),
            ),
            Container(
              alignment: index == 3 || index == 9 || index == 14 ? Alignment.bottomCenter : null,
              child: Text(
                ' ${hotPlaceName[index]}',
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async{
        Get.back();
        return false;
      }, // 뒤로가기 버튼
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            return Center(
              child: Container(
                width: width * 0.85,
                height: 581,
                padding: EdgeInsets.only(top: 12, bottom: 25, left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  Get.back();
                                }, // 적용된 필터 백에 전달
                                icon: Image.asset('assets/button_image/close_button.png'),
                              ),
                            ), // 나가기
                          ],
                        ),
                      ),
                    ), // 뒤로가기 버튼
                    Text(
                      '핫플레이스',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black
                      ),
                    ), // 핫 플레이스
                    SizedBox(height: 13),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 75,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '도심권',
                                    style: TextStyle(
                                      color: Color(0xff787878),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 75,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 75,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(0), // 이태원/한남
                                            hotPlaceFilter(1) // 동대문/혜화
                                          ],
                                        ), // 이태원/한남 & 동대문/혜화
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(2), // 서울역/용산
                                            hotPlaceFilter(3) // 을지로/종로/광화문
                                          ],
                                        ),  // 서울역/용산 & 을지로/종로/광화문
                                      ],
                                    ),
                                  ),
                                )
                              ], // 도심권
                            ),
                          ), // 도심권 필터들
                          Divider(height: 1,thickness: 1),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '동북권',
                                    style: TextStyle(
                                        color: Color(0xff787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 35,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(4), // 건대/성수
                                            hotPlaceFilter(5) // 왕십리
                                          ],
                                        ), // 건대/성수 & 왕십리
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ), // 동북권 필터들
                          Divider(height: 1,thickness: 1),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 95,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '동남권',
                                    style: TextStyle(
                                        color: Color(0xff787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 95,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 95,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(6), // 강남/신논현
                                            hotPlaceFilter(7) // 신사/가로수길
                                          ],
                                        ), // 강남/신논현 & 신사/가로수길
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(8), // 선릉/삼성
                                            hotPlaceFilter(9) // 압구정로데오/청담
                                          ],
                                        ),  // 선릉/삼성 & 압구정로데오/청담
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            hotPlaceFilter(10), // 잠실
                                          ],
                                        ),  // 잠실
                                      ],
                                    ),
                                  ),
                                )
                              ], // 도심권
                            ),
                          ), // 동남권 필터들
                          Divider(height: 1,thickness: 1),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 95,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '서남권',
                                    style: TextStyle(
                                        color: Color(0xff787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 95,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 95,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(11), // 등촌/마곡
                                            hotPlaceFilter(12) // 목동
                                          ],
                                        ), // 등촌/마곡 & 목동
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            hotPlaceFilter(13), // 사당/이수
                                            hotPlaceFilter(14) // 서울대입구/신림
                                          ],
                                        ),  // 사당/이수 & 서울대입구/신림
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            hotPlaceFilter(15), // 여의도/영등포
                                          ],
                                        ),  // 여의도/영등포
                                      ],
                                    ),
                                  ),
                                )
                              ], // 도심권
                            ),
                          ), // 서남권 필터들
                          Divider(height: 1,thickness: 1),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '서북권',
                                    style: TextStyle(
                                        color: Color(0xff787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 35,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            hotPlaceFilter(16), // 신촌/홍대
                                          ]//                                          ],
                                        ), // 신촌/홍대
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ), // 서북권 필터들
                        ],
                      ),
                    ), // 핕러들
                    SizedBox(height: 10),
                    Container(
                      width: width * 0.85 - 32,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          int selectedIndex = _HotPlacePageController.hotPlaceIsChecked.indexWhere((e) => e == true);

                          final naverMapController = await naver.naverMapCompleter.future;
                          CameraPosition cameraPosition =  CameraPosition(target: LatLng(hotPlaceLatitude[selectedIndex], hotPlaceLongitude[selectedIndex]), zoom: hotPlaceZoomLevel[selectedIndex]);
                          CameraUpdate cameraUpdate = CameraUpdate.toCameraPosition(cameraPosition);
                          // CameraUpdate cameraUpdate = CameraUpdate.scrollTo(LatLng(hotPlaceLatitude[selectedIndex], hotPlaceLongitude[selectedIndex]));
                          naverMapController.moveCamera(cameraUpdate);
                          Get.back();
                        },
                        child: Text(
                          '이동',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xfff42957),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ) // 확인박스
                  ],
                ),
              ),
            );
          }),
        ],
      )
    );
  }
}
