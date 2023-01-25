import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticePage extends StatefulWidget {
  NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {

  List<bool> noticeOpen = [false];
  List<String> noticeTitle = [
    "[공지] 이달의 업데이트 안내"
  ];
  List<String> noticeContent = [
    "1. 리뷰 필터 기능으로 '맛있다' 리뷰만 모아 확인해보세요.\n[소식] 탭 상단에 맛있다 / 괜찮다 / 별로 버튼이 생겼어요!\n이제 [맛있다] 평가를 받은 식당만 보고 싶을 땐\n상단의 [맛있다] 버튼을 눌러 확인해보세요!\n\n2. 도로명, 지번 주소 모두 확인 가능해요!\n이전 망고플레이트에선 지번 주소만 확인할 수 있었는데요.\n여러분의 편리성을 위해 도로명 주소도 함께 표기하기로 했어요.\n식당 페이지에서 도로명 주소와 지번 주소를\n한 눈에 확인해보세요!"
  ];

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
                children: [
                  SizedBox(width: 30),
                  Container(
                    width: 27,
                    height: 45,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Image.asset('assets/button_image/back_button.png'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '공지사항',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff464646)
                    ),
                  )
                ],
              ),
            ), // 백 버튼과 공지사항
            SizedBox(height: 15),
            Container(
              width: width,
              height: 4,
              color: Color(0xffeeeeee),
            ), // 회색 바
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: noticeOpen.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        height: height * 0.082,
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 35, right: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Row(
                              children: [
                                Text(
                                    '12/22',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xff7c7c7c)
                                    )
                                ),
                                SizedBox(width: 20),
                                Text(
                                  '[공지] 이달의 업데이트 안내',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff464646),
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      noticeOpen[0] = !noticeOpen[0];
                                    });
                                  },
                                  icon: noticeOpen[0]? Image.asset('assets/button_image/up_button.png') : Image.asset('assets/button_image/down_button.png')
                              ),
                            ),
                          ],
                        ),
                      ),
                      noticeOpen[index]
                        ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                          color: Color(0xfffff6f8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                noticeTitle[index],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                noticeContent[index],
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        )
                        : Divider(height: 1),
                    ],
                  );
                },
              ),
            )
          ],
        )
    );
  }
}

