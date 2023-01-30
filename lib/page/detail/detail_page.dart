import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/menu/menu_page.dart';
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
  final _FavoriteListPageController = Get.put(FavoriteListPageController());
  final _FavoriteFolderPageController = Get.put(FavoriteFolderPageController());

  final selectedRestaurant = Get.arguments;

  late List<bool> ToggleSelected;

  bool moreOpenInformation = false;

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
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                  SizedBox(height: height * 0.17), // 빈 공간
                  Center(
                    child: Container(
                      width: width * 0.87,
                      padding: EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
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
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 27,
                                      height: 34,
                                      child: IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Image.asset('assets/button_image/back_button.png'),
                                      ),
                                    ), // 뒤로가기 버튼
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 17,
                                          height: 21,
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
                                                icon: Image.asset('assets/button_image/favorite_button.png'),
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
                                                  icon: Image.asset('assets/button_image/unfavorite_button.png'),
                                                );
                                          }),
                                        ),
                                        SizedBox(width: 6)
                                      ],
                                    ) // 즐겨찾기 버튼
                                  ],
                                ), // 뒤로가기 버튼, 즐겨찾기 버튼
                                Container(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          '   ${selectedRestaurant.name}',
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
                                                color: Color(0xff57dde0),
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
                                                color: Color(0xfff42957),
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // 음식점 이름
                              ],
                            )
                          ), // 뒤로가기 버튼, 음식점 이름, 즐겨찾기 버튼
                          SizedBox(height: 5), // 빈 공간
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xfff42957),
                                  size: 18,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  ' ${selectedRestaurant.overallRating}(${selectedRestaurant.numberOfOverallRating})',
                                  style:
                                  TextStyle(fontSize: 15),
                                ),
                                SizedBox(width: 1),
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
                          ), // 별점, 중분류
                          SizedBox(height: 14), // 빈 공간
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < selectedRestaurant.atmosphere.length; i++)
                                  Text(
                                    '#${selectedRestaurant.atmosphere[i]} ',
                                    style: TextStyle(fontSize: 12, color: Color(0xff57dde0)),
                                  )
                              ]
                          ), // #분위기
                          SizedBox(height: 12), // 빈 공간
                          Container(
                            width: width * 0.67,
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
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: Color(0xff57dde0),
                                        size: 16,
                                      ),
                                      SizedBox(width: 6), // 빈 공간
                                      Text(
                                        selectedRestaurant.open ? '영업중' : '영업종료',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            // color: selectedRestaurant.open ? Color(0xff57dde0) : Color(0xfff42957),
                                        ),
                                      ), // 영업시간
                                      SizedBox(width: 0), // 빈 공간
                                      Container(
                                        width: 20,
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              moreOpenInformation = !moreOpenInformation;
                                            });
                                          },
                                          icon: moreOpenInformation ? Icon(Icons.keyboard_arrow_up, size: 16) : Icon(Icons.keyboard_arrow_down, size: 16),
                                        ),
                                      ), // 더 보기 버튼
                                    ],
                                  ),
                                ), // 영업시간
                                SizedBox(height: 6),
                                Container(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Color(0xff57dde0),
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          '${selectedRestaurant.address}',
                                          style: TextStyle(fontSize: 12)
                                      ),
                                    ],
                                  ),
                                ), // 주소
                                SizedBox(height: 6),
                                Container(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: Color(0xff57dde0),
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
                                    height: 30,
                                    child: ToggleButtons(
                                      children: [
                                        Container(
                                            width: width * 0.655 / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child: Image.asset('assets/button_image/call_button.png'),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                            width: width * 0.655 / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child: Image.asset('assets/button_image/share_button.png'),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          width: width * 0.655 / 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 12,
                                                height: 12,
                                                child: Image.asset('assets/button_image/navigation_button.png'),
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
                          ) // 영업시간, 주소, 서비스, 토글버튼
                        ],
                      ),
                    ),
                  ), // 위에 큰 박스
                  SizedBox(height: 30), // 빈 공간
                  Container(
                    width: width * 0.87,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                            GestureDetector(
                              onTap: () {
                                Get.to(() => MenuPage(), arguments: selectedRestaurant);
                              },
                              child: Row(
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
                                    size: 14,
                                  )
                                ],
                              ),
                            )
                          ],
                        ), // 메뉴 & 전체보기
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: selectedRestaurant.menu.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Text(
                                            '${menuName[index]}',
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            ' ${menuInfo[index][0].toInt()}원',
                                            style: TextStyle(fontSize: 15, color: Color(0xfff42957), fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (index != selectedRestaurant.menu.length - 1)
                                    VerticalDivider(width: 30, color: Colors.black45)
                                ],
                              );
                            },
                          ),
                        ), // 메뉴들
                      ],
                    ),
                  ), // 메뉴
                  Divider(indent: 35, endIndent: 35, color: Colors.black45),
                  SizedBox(height: 25), // 빈 공간
                  Container(
                    width: width * 0.87,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10
                                        ),
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Image.asset('assets/button_image/naver_button.png'),
                                        ),
                                        SizedBox(
                                            width: 20
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '네이버 리뷰',
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ), // 아이콘, 네이버 리뷰
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff42957),
                                              size: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '4.3',
                                              style: TextStyle(fontSize: 13, color: Color(0xfff42957)),
                                            ),
                                          ],
                                        ), // 별점
                                        SizedBox(
                                            width: 15
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '16건',
                                              style: TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                              size: 14,
                                            )
                                          ]
                                        ), // 리뷰 개수
                                        SizedBox(width: 7)
                                      ],
                                    ) // 별점, 리뷰 개수
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ), // 네이버 리뷰
                            SizedBox(height: 12),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 10
                                        ),
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Image.asset('assets/button_image/google_button.png'),
                                        ),
                                        SizedBox(
                                            width: 20
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '구글 리뷰',
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ), // 아이콘, 구글 리뷰
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff42957),
                                              size: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '4.3',
                                              style: TextStyle(fontSize: 13, color: Color(0xfff42957)),
                                            ),
                                          ],
                                        ), // 별점
                                        SizedBox(
                                            width: 15
                                        ),
                                        Row(
                                            children: [
                                              Text(
                                                '16건',
                                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.grey,
                                                size: 14,
                                              )
                                            ]
                                        ), // 리뷰 개수
                                        SizedBox(width: 7)
                                      ],
                                    ) // 별점, 리뷰 개수
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ), // 구글 리뷰
                            SizedBox(height: 12),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 10
                                        ),
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Image.asset('assets/button_image/kakao_button.png'),
                                        ),
                                        SizedBox(
                                            width: 20
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '카카오 리뷰',
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ), // 아이콘, 카카오 리뷰
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff42957),
                                              size: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '4.3',
                                              style: TextStyle(fontSize: 13, color: Color(0xfff42957)),
                                            ),
                                          ],
                                        ), // 별점
                                        SizedBox(
                                            width: 15
                                        ),
                                        Row(
                                            children: [
                                              Text(
                                                '16건',
                                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.grey,
                                                size: 14,
                                              )
                                            ]
                                        ), // 리뷰 개수
                                        SizedBox(width: 7)
                                      ],
                                    ) // 별점, 리뷰 개수
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ), // 카카오 리뷰
                            SizedBox(height: 20),
                          ],
                        )
                      ],
                    ),
                  ), // 평점 및 리뷰
                ],
              ), // 나머지
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
    String naverUrl = 'nmap://search?query=$address&appname=com.example.myapp';
    if (await canLaunch(naverUrl)) {
      await launch(naverUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}