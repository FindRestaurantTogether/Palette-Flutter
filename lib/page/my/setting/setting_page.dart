import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/my/my_page_controller.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  Future<void> deleteUser(String email) async{
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  } // 유저 삭제

  final _MyPageController = Get.put(MyPageController());

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
                    '설정',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff464646)
                    ),
                  )
                ],
              ),
            ), // 백 버튼과 설정
            SizedBox(height: 15),
            Container(
              width: width,
              height: 4,
              color: Color(0xffeeeeee),
            ), // 회색 바
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '알림 설정',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff464646)
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                                value: _MyPageController.aO,
                                onChanged: (value) {
                                  setState(() {
                                    _MyPageController.alarmOnChangeState();
                                  });
                                },
                                activeColor: Color(0xfff42957),
                            ),
                          ),
                        ) // 스위치 버튼,
                      ],
                    ),
                  ), // 알림 설정
                  Divider(height: 1),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '고객센터',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff464646)
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/button_image/front_button.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // 고객센터
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '도움말',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff464646)
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/button_image/front_button.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // 도움말
                  Divider(height: 1),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '약관 및 정책',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff464646)
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/button_image/front_button.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // 약관 및 정책
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '버전 정보',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff464646)
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1.0',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff464646)
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ), // 버전 정보
                ],
              ),
            )
          ],
        )
    );
  }
}

