import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/review/write_reveiw_page_controller.dart';

class WriteReviewPage2 extends StatefulWidget {
  WriteReviewPage2({Key? key}) : super(key: key);

  @override
  State<WriteReviewPage2> createState() => _WriteReviewPage2State();
}

class _WriteReviewPage2State extends State<WriteReviewPage2> {

  final _WriteReviewPageController = Get.put(WriteReviewPageController());

  @override
  void dispose() {
    _WriteReviewPageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final _selectedRestaurant = Get.arguments[0];
    final menuCardList = Get.arguments[1];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            width: width,
            height: 230,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 50),
                Stack(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width: 30),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Center(
                        child: Container(
                          child: Text(
                            '${_selectedRestaurant.name} 평가하기',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ), // 음식점 이름과 뒤로가기 버튼
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: menuCardList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return menuCardList[index];
                      }
                  ),
                ),
              ],
            ),
          ), // top box
          if (_WriteReviewPageController.currentIndex.value == 0) ... [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                    Expanded(
                      child: Column(
                          children: [
                            SizedBox(height: 30),
                            Container(
                              width: 400,
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: Column(
                                children: [
                                  Container(
                                    width: Get.width * 0.9,
                                    height: 150,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10, left: 15),
                                      child: TextField(
                                        decoration: InputDecoration.collapsed(
                                          hintText: '주문한 메뉴 선택 후 리뷰를 작성해주세요.',
                                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ), // 글 쓰는 공간
                                  SizedBox(height: 8),
                                  Container(
                                    width: Get.width * 0.9,
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_photo_alternate,
                                            color: Colors.black54),
                                        SizedBox(width: 3),
                                        Text('사진 1장 이상 첨부 필수',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ), // 사진 한장 필수 문구
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 100,
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                width: 1,
                                                color: Colors.black26,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15)))),
                                          child: Text('+',
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w100)),
                                        ),
                                      ),
                                    ],
                                  ), // 사진 첨부 박스
                                ],
                              ),
                            ), // 메뉴 리뷰
                            SizedBox(height: 20),
                          ],
                        ),
                    ), // 리뷰 작성란
                    Column(
                      children: [
                        SizedBox(height: 15),
                        Container(
                          width: 400,
                          height: 50,
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => WriteReviewPage2(), arguments: [_selectedRestaurant, menuCardList]);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xfff42957),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                '완료',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              )
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ), // 완료 버튼
                  ],
                ),
              ),
            ),
          ]
          else ... [
            SizedBox(height: 10),
            Container(
              width: 400,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                    width: Get.width * 0.9,
                    height: 250,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: '주문한 메뉴 선택 후 리뷰를 작성해주세요.',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ),
                  ), // 글 쓰는 공간
                  SizedBox(height: 8),
                  Container(
                    width: Get.width * 0.9,
                    child: Row(
                      children: [
                        Icon(Icons.add_photo_alternate,
                            color: Color(0xfff42957)),
                        SizedBox(width: 3),
                        Text('사진 첨부',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12)),
                      ],
                    ),
                  ), // 사진 한장 필수 문구
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 100,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1,
                                color: Colors.black26,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15)))),
                          child: Text('+',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w100)),
                        ),
                      ),
                    ],
                  ), // 사진 첨부 박스
                ],
              ),
            ), // 메뉴 리뷰
            SizedBox(height: 25),
            Container(
              width: 400,
              height: 50,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  child: Text('완료')
              ),
            ), // 완료 버튼
          ]
        ],
      ),
    );
  }
}
