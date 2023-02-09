import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/page/list/list_page.dart';
import 'package:myapp/page/map/filter/filter_page.dart';
import 'package:myapp/page/map/hotplace/hotplace_page.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/search/search_page.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  List _items = [];

  Future<void> getData() async {
    final String jsonString = await rootBundle.loadString('assets/search_data/recent_data.json');
    final jsonResponse = await json.decode(jsonString);
    setState(() {
      _items = jsonResponse["data"];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

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
      body: Stack(
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
                      SizedBox(width: width * 0.065),
                      Container(
                        width: width * 0.72,
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
                                  Get.to(() => ListPage());
                                },
                                icon: Image.asset('assets/button_image/list_button.png'),
                              ),
                            ),
                            Container(
                              width: width * 0.72 - 91,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => SearchPage(_items));
                                },
                                child: Text(
                                  searchedWord == '' ? '나의 지도' : searchedWord!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xff787878), fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 33,
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  Get.to(() => SearchPage(_items));
                                },
                                icon: Image.asset('assets/button_image/search_button.png'),
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
                      SizedBox(width: width * 0.065),
                    ],
                  ),
                ],
              ), // 앱바
              SizedBox(height: 2.5),
              FilterPage() // 필터
            ],
          ),
        ],
      ),
    );
  }
}
