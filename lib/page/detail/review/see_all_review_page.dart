import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:myapp/page/detail/review/see_only_picture.dart';
import 'package:myapp/page/detail/review/write_review_page1.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

final List<String> DropdownList = ['전체', '음식', '매장'];
final List<String> DropdownList2 = ['최신순', '추천순', '평점순'];

class SeeAllReviewPage extends StatefulWidget {
  SeeAllReviewPage({Key? key}) : super(key: key);

  @override
  State<SeeAllReviewPage> createState() => _SeeAllReviewPageState();
}

class _SeeAllReviewPageState extends State<SeeAllReviewPage> {

  String? DropdownSelected = DropdownList.first;
  String? DropdownSelected2 = DropdownList2.first;

  var ListImage = [
    'assets/list_image/cute1.gif',
    'assets/list_image/cute2.gif',
    'assets/list_image/cute3.gif',
    'assets/list_image/cute4.gif',
    'assets/list_image/cute5.gif',
    'assets/list_image/cute6.gif',
  ];

  late ScrollController? Controller = PrimaryScrollController.of(context);

  @override
  Widget build(BuildContext context) {

    final selectedRestaurant = Get.arguments;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: Get.width,
                  height: 320,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: (){
                                Get.back();
                              },
                              icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black54,
                                  size: 18
                              )
                          ),
                          Container(
                            child: Text(
                              '${selectedRestaurant.name}',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: (){
                                Get.to(() => SeeOnlyPicturePage(), arguments: selectedRestaurant);
                              },
                              icon: Icon(
                                Icons.photo,
                                color: Colors.black54,
                                size: 24,
                              )
                          ),
                        ],
                      ), // 음식점 이름과 버튼 두개
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: 4.38,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, index) => Icon(Icons.star, color: Color(0xfff42957)),
                            direction: Axis.horizontal,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${selectedRestaurant.overallRating}(${selectedRestaurant.numberOfOverallRating})',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ), // 리뷰와 별점
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '메뉴 ${selectedRestaurant.menuRating}(${selectedRestaurant.numberOfMenuRating})    매장 ${selectedRestaurant.restaurantRating}(${selectedRestaurant.numberOfRestaurantRating})',
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 13
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 18),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '5점',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 240,
                                lineHeight: 10,
                                percent: 0.7,
                                // leading: Text("5점"),
                                // trailing: Text("76"),
                                barRadius: Radius.circular(7),
                                backgroundColor: Colors.black26,
                                progressColor: Color(0xfff42957),
                              ),
                              Text(
                                '76',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '4점',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 240,
                                lineHeight: 10,
                                percent: 0.7,
                                // leading: Text("5점"),
                                // trailing: Text("76"),
                                barRadius: Radius.circular(7),
                                backgroundColor: Colors.black26,
                                progressColor: Color(0xfff42957),
                              ),
                              Text(
                                '23',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '3점',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 240,
                                lineHeight: 10,
                                percent: 0.7,
                                // leading: Text("5점"),
                                // trailing: Text("76"),
                                barRadius: Radius.circular(7),
                                backgroundColor: Colors.black26,
                                progressColor: Color(0xfff42957),
                              ),
                              Text(
                                '4',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '2점',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 240,
                                lineHeight: 10,
                                percent: 0.7,
                                // leading: Text("5점"),
                                // trailing: Text("76"),
                                barRadius: Radius.circular(7),
                                backgroundColor: Colors.black26,
                                progressColor: Color(0xfff42957),
                              ),
                              Text(
                                '1',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1점',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 240,
                                lineHeight: 10,
                                percent: 0.7,
                                // leading: Text("5점"),
                                // trailing: Text("76"),
                                barRadius: Radius.circular(7),
                                backgroundColor: Colors.black26,
                                progressColor: Color(0xfff42957),
                              ),
                              Text(
                                '4',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                        ],
                      ), // 5점
                    ],
                  ),
                ), // top box
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        Container(
                          width: width * 0.23,
                          height: height * 0.04,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.only(left: 18, right: 12),
                                  primary: Colors.white,
                                  shape: StadiumBorder()
                              ),
                              onPressed: () {},
                              child: DropdownButton2(
                                isExpanded: true,
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
                                icon: Icon(Icons.keyboard_arrow_down),
                                buttonElevation: 0,
                                dropdownWidth: 78,
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
                          width: width * 0.27,
                          height: height * 0.04,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.only(left: 18, right: 12),
                                  primary: Colors.white,
                                  shape: StadiumBorder()
                              ),
                              onPressed: () {},
                              child: DropdownButton2(
                                isExpanded: true,
                                items: DropdownList2
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
                                value: DropdownSelected2,
                                onChanged: (value) {
                                  setState(() {
                                    DropdownSelected2 = value as String;
                                  });
                                },
                                underline: Container(),
                                icon: Icon(Icons.keyboard_arrow_down),
                                buttonElevation: 0,
                                dropdownWidth: 78,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                itemHeight: 40,
                                offset: Offset(-15, -1),
                              )
                          ),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              width: width,
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
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
                                      ),
                                    ],
                                  ), // 이미지
                                ],
                              ),
                            ),
                            Divider(height: 1)
                          ],
                        );
                      }
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20,
              bottom: 90,
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
                    Icons.vertical_align_top_rounded,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xfff42957),
                  onPressed: () {
                    Controller?.jumpTo(0);
                  },
                ),
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
                    Get.to(() => WriteReviewPage1());
                  },
                ),
              ),
            )
          ],
        )
    );
  }
}
