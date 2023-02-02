import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/my/account/account_page.dart';
import 'package:myapp/page/my/my_page_controller.dart';
import 'package:myapp/page/my/notice/notice_page.dart';
import 'package:myapp/page/my/report_enroll/report_enroll_page.dart';
import 'package:myapp/page/my/setting/setting_page.dart';
import 'package:myapp/page/my/signin/signin_page.dart';
import 'package:myapp/page/my/slider/first_slider_page.dart';
import 'package:myapp/page/my/slider/fourth_slider_page.dart';
import 'package:myapp/page/my/slider/second_slider_page.dart';
import 'package:myapp/page/my/slider/third_slider_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final _PageController = PageController(initialPage: 0);
  double _activePage = 0;

  final List<Widget> _pages = [
    FirstSliderPage(),
    SecondSliderPage(),
    ThirdSliderPage(),
    FourthSliderPage()
  ];

  User? loggedUser;
  String? loggedUserUid = '';
  String? loggedUserImageUrl = '';
  String? loggedUserName = '';
  String? loggedUserEmail = '';
  bool imageUploadLoading = false;
  void getLoggedUserData() async {
    try {
      setState(() {
        imageUploadLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedUser = user;
      }
      loggedUserUid = loggedUser?.uid;

      final loggedUserDoc =  await FirebaseFirestore.instance.collection('users').doc(loggedUserUid).get();
      setState(() {
        loggedUserImageUrl = loggedUserDoc.get('imageUrl');
        loggedUserName = loggedUserDoc.get('name');
        loggedUserEmail = loggedUserDoc.get('id');
      });
      setState(() {
        imageUploadLoading = false;
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoggedUserData();
  }


  @override
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
            GetBuilder<MyPageController>(
                builder: (_MyPageController) {
                  return _MyPageController.iL
                      ? Container(
                        padding: EdgeInsets.only(right: 25, left: 30, bottom: 20),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            SizedBox(height: 45),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '마이페이지',
                                  style: TextStyle(
                                      color: Color(0xff464646),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ), // 마이페이지
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => AccountPage());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Color(0xfff42957),
                                        child: imageUploadLoading
                                            ? CircleAvatar(
                                              radius: 33,
                                              backgroundColor: Colors.white,
                                              child: Center(child: CircularProgressIndicator(color: Color(0xfff42957)))
                                            )
                                            : CircleAvatar(
                                              radius: 33,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(loggedUserImageUrl!),
                                            ),
                                      ), // 원형 아바타
                                      SizedBox(width: 16),
                                      Center(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                loggedUserName!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16
                                                ),
                                              ), // 이름
                                              SizedBox(height: 3),
                                              Text(
                                                loggedUserEmail!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black54
                                                ),
                                              ) // 이메일
                                            ],
                                          ),
                                        ),
                                      ) // 이름 & 이메일
                                    ],
                                  ),
                                  Center(
                                    child: Container(
                                      child: Icon(Icons.arrow_forward_ios, size: 23),
                                    )
                                  ), // 버튼
                                ],
                              ),
                            ), // 상단 마이페이지 말고 나머지
                          ],
                        ),
                      )
                      : Container(
                        padding: EdgeInsets.only(right: 25, left: 30, bottom: 20),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            SizedBox(height: 45),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '마이페이지',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ), // 마이페이지
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => LoginPage());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Color(0xfff42957),
                                        child: CircleAvatar(
                                          radius: 33,
                                          backgroundColor: Colors.white,
                                          child: Image.asset('assets/folder_image/folder_palette.png'),
                                        ),
                                      ), // 원형 아바타
                                      SizedBox(width: 20),
                                      Center(
                                        child: Text(
                                          '로그인/회원가입 하기',
                                          style: TextStyle(
                                              color: Color(0xfff42957),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          ),
                                        ),
                                      ) // 로그인/회원가입 하기
                                    ],
                                  ),
                                  Center(
                                    child: Icon(Icons.arrow_forward_ios, size: 23, color: Color(0xfff42957)),
                                  ), // 옆에 이름&아이디와 버튼
                                ],
                              ),
                            ), // 상단 마이페이지 말고 나머지
                          ],
                        ),
                      );
                }
            ), // 상단 페이지
            Container(
              width: width,
              height: 6,
              color: Colors.black12,
            ), // 회색 바
            SizedBox(height: height * 0.015), // 빈 공간
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        width: width * 0.87,
                        height: height * 0.21,
                        padding: EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 1.8,
                              blurRadius: 9,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.card_giftcard, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      '이벤트',
                                      style: TextStyle(
                                          color: Color(0xff464646),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),
                                    )
                                  ],
                                ),
                                DotsIndicator(
                                  dotsCount: _pages.length,
                                  position: _activePage,
                                  decorator: DotsDecorator(
                                      size: Size.square(10),
                                      activeSize: Size(18, 10),
                                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                      activeColor: Color(0xfff42957),
                                      color: Color(0xffd9d9d9)
                                  ),
                                )
                              ],
                            ), // 이벤트 아이콘과 텍스트
                            SizedBox(height: 7),
                            Container(
                                height: height * 0.11,
                                decoration: BoxDecoration(
                                  color: Color(0xffd9d9d9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: PageView.builder(
                                  controller: _PageController,
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _activePage = page.toDouble();
                                    });
                                  },
                                  itemCount: _pages.length,
                                  pageSnapping: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _pages[index % _pages.length];
                                  },
                                )
                            )
                          ],
                        ),
                      ), // 이벤트
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ReportEnrollPage());
                        },
                        child: Container(
                          width: width * 0.87,
                          height: height * 0.055,
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                spreadRadius: 1.8,
                                blurRadius: 9,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_amber_outlined, size: 20),
                              SizedBox(width: 10),
                              Text(
                                '오류 제보 및 식당 등록',
                                style: TextStyle(
                                    color: Color(0xff464646),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              )
                            ],
                          ),
                        ),
                      ), // 오류 제보 및 식당 등록
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => NoticePage());
                        },
                        child: Container(
                          width: width * 0.87,
                          height: height * 0.055,
                          padding: EdgeInsets.only(top: 10,bottom: 10,left: 17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                spreadRadius: 1.8,
                                blurRadius: 9,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.volume_up_outlined, size: 20),
                              SizedBox(width: 10),
                              Text(
                                '공지사항',
                                style: TextStyle(
                                    color: Color(0xff464646),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              )
                            ],
                          ),
                        ),
                      ), // 공지사항
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SettingPage());
                        },
                        child: Container(
                          width: width * 0.87,
                          height: height * 0.055,
                          padding: EdgeInsets.only(top: 10,bottom: 10,left: 17),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                spreadRadius: 1.8,
                                blurRadius: 9,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.settings_outlined, size: 20),
                              SizedBox(width: 10),
                              Text(
                                '설정',
                                style: TextStyle(
                                    color: Color(0xff464646),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),
                              )
                            ],
                          ),
                        ),
                      ), // 설정
                    ],
                  ),
                ),
              ),
            ) // 이벤트, 오류제보 등등
          ],
        )
    );
  }
}
