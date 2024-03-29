import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _NaverMapPageController = Get.put(NaverMapPageController());

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final menuName = _NaverMapPageController.selectedDetailRestaurant.value.menu.keys.toList();
    final menuInfo = _NaverMapPageController.selectedDetailRestaurant.value.menu.values.toList();

    return Material(
      child: Column(
        children: [
          SizedBox(height: height * 0.08),
          Container(
            child: Stack(
              children: [
                Container(
                  height: 45,
                  child: Row(
                    children: [
                      SizedBox(width: 30),
                      Container(
                        width: 27,
                        height: 45,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Get.back();
                          },
                          icon: Image.asset('assets/button_image/back_button.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  child: Center(
                    child: Text(
                      '전체 메뉴',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff464646)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ), // 백 버튼과 오류 제보/식당 등록
          SizedBox(height: 15),
          Divider(indent: 25, endIndent: 25, height: 1),
          Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 38, vertical: 25),
                physics: BouncingScrollPhysics(),
                itemCount: _NaverMapPageController.selectedDetailRestaurant.value.menu.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                '${menuName[index]}',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                ' ${menuInfo[index]}원',
                                style: TextStyle(fontSize: 15, color: Color(0xfff42957), fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8)
                    ],
                  );
                },
              )
          )
        ],
      ),
    );
  }
}



