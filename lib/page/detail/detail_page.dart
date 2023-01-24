import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:myapp/page/detail/detail_page_controller.dart';
import 'package:myapp/page/detail/review/see_all_review_page.dart';
import 'package:myapp/page/detail/review/write_review_page1.dart';
import 'package:myapp/page/favorite/favorite_page_folder_controller.dart';
import 'package:myapp/page/favorite/favorite_page_list_controller.dart';
import 'package:myapp/page/favorite/folder/select_folder_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _DetailPageController = Get.put(DetailPageController());
  final _FavoriteListPageController = Get.put(FavoriteListPageController());
  final _FavoriteFolderPageController = Get.put(FavoriteFolderPageController());

  final selectedRestaurant = Get.arguments;

  late List<bool> ToggleSelected;

  @override
  void initState() {
    ToggleSelected = [false, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final int selectedIndex = _NaverMapPageController.restaurants.indexWhere((NaverMapPageModel restaurant) => restaurant.uid == selectedRestaurant.uid);

    final menuName = selectedRestaurant.menu.keys.toList();
    final menuInfo = selectedRestaurant.menu.values.toList();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Material(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: height * 0.32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(selectedRestaurant.exteriorImage),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
              ), // 배경화면
              Column(
                children: [
                  SizedBox(height: height * 0.17),
                  Center(
                    child: Container(
                      width: width * 0.87,
                      height: _DetailPageController.mI? height * 0.36 : height * 0.355,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 27,
                                  height: 35,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Image.asset('assets/button_image/back_button.png'),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '${selectedRestaurant.name}',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      selectedRestaurant.open
                                          ? Container(
                                        height: 32,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                color: Colors.cyan.shade300,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      )
                                          : Container(
                                        height: 32,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                color: Colors.red.shade300,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 23,
                                  child: Obx(() {
                                    return  _NaverMapPageController.restaurants[selectedIndex].favorite.value
                                        ? IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: (){
                                          setState(() {
                                            _NaverMapPageController.restaurants[selectedIndex].favorite.toggle();
                                            _FavoriteListPageController.listRestaurantIsChecked.removeAt(_FavoriteListPageController.listRestaurant.indexWhere((e) => e == selectedRestaurant));
                                            _FavoriteListPageController.listRestaurant.remove(selectedRestaurant);
                                            for (var i=0 ; i<_FavoriteFolderPageController.folderRestaurant.length ; i++) {
                                              if (_FavoriteFolderPageController.folderRestaurant[i].contains(selectedRestaurant))
                                                _FavoriteFolderPageController.folderRestaurant[i].remove(selectedRestaurant);
                                            }
                                          });
                                        },
                                        icon: Icon(
                                            Icons.bookmark,
                                            color: Colors.pinkAccent,
                                            size: 25
                                        )
                                    )
                                        : IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        setState(() {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return SelectFolderPage(selectedRestaurant: selectedRestaurant);
                                              }
                                          );
                                        });
                                      },
                                      icon: Icon(
                                          Icons.bookmark_border,
                                          color: Colors.pinkAccent,
                                          size: 25
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Container(
                            // color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.pinkAccent,
                                  size: 18,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  ' ${selectedRestaurant.overallRating}(${selectedRestaurant.numberOfOverallRating})',
                                  style:
                                  TextStyle(fontSize: 15),
                                ),
                                SizedBox(width: 1),
                                // GestureDetector(
                                //     onTap: () {
                                //       setState(() {
                                //         _DetailPageController.changeState();
                                //       });
                                //     },
                                //     child: _DetailPageController.mI
                                //         ? Icon(Icons.keyboard_arrow_up, color: Colors.black54, size: 20)
                                //         : Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20)
                                // ),
                                SizedBox(width: 5),
                                Text(
                                  '|',
                                  style: TextStyle(fontSize: 15, color: Colors.black87),
                                ),
                                SizedBox(width: 7),
                                Text(
                                  '${selectedRestaurant.classification}      ',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          _DetailPageController.mI
                              ? Container(
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '메뉴 ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.pinkAccent,
                                      size: 12,
                                    ),
                                    Text(
                                      ' ${selectedRestaurant.menuRating}(${selectedRestaurant.numberOfMenuRating})',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(width: 13),
                                    Text(
                                      '매장 ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.pinkAccent,
                                      size: 12,
                                    ),
                                    Text(
                                      ' ${selectedRestaurant.restaurantRating}(${selectedRestaurant.numberOfRestaurantRating})',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                              : SizedBox(),
                          SizedBox(height: height * 0.016),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < selectedRestaurant.atmosphere.length; i++)
                                  Text(
                                    '#${selectedRestaurant.atmosphere[i]} ',
                                    style: TextStyle(fontSize: 12, color: Colors.cyan.shade300),
                                  )
                              ]
                          ),
                          SizedBox(height: height * 0.014),
                          Container(
                            width: width * 0.67,
                            height: height * 0.16,
                            padding: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black45,
                                    width: 1,
                                  ),
                                )
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.02,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: Colors.cyan.shade300,
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '영업 중',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black54,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ), // 영업시간
                                SizedBox(height: height * 0.01),
                                Container(
                                  height: height * 0.02,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.cyan.shade300,
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          '${selectedRestaurant.address}',
                                          style: TextStyle(fontSize: 12)
                                      ),
                                      // SizedBox(width: 3),
                                      // Icon(
                                      //   Icons.map_outlined,
                                      //   color: Colors.grey,
                                      //   size: 16,
                                      // ),
                                    ],
                                  ),
                                ), // 주소
                                SizedBox(height: height * 0.01),
                                Container(
                                  height: height * 0.02,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: Colors.cyan.shade300,
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Row(
                                          children: [
                                            for (int i = 0; i < selectedRestaurant.service.length; i++)
                                              if (i == selectedRestaurant.service.length - 1)
                                                Text(
                                                  '${selectedRestaurant.service[i]}',
                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                )
                                              else
                                                Text(
                                                  '${selectedRestaurant.service[i]}, ',
                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                )
                                          ]
                                      ),
                                    ],
                                  ),
                                ), // 서비스
                                SizedBox(height: 15),
                                Center(
                                  child: Container(
                                    height: height * 0.04,
                                    child: ToggleButtons(
                                      children: [
                                        Container(
                                            width: width * 0.655 / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.call,
                                                    color: Colors.black54,
                                                    size: 17
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                            width: width * 0.655 / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.open_in_new,
                                                    color: Colors.black54,
                                                    size: 17
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          width: width * 0.655 / 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  Icons.navigation,
                                                  color: Colors.black54,
                                                  size: 17
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
                                                                  KakaoMapUtils.OpenKakaoMap('${selectedRestaurant.address}');
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
                                                                  GoogleMapUtils.OpenGoogleMap('${selectedRestaurant.address}');
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
                                                                  NaverMapUtils.OpenNaverMap('${selectedRestaurant.address}');
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
                                  ),
                                ), // 토글버튼
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ), // 위에 큰 박스
                  SizedBox(height: height * 0.038),
                  Container(
                    width: width * 0.87,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '메뉴',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '전체보기',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 12,
                                )
                              ],
                            )
                          ],
                        ), // 메뉴 & 전체보기
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            itemCount: selectedRestaurant.menu.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Column(
                                children: [
                                  Container(
                                    width: 80,
                                    child: Text(
                                      '${menuName[index]}',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Container(
                                    width: 80,
                                    child: Text(
                                      ' ${menuInfo[index][0].toInt()}원',
                                      style: TextStyle(fontSize: 15, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return VerticalDivider();
                            },
                          ),
                        ),
                      ],
                    ),
                  ), // 메뉴
                  SizedBox(height: 30),
                  Container(
                    width: width * 0.87,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '평점 및 리뷰',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ), // 평점 및 리뷰
                        SizedBox(height: 20),
                        Column(
                          children: [
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [],
                                  )
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [],
                                  )
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [],
                                  )
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        )
                      ],
                    ),
                  ), // 평점 및 리뷰
                ],
              ),
            ],
          ),
        )
      )
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