import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/list/listview_page.dart';
import 'package:myapp/page/map/map_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/search/search_page.dart';
import 'package:myapp/page/map/search/search_page_controller.dart';

final List<String> DropdownList = ['거리순', '평점순', '리뷰순'];
final List<String> DropdownList2 = ['3.0', '3.5', '4.0', '4.5'];

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  final _SearchPageController = Get.put(SearchPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());

  String DropdownSelected = DropdownList.first;
  String DropdownSelected2 = '';

  bool Open = false;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: height * 0.075),
          Container(
              width: width * 0.87,
              height: 43,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
              ),
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 37,
                    padding: EdgeInsets.only(bottom: 1.2),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Image.asset('assets/button_image/map_button.png'),
                    ),
                  ),
                  Obx(() {
                    return  Container(
                        width: width * 0.87 - 91,
                        height: 43,
                        child: Center(
                          child: Text (
                            _SearchPageController.searchedWord.value == '' ? '장소, 주소, 음식 검색' : _SearchPageController.searchedWord.value,
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xffb9b9b9),
                            ),
                          ),
                        )
                    );
                  }),
                  SizedBox(
                    width: 30,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        setState(() {
                          _SearchPageController.searchedWord.value = '';
                        });
                        Get.back();
                        await _NaverMapPageController.fetchRestaurantData(context, '');
                      },
                      icon: Image.asset('assets/button_image/close_button.png'),
                    ),
                  ),
                ],
              )
          ), // 검색창
          SizedBox(height: 15),
          Center(
            child: Container(
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.only(left: 12, right: 15),
                                  primary: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: StadiumBorder()
                              ),
                              onPressed: () {},
                              child: DropdownButton2(
                                isExpanded: true,
                                selectedItemBuilder: (BuildContext context) {
                                  return DropdownList.map((String value) {
                                    return Center(
                                      child: Text(
                                        DropdownSelected!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:  Color(0xfff42957),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: DropdownList
                                    .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff787878),
                                      ),
                                    )
                                )).toList(),
                                value: DropdownSelected,
                                onChanged: (value) {
                                  setState(() {
                                    DropdownSelected = value as String;
                                  });
                                },
                                underline: Container(),
                                icon: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: Image.asset('assets/button_image/down_button.png'),
                                ),
                                buttonElevation: 0,
                                dropdownWidth: 90,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                itemHeight: 40,
                                offset: Offset(-15, -1),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 72,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Open = !Open;
                                });
                              },
                              child: Text(
                                '영업중',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Open ? Colors.white : Color(0xff787878),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Open ? Color(0xfff42957) : Colors.white,
                                shape: StadiumBorder(),
                                shadowColor: Colors.transparent,
                              )
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 108,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.only(left: 18, right: 15),
                                primary: Colors.white,
                                shape: StadiumBorder(),
                                shadowColor: Colors.transparent,
                            ),
                            onPressed: () {},
                            child: DropdownButton2(
                              focusColor: Color(0xfff42957),
                              isExpanded: true,
                              hint: Text(
                                  '최소 평점',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff787878),
                                  ),
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return DropdownList2.map((String value) {
                                  return Center(
                                    child: Text(
                                      DropdownSelected2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:  Color(0xfff42957),
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              items: DropdownList2.map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff787878),
                                    ),
                                  )
                              )).toList(),
                              value: DropdownSelected2 == '' ? null : DropdownSelected2,
                              onChanged: (value) {
                                setState(() {
                                  DropdownSelected2 = value as String;
                                });
                              },
                              underline: Container(),
                              icon: SizedBox(
                                width: 12,
                                height: 12,
                                child: Image.asset('assets/button_image/down_button.png'),
                              ),
                              buttonElevation: 0,
                              dropdownWidth: 108,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              itemHeight: 40,
                              offset: Offset(-15, -1),
                            )
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                )),
          ), // 필터들
          SizedBox(height: height * 0.032),
          Container(
            width: width,
            height: 4,
            color: Color(0xffeeeeee),
          ), // 회색 바
          Expanded(child: ListviewPage())
        ],
      ),
    );
  }
}
