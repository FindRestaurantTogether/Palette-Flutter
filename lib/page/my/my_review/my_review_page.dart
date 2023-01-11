import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class MyReviewPage extends StatefulWidget {
  MyReviewPage({Key? key}) : super(key: key);

  @override
  State<MyReviewPage> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {

  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            SizedBox(height: height * 0.08),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Container(
                        width: 27,
                        height: 45,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Image.asset('assets/button_image/back_button.png'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '내가 쓴 리뷰',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff464646)
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Image.asset('assets/button_image/edit_button.png'),
                        ),
                      ),
                      SizedBox(width: 25),
                    ],
                  ),
                ],
              ),
            ), // 백 버튼과 내가 쓴 리뷰와 편집 버튼
            SizedBox(height: 15),
            Container(
              width: width * 0.87,
              height: height * 0.056,
              decoration: ShapeDecoration(
                  color: Color(0xfff8f8f8),
                  shape: StadiumBorder()
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6),
                  prefixIcon: Icon(Icons.search, size: 18),
                  hintText: '리뷰를 작성한 식당명을 검색해보세요.',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xffa2a2a2)
                  ),
                  border: InputBorder.none,
                ),
              ),
            ), // 검색창
            SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          width: width,
                          padding: EdgeInsets.fromLTRB(30,12,30,20),
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
            ), // 리뷰
          ],
        )
    );
  }
}

