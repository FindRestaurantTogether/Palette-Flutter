import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/page/list/list_page.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

String searchedWord = '';

class SearchPage extends StatefulWidget {

  List _items;
  SearchPage(this._items);

  @override
  State<SearchPage> createState() => _SearchPageState(_items);
}

class _SearchPageState extends State<SearchPage> {

  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _TextEditingController = TextEditingController(); // 택스트폼 컨트롤러
  
  bool RecentSearch = true; // 최근 검색 focus?

  List _items;
  _SearchPageState(this._items);

  bool searchByMyLocation = true;

  @override
  void dispose() {
    _TextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ), // 앱바 없애기
        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: height * 0.075), // 공간 조금 만드는 박스
              Container(
                  width: width,
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                Get.back();
                              },
                              icon: Image.asset('assets/button_image/back_button.png', width: 10, height: 16, fit: BoxFit.fill),
                            ),
                          ), // 뒤로가기 버튼
                          SizedBox(width: 6),
                          Container(
                            width: width * 0.87 - 120,
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              onFieldSubmitted: (value) async {
                                if (value.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('검색어를 입력해주세요.'),
                                        backgroundColor: Color(0xfff42957),
                                      )
                                  );
                                } else {
                                  if (searchByMyLocation == true) {
                                    print(1);
                                    final naverMapController = await naverMapCompleter.future;
                                    print(2);
                                    final currentPosition = await Geolocator.getCurrentPosition();
                                    print(3);
                                    CameraUpdate cameraUpdate = CameraUpdate.scrollTo(LatLng(currentPosition.latitude, currentPosition.longitude));
                                    print(4);
                                    naverMapController.moveCamera(cameraUpdate);
                                  }
                                  print(11);
                                  await _NaverMapPageController.fetchRestaurantData(context, value);
                                  print(22);
                                  setState(() {
                                    searchedWord = _TextEditingController.text;
                                    if (_items.length >= 10) {
                                      _items.removeAt(0);
                                    }
                                    _items.add(value);
                                  });
                                  await Get.off(ListPage());
                                }
                              },
                              controller: _TextEditingController,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '장소, 주소, 음식 검색',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xffb9b9b9),
                                ),
                              ),
                            ),
                          ), // 검색창
                        ],
                      ),
                      Container(
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            _TextEditingController.clear();
                          },
                          icon: Image.asset(
                              'assets/button_image/close_button.png',
                              width: 13,
                              height: 14,
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                    ],
                  )
              ), // 검색창
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ExpandTapWidget(
                    onTap: () {
                      setState(() {
                        searchByMyLocation = true;
                      });
                    },
                    tapPadding: EdgeInsets.all(50),
                    child: Container(
                      width: width * 0.5,
                      padding: EdgeInsets.all(10),
                      decoration: searchByMyLocation? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                      child: Center(
                        child: Text(
                          '내 위치 중심',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: searchByMyLocation ? FontWeight.bold : null,
                            color: searchByMyLocation ? Color(0xfff42957) : Color(0xffa0a0a0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ExpandTapWidget(
                    onTap: () {
                      setState(() {
                        searchByMyLocation = false;
                      });
                    },
                    tapPadding: EdgeInsets.all(50),
                    child: Container(
                      width: width * 0.5,
                      padding: EdgeInsets.all(10),
                      decoration: !searchByMyLocation? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                      child: Center(
                        child: Text(
                          "지도 중심",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: !searchByMyLocation ? FontWeight.bold : null,
                            color: !searchByMyLocation ? Color(0xfff42957) : Color(0xffa0a0a0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // 내 위치 중심 / 지도 중심
              Expanded(
                child: ListView (
                  padding: EdgeInsets.zero,
                  children: [
                    for(int i=_items.length-1; i>=0; i--) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              width: width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _NaverMapPageController.fetchRestaurantData(context, _items[i]);
                                  setState(() {
                                    searchedWord = _items[i];
                                    if (_items.length >= 10) {
                                      _items.removeAt(0);
                                    }
                                    _items.add(_items[i]);
                                  });
                                  Get.off(ListPage());
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(left: 30,right: 20),
                                    elevation: 0,
                                    primary: Colors.white
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          child: Icon(Icons.search,color: Color(0xffa0a0a0), size: 20),
                                          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black12),
                                        ),
                                        SizedBox(width: 16),
                                        Text('${_items[i]}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffa0a0a0)
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _items.removeAt(i);
                                          });
                                        },
                                        icon: Icon(Icons.clear,color: Color(0xffa0a0a0),size: 20))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}