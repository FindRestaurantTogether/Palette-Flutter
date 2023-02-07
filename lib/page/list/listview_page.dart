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
                    Container(
                      padding: EdgeInsets.all(16),
                      width: 165,
                      height: 107,
                      child: Column(
                        children: [
                          Container(
                              height: 24,
                              child: Row(
                                children: [
                                  Container(
                                    height: 22,
                                    child: Text(
                                      '${_NaverMapPageController.restaurants[index].store_name}',
                                      style: TextStyle(
                                          color: Color(0xff464646),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
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
                                    height: 24,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '  ${_NaverMapPageController.restaurants[index].category}',
                                          style: TextStyle(
                                              color: Color(0xff838383), fontSize: 13),
                                        ),
                                        SizedBox(height: 1)
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ), // 음식점 이름
                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xfff42957),
                                  size: 15,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${_NaverMapPageController.restaurants[index].naver_star}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff464646)
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '(${_NaverMapPageController.restaurants[index].naver_cnt}건)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff464646)
                                  ),
                                )
                              ],
                            ),
                          ),// 별점
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
                          ), // 주소
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 95,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(_NaverMapPageController.restaurants[index].store_image[0]),
                            fit: BoxFit.fill
                        ),
                      ),
                    ),
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