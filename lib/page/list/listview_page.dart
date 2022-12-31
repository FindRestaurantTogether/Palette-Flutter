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
                              height: 25,
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      '${_NaverMapPageController.restaurants[index].name}',
                                      style: TextStyle(
                                          color: Color(0xff464646),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  _NaverMapPageController.restaurants[index].open
                                      ? Container(
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
                                      : Container(
                                        height: 20,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: Color(0xfff62957),
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
                                          '  ${_NaverMapPageController.restaurants[index].classification}',
                                          style: TextStyle(
                                              color: Color(0xff838383), fontSize: 13),
                                        ),
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
                                  '${_NaverMapPageController.restaurants[index].overallRating}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff464646)
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '(${_NaverMapPageController.restaurants[index].numberOfOverallRating}건)',
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
                                  '${_NaverMapPageController.restaurants[index].address.substring(0,_NaverMapPageController.restaurants[index].address.indexOf('동') + 1)}',
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
                            image: AssetImage(_NaverMapPageController.restaurants[index].exteriorImage),
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