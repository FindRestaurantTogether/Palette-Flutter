import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/favorite/favorite_page_folder_controller.dart';
import 'package:myapp/page/favorite/favorite_page_list_controller.dart';
import 'package:myapp/page/map/bottomsheet/select_folder_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomsheetPage extends StatefulWidget {

  final NaverMapPageModel selectedRestaurant;

  BottomsheetPage({Key? key, required this.selectedRestaurant}) : super(key: key);

  @override
  State<BottomsheetPage> createState() => _BottomsheetPageState(selectedRestaurant: selectedRestaurant);
}

class _BottomsheetPageState extends State<BottomsheetPage> {

  final NaverMapPageModel selectedRestaurant;
  _BottomsheetPageState({required this.selectedRestaurant});

  final _FavoriteListPageController = Get.put(FavoriteListPageController());
  final _FavoriteFolderPageController = Get.put(FavoriteFolderPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());

  late List<bool> ToggleSelected;

  @override
  void initState() {
    ToggleSelected = [false, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final int selectedIndex = _NaverMapPageController.restaurants.indexWhere((NaverMapPageModel restaurant) => restaurant.markerId == selectedRestaurant.markerId);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(top: 25, bottom: 25, left: 35, right: 35),
      width: width,
      height: height * 0.28,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.65,
                height: 24,
                child: Row(
                  children: [
                    Container(
                      height: 24,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${selectedRestaurant.name}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ), // 타로야
                    SizedBox(
                      width: 3,
                    ),
                    selectedRestaurant.open
                        ? Container(
                      height: 20,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.cyan.shade300,
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
                              color: Colors.red.shade300,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Container(
                      height: 24,
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${selectedRestaurant.classification}  |  ${selectedRestaurant.distance}km',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ), // 이자카야 | 1.5km
                  ],
                ),
              ), // 음식점 이름 및 분류
              Obx(() {
                return _NaverMapPageController.restaurants[selectedIndex].favorite.value
                    ? GestureDetector(
                        onTap: (){
                          _NaverMapPageController.restaurants[selectedIndex].favorite.toggle();
                          _FavoriteListPageController.listRestaurantIsChecked.removeAt(_FavoriteListPageController.listRestaurant.indexWhere((e) => e == selectedRestaurant));
                          _FavoriteListPageController.listRestaurant.remove(selectedRestaurant);
                          for (var i=0 ; i<_FavoriteFolderPageController.folderRestaurant.length ; i++) {
                            if (_FavoriteFolderPageController.folderRestaurant[i].contains(selectedRestaurant))
                              _FavoriteFolderPageController.folderRestaurant[i].remove(selectedRestaurant);
                          }
                        },
                        child: Icon(Icons.bookmark, size: 28, color: Colors.pinkAccent)
                    )
                    : GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return SelectFolderPage(selectedRestaurant: selectedRestaurant);
                              }
                          );
                        },
                        child: Icon(Icons.bookmark_border, size: 28, color: Colors.pinkAccent)
                    );  // 즐겨찾기
              })
            ],
          ), // 음식점 이름 & 즐겨찾기
          SizedBox(height: 5),
          Container(
              height:1,
              width: 190,
              alignment: Alignment.centerLeft,
              color:Colors.black12
          ), // 밑줄
          SizedBox(height: 8),
          Container(
            height: 20,
            child: Row(
              children: [
                for (int i = 0; i < selectedRestaurant.atmosphere.length; i++)
                    Text(
                      '#${selectedRestaurant.atmosphere[i]} ',
                      style: TextStyle(fontSize: 13, color: Colors.cyan.shade300),
                    )
              ]
            ),
          ), // 분위기
          SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.pinkAccent,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '${selectedRestaurant.overallRating}',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                '|',
                style: TextStyle(fontSize: 17, color: Colors.black26),
              ),
              SizedBox(width: 10),
              Text(
                '${selectedRestaurant.numberOfOverallRating}건',
                style: TextStyle(color: Colors.black87, fontSize: 13),
              )
            ],
          ), // 별점
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Colors.pinkAccent,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Row(
                        children: [
                          for (int i = 0; i < selectedRestaurant.service.length; i++)
                            if (i == selectedRestaurant.service.length - 1)
                              Text(
                                '${selectedRestaurant.service[i]}',
                                style: TextStyle(fontSize: 13, color: Colors.black87),
                              )
                            else
                              Text(
                                '${selectedRestaurant.service[i]}, ',
                                style: TextStyle(fontSize: 13, color: Colors.black87),
                              )
                        ]
                    ),
                  ],
                ),
              ),
            ],
          ), // 서비스
          SizedBox(height: 15),
          Container(
            height: 35,
            child: ToggleButtons(
              children: [
                Container(
                    width: (width - 72) * 0.33,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.black54,
                        ),
                      ],
                    )),
                Container(
                    width: (width - 72) * 0.33,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.open_in_new,
                          color: Colors.black54,
                        ),
                      ],
                    )),
                Container(
                  width: (width - 72) * 0.33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigation,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
              fillColor: Colors.white,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < ToggleSelected.length; i++) {
                    ToggleSelected[i] = i == index;
                  }

                  if (ToggleSelected[0]) {
                    launch("tel://01012341234");
                  } else if (ToggleSelected[1]) {

                  } else if (ToggleSelected[2]) {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 220,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  Text(
                                    '길찾기 앱을 선택해주세요',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          KakaoMapUtils.OpenKakaoMap('서울특별시 마포구 상수동 93-44번지');
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage('assets/direction_image/kakao_map.png'),
                                                radius: 40,
                                                backgroundColor: Colors.transparent,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                  '카카오맵'
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          GoogleMapUtils.OpenGoogleMap('서울특별시 마포구 상수동 93-44번지');
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage('assets/direction_image/google_map.png'),
                                                radius: 40,
                                                backgroundColor: Colors.transparent,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                  '구글 지도'
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          NaverMapUtils.OpenNaverMap('서울특별시 마포구 상수동 93-44번지');
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage('assets/direction_image/naver_map.png'),
                                                radius: 40,
                                                backgroundColor: Colors.transparent,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                  '네이버 지도'
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
                });
              },
              isSelected: ToggleSelected,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ) // toggle button
        ],
      ),
    );
  }
}

class GoogleMapUtils {
  GoogleMapUtils._();

  static Future<void> OpenGoogleMap(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
class KakaoMapUtils {
  KakaoMapUtils._();

  static Future<void> OpenKakaoMap(String address) async {
    String kakaoUrl = 'daummaps://search?&q=$address';
    if (await canLaunch(kakaoUrl)) {
      await launch(kakaoUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
class NaverMapUtils {
  NaverMapUtils._();

  static Future<void> OpenNaverMap(String address) async {
    String naverUrl =
        'https://m.map.naver.com/search2/search.naver?query=$address';
    if (await canLaunch(naverUrl)) {
      await launch(naverUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
