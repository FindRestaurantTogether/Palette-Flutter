import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:myapp/page/detail/detail_page_controller.dart';
import 'package:myapp/page/detail/review/see_review_page.dart';
import 'package:myapp/page/detail/review/write_review_page1.dart';
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

  late List<bool> ToggleSelected;

  @override
  void initState() {
    ToggleSelected = [false, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _selectedRestaurant = Get.arguments;
    int selectedIndex = _NaverMapPageController.restaurants.indexWhere((NaverMapPageModel restaurant) => restaurant.markerId == _selectedRestaurant.markerId);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
       },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              SingleChildScrollView(
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
                              image: AssetImage(_selectedRestaurant.exteriorImage),
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
                            height: _DetailPageController.mI? height * 0.36 : height * 0.338,
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
                                        height: 23,
                                        child: IconButton(
                                            padding: EdgeInsets.all(0.0),
                                            onPressed: (){
                                              Get.back();
                                            },
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.black54,
                                              size: 20
                                            )
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                '${_selectedRestaurant.name}',
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            _selectedRestaurant.open
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
                                                      _NaverMapPageController.restaurants[selectedIndex].favorite.toggle();
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
                                        ' ${_selectedRestaurant.overallRating}(${_selectedRestaurant.numberOfOverallRating})',
                                        style:
                                        TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(width: 1),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _DetailPageController.changeState();
                                          });
                                        },
                                        child: _DetailPageController.mI
                                            ? Icon(Icons.keyboard_arrow_up, color: Colors.black54, size: 20)
                                            : Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20)
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '|',
                                        style: TextStyle(fontSize: 15, color: Colors.black87),
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        '${_selectedRestaurant.classification}      ',
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
                                              ' ${_selectedRestaurant.menuRating}(${_selectedRestaurant.numberOfMenuRating})',
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
                                              ' ${_selectedRestaurant.restaurantRating}(${_selectedRestaurant.numberOfRestaurantRating})',
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
                                      for (int i = 0; i < _selectedRestaurant.atmosphere.length; i++)
                                        Text(
                                          '#${_selectedRestaurant.atmosphere[i]} ',
                                          style: TextStyle(fontSize: 12, color: Colors.cyan.shade300),
                                        )
                                    ]
                                ),
                                SizedBox(height: height * 0.014),
                                Container(
                                  width: width * 0.67,
                                  height: height * 0.156,
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
                                                '${_selectedRestaurant.address}',
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
                                                  for (int i = 0; i < _selectedRestaurant.service.length; i++)
                                                    if (i == _selectedRestaurant.service.length - 1)
                                                      Text(
                                                        '${_selectedRestaurant.service[i]}',
                                                        style: TextStyle(fontSize: 12, color: Colors.black87),
                                                      )
                                                    else
                                                      Text(
                                                        '${_selectedRestaurant.service[i]}, ',
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
                                                                        KakaoMapUtils.OpenKakaoMap('${_selectedRestaurant.address}');
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
                                                                        GoogleMapUtils.OpenGoogleMap('${_selectedRestaurant.address}');
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
                                                                        NaverMapUtils.OpenNaverMap('${_selectedRestaurant.address}');
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
                              ),
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '모둠 사시미',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '   |   ',
                                        style: TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                      Text(
                                        '26000원',
                                        style: TextStyle(fontSize: 15, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.pinkAccent,
                                        size: 14,
                                      ),
                                      Text(
                                        ' 4.3(16건)',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '모둠 사시미',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '   |   ',
                                        style: TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                      Text(
                                        '26000원',
                                        style: TextStyle(fontSize: 15, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.pinkAccent,
                                        size: 14,
                                      ),
                                      Text(
                                        ' 4.3(16건)',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '모둠 사시미',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '   |   ',
                                        style: TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                      Text(
                                        '26000원',
                                        style: TextStyle(fontSize: 15, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.pinkAccent,
                                        size: 14,
                                      ),
                                      Text(
                                        ' 4.3(16건)',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '모둠 사시미',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '   |   ',
                                        style: TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                      Text(
                                        '26000원',
                                        style: TextStyle(fontSize: 15, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.pinkAccent,
                                        size: 14,
                                      ),
                                      Text(
                                        ' 4.3(16건)',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ), // 메뉴판
                        Container(
                          width: width * 0.87,
                          padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 15),
                          // padding: EdgeInsets.only(top: 0, bottom: 10, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '최근 리뷰',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(() => SeeReviewPage(), arguments: _selectedRestaurant);
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
                                        size: 12,
                                      )
                                    ],
                                  )
                              )
                            ],
                          )
                        ), // 최근 리뷰
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.only(left: 30),
                            child: Row(
                              children: [
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.white,
                                  child: Container(
                                    width: width * 0.68,
                                    // height: height * 0.42,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage('assets/login_image/food.png'),
                                              backgroundColor: Colors.white,
                                              radius: 20,
                                            ), // 아바타
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'hak_dori',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff464646)
                                                        ),
                                                      ),
                                                      Text(
                                                        '2022.10.02',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(0xffb2b2b2)
                                                        ),
                                                      ),
                                                    ],
                                                  ), // 계정 이름과 날짜
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        child: OutlinedButton(
                                                            onPressed: (){},
                                                            child: Text(
                                                              '모둠 사시미',
                                                              style: TextStyle(
                                                                color: Colors.pinkAccent,
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                            style: OutlinedButton.styleFrom(
                                                                side: BorderSide(width: 1, color: Colors.pinkAccent),
                                                                minimumSize: Size.zero,
                                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                                shape: StadiumBorder()
                                                            )
                                                        ),
                                                      ) // 메뉴 알약
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ), // 별점 윗부분
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            RatingBarIndicator(
                                              rating: 4,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemBuilder: (context, index) => Icon(Icons.star, color: Colors.pinkAccent),
                                              direction: Axis.horizontal,
                                            ),
                                            SizedBox(width: 8),
                                            LikeButton(size: 18),
                                            SizedBox(width: 1),
                                            Text(
                                              '3',
                                              style: TextStyle(
                                                fontSize: 10
                                              ),
                                            )
                                          ],
                                        ), // 별점과 좋아요 버튼과 좋아요 개수
                                        SizedBox(height: 12),
                                        Container(
                                          child: Text(
                                              '일단 강추부터 박고 갑니다. 지난주에 처음 방문하고 너무 좋아서 그 자리에서 바로 다른 약속을 이곳으로 잡았어요.',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff464646)
                                              ),
                                          )
                                        ), // 텍스트 설명
                                        SizedBox(height: 12),
                                        Container(
                                          width: width * 0.584,
                                          height: height * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage('assets/background_image/taroya.jpeg'),
                                                fit: BoxFit.fill
                                            ),
                                          ),
                                        ), // 이미지
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 7),
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.white,
                                  child: Container(
                                    width: width * 0.68,
                                    // height: height * 0.42,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage('assets/login_image/food.png'),
                                              backgroundColor: Colors.white,
                                              radius: 20,
                                            ), // 아바타
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'hak_dori',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff464646)
                                                        ),
                                                      ),
                                                      Text(
                                                        '2022.10.02',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(0xffb2b2b2)
                                                        ),
                                                      ),
                                                    ],
                                                  ), // 계정 이름과 날짜
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        child: OutlinedButton(
                                                            onPressed: (){},
                                                            child: Text(
                                                              '모둠 사시미',
                                                              style: TextStyle(
                                                                color: Colors.pinkAccent,
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                            style: OutlinedButton.styleFrom(
                                                                side: BorderSide(width: 1, color: Colors.pinkAccent),
                                                                minimumSize: Size.zero,
                                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                                shape: StadiumBorder()
                                                            )
                                                        ),
                                                      ) // 메뉴 알약
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ), // 별점 윗부분
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            RatingBarIndicator(
                                              rating: 4,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemBuilder: (context, index) => Icon(Icons.star, color: Colors.pinkAccent),
                                              direction: Axis.horizontal,
                                            ),
                                            SizedBox(width: 8),
                                            LikeButton(size: 18),
                                            SizedBox(width: 1),
                                            Text(
                                              '3',
                                              style: TextStyle(
                                                  fontSize: 10
                                              ),
                                            )
                                          ],
                                        ), // 별점과 좋아요 버튼과 좋아요 개수
                                        SizedBox(height: 12),
                                        Container(
                                            child: Text(
                                              '일단 강추부터 박고 갑니다. 지난주에 처음 방문하고 너무 좋아서 그 자리에서 바로 다른 약속을 이곳으로 잡았어요.',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xff464646)
                                              ),
                                            )
                                        ), // 텍스트 설명
                                        SizedBox(height: 12),
                                        Container(
                                          width: width * 0.584,
                                          height: height * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage('assets/background_image/taroya.jpeg'),
                                                fit: BoxFit.fill
                                            ),
                                          ),
                                        ), // 이미지
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 7),
                              ],
                            ),
                          ),
                        ), // 리뷰 cards
                        SizedBox(height: 30)
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 30,
                child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        heroTag: null,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        backgroundColor: Color(0xfff42957),
                        onPressed: () {
                          Get.to(() => WriteReviewPage1(), arguments: _selectedRestaurant);

                        },
                      ),
                    ),
              )
            ],
          )
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