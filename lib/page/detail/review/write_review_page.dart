import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/review/write_reveiw_page_controller.dart';

class WriteReviewPage extends StatefulWidget {
  WriteReviewPage({Key? key}) : super(key: key);

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {

  final Controller = Get.put(WriteReviewPageController());

  List<Widget> menuCardList = [];

  Widget menuCard() {
    return Column(
      children: [
        Center(
          child: Container(
            width: Get.width * 0.8,
            height: 40,
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(
                  width: 1.5,
                  color: Colors.black12,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '모든 사시미',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: 30),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: 5,
                      itemCount: 5,
                      itemSize: 15,
                      itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                      direction: Axis.horizontal,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '5.0',
                      style: TextStyle(
                          fontSize: 13
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 15,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ); // 카드 하나
  }

  void addMenu() {
    setState(() {
      menuCardList.add(menuCard());
    });
  }

  // void deleteMenu(index) {
  //   setState(() {
  //     menuCardList.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
              width: Get.width,
              height: 210,
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
                      SizedBox(width: 28),
                      Container(
                        child: Text(
                          '리뷰 작성하기',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ), // 음식점 이름과 뒤로가기 버튼
                  SizedBox(height: 3),
                  Text(
                    '메뉴 리뷰, 매장 리뷰 한 개 이상 작성해주세요.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ), // 작성 설명
                  SizedBox(height: 15),
                  Container(
                    width: 270,
                    height: 50,
                    padding: EdgeInsets.all(5),
                    decoration: ShapeDecoration(
                      color: Colors.black12,
                      shape: StadiumBorder()
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Controller.changeIndex(0);
                            });
                          },
                          child: Controller.currentIndex == 0 ?
                            Container(
                            width: 130,
                            height: 45,
                            decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: StadiumBorder()
                            ),
                            child: Center(
                              child: Text(
                                '메뉴',
                                style: TextStyle(
                                  color: Colors.black
                                ),
                              ),
                            ),
                          )
                            : Container(
                                width: 130,
                                height: 45,
                                decoration: ShapeDecoration(
                                    shape: StadiumBorder()
                                ),
                                child: Center(
                                  child: Text(
                                    '메뉴',
                                    style: TextStyle(
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Controller.changeIndex(1);
                            });
                          },
                          child: Controller.currentIndex == 1 ?
                              Container(
                                width: 130,
                                height: 45,
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: StadiumBorder()
                                ),
                                child: Center(
                                  child: Text(
                                    '매장',
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              )
                              : Container(
                                  width: 130,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                      shape: StadiumBorder()
                                  ),
                                  child: Center(
                                    child: Text(
                                      '매장',
                                      style: TextStyle(
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ), // top box
            SizedBox(height: 20),
            if (Controller.currentIndex.value == 0) ... [
              Expanded( ///////
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
              SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  addMenu();
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: Colors.grey
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ), // 더하기 버튼
              SizedBox(height: 12),
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
              SizedBox(height: 15),
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
