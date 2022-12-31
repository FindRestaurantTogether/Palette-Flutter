import 'dart:convert';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/page/list/list_page.dart';
import 'package:myapp/page/map/filter/filter_page.dart';
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
          Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.075),
                Container(
                  height: height * 0.06,
                  width: width * 0.87,
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                      ExpandTapWidget(
                        onTap: () {
                          Get.to(() => ListPage());
                        },
                        tapPadding: EdgeInsets.all(25),
                        child: Container(
                          child: Icon(
                                Icons.list,
                                color: Color(0xff787878),
                                size: 27,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '나의 지도',
                          style: TextStyle(color: Color(0xff787878), fontSize: 18),
                        ),
                      ),
                      ExpandTapWidget(
                        onTap: () {
                          Get.to(() => SearchPage(_items));
                        },
                        tapPadding: EdgeInsets.all(25),
                        child: Container(
                          child: Icon(
                                Icons.search,
                                color: Color(0xff787878),
                                size: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                ), // 앱바
                SizedBox(height: height * 0.003),
                FilterPage() // 필터
              ],
            ),
          ),
        ],
      ),
    );
  }
}
