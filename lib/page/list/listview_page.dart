import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/search/search_page_controller.dart';

class ListviewPage extends StatefulWidget {

  @override
  State<ListviewPage> createState() => _ListviewPageState();
}

class _ListviewPageState extends State<ListviewPage> {
  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _SearchPageController = Get.put(SearchPageController());
  final _ScrollController = ScrollController();

  bool dataLoading = false;

  @override
  void initState() {
    super.initState();
    _ScrollController.addListener(_ScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: RawScrollbar(
          controller: _ScrollController,
          thumbColor: Color(0xfff42957),
          radius: Radius.circular(10),
          thickness: 5,
          child: ListView.separated(
            controller: _ScrollController,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(3),
            itemCount: dataLoading
                ? _NaverMapPageController.restaurants.length + 1
                : _NaverMapPageController.restaurants.length,
            itemBuilder: (context, index){
              if (index < _NaverMapPageController.restaurants.length) {
                return ExpandTapWidget(
                  onTap: () {
                    Get.to(() => DetailPage(), arguments: _NaverMapPageController.restaurants[index]);
                  },
                  tapPadding: EdgeInsets.all(25),
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 10),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 15),
                                child: Column(
                                  children: [
                                    Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              child: Text(
                                                '${_NaverMapPageController.restaurants[index].store_name}',
                                                style: TextStyle(
                                                    color: Color(0xff464646),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            if (_NaverMapPageController.restaurants[index].open == 'open')
                                              Container(
                                                height: 20,
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xff57dde0),
                                                        shape: BoxShape.circle),
                                                  ),
                                                ),
                                              )
                                            else if (_NaverMapPageController.restaurants[index].open == 'close')
                                              Container(
                                                height: 20,
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xfff42957),
                                                        shape: BoxShape.circle),
                                                  ),
                                                ),
                                              )
                                            else if (_NaverMapPageController.restaurants[index].open == 'breaktime')
                                                Container(
                                                  height: 20,
                                                  child: Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                          color: Colors.yellow,
                                                          shape: BoxShape.circle),
                                                    ),
                                                  ),
                                                )
                                              else if (_NaverMapPageController.restaurants[index].open == 'null')
                                                  Container(
                                                    height: 20,
                                                    child: Align(
                                                      alignment: Alignment.topCenter,
                                                      child: Container(
                                                        width: 5,
                                                        height: 5,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle),
                                                      ),
                                                    ),
                                                  ),
                                            Container(
                                              height: 20,
                                              padding: EdgeInsets.only(bottom: 1),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      for (int i = 0; i < _NaverMapPageController.restaurants[index].category.length; i++)
                                                        if (i == 0)
                                                          Text(
                                                            '  ${_NaverMapPageController.restaurants[index].category[i]}',
                                                            style: TextStyle(color: Color(0xff838383), fontSize: 10),
                                                          )
                                                        else
                                                          Text(
                                                            ',${_NaverMapPageController.restaurants[index].category[i]}',
                                                            style: TextStyle(color: Color(0xff838383), fontSize: 10),
                                                          )
                                                    ],
                                                  ),
                                                  SizedBox(height: 1)
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ), // 음식점 이름(높이 20)
                                    Container(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Color(0xfff42957),
                                            size: 14,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            '${_NaverMapPageController.restaurants[index].naver_star}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff464646)
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            '(${_NaverMapPageController.restaurants[index].naver_cnt}건)',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff464646)
                                            ),
                                          )
                                        ],
                                      ),
                                    ),// 별점(높이 30)
                                    Container(
                                      height: 20,
                                      child: Row(
                                        children: [
                                          Text(
                                            '${_NaverMapPageController.restaurants[index].jibun_address.split(' ').getRange(0,3).join(' ')}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff464646)
                                            ),
                                          )
                                        ],
                                      ),
                                    ), // 주소(높이 20)
                                  ],
                                ),
                              ),
                            ), // 음식점 정보(패딩 포함 높이 100 패딩 미포함 높이 70)
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(_NaverMapPageController.restaurants[index].store_image[0]),
                                    fit: BoxFit.fill
                                ),
                              ),
                            ), // 이미지
                          ],
                        );
                      })
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator(color: Color(0xfff42957)));
              }
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      );
    });
  }

  void _ScrollListener() {
    if (_ScrollController.position.pixels == _ScrollController.position.maxScrollExtent) {
      setState(() {
        dataLoading = true;
      });
      _NaverMapPageController.processRestaurantData(context, _SearchPageController.searchedWord);
      setState(() {
        dataLoading = false;
      });
    }
  }
}