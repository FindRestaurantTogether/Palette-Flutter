import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';

class ListviewPage extends StatelessWidget {

  final _NaverMapPageController = Get.put(NaverMapPageController());

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(3),
      itemCount: _NaverMapPageController.restaurants.length,
      itemBuilder: (context, index){
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
                                          Text(
                                            '  ${_NaverMapPageController.restaurants[index].category}',
                                            style: TextStyle(
                                                color: Color(0xff838383),
                                                fontSize: 10
                                            ),
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
                                    '${_NaverMapPageController.restaurants[index].jibun_address.substring(0,_NaverMapPageController.restaurants[index].jibun_address.indexOf('동') + 1)}',
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
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}