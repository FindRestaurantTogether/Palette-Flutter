import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/list/list_page.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/page/map/search/recentsearch_model.dart';
import 'package:myapp/page/map/search/search_page_controller.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class SearchPage extends StatefulWidget {

  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final _SearchPageController = Get.put(SearchPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _TextEditingController = TextEditingController(); // 택스트폼 컨트롤러
  
  bool RecentSearch = true; // 최근 검색 focus?

  bool searchByMyLocation = true;

  @override
  void dispose() {
    _TextEditingController.dispose();
    Hive.box('recentsearch').close();
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
                              autofocus: true,
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
                                    final naverMapController = await naverMapCompleter.future;
                                    final currentPosition = await Geolocator.getCurrentPosition();
                                    CameraUpdate cameraUpdate = CameraUpdate.scrollTo(LatLng(currentPosition.latitude, currentPosition.longitude));
                                    naverMapController.moveCamera(cameraUpdate);
                                  }

                                  await _NaverMapPageController.fetchRestaurantData(context, value);

                                  final recentSearchBox = Hive.box<RecentSearchModel>('recentsearch');
                                  recentSearchBox.add(RecentSearchModel(recentSearchWord: _TextEditingController.text));
                                  final recentSearchs = List.from(recentSearchBox.values.toList().cast<RecentSearchModel>().reversed);
                                  if (recentSearchs.length > 10) {
                                    recentSearchs[9].delete();
                                  }

                                  _SearchPageController.searchedWord.value = _TextEditingController.text;

                                  Get.off(ListPage());
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
              ValueListenableBuilder(
                  valueListenable: Hive.box<RecentSearchModel>('recentsearch').listenable(),
                  builder: (context, Box<RecentSearchModel> box, _) {
                    final recentSearchs = List.from(box.values.toList().cast<RecentSearchModel>().reversed);
                    return Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: recentSearchs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final recentSearch = recentSearchs[index];
                          return Expanded(
                            child: Container(
                              height: 50,
                              width: width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _NaverMapPageController.fetchRestaurantData(context, recentSearch.recentSearchWord);
                                  _SearchPageController.searchedWord.value = recentSearch.recentSearchWord;

                                  if (recentSearchs.length > 10) {
                                    recentSearchs[9].delete();
                                  }

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
                                        Text(
                                          recentSearch.recentSearchWord,
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
                                          recentSearch.delete();
                                        },
                                        icon: Icon(Icons.clear,color: Color(0xffa0a0a0),size: 20)
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
                      ),
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}