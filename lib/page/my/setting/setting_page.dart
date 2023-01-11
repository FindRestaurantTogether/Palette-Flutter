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
                    height: height * 0.082,
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
                  ),
                  Divider(height: 1),
                  Container(
                    height: height * 0.082,
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
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: () {},
                                icon: Image.asset('assets/button_image/front_button.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.082,
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
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: () {},
                                icon: Image.asset('assets/button_image/front_button.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Container(
                    height: height * 0.082,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '약간 및 정책',
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
                              width: 30,
                              height: 30,
                              child: IconButton(
                                onPressed: () {},
                                icon: Image.asset('assets/button_image/front_button.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.082,
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
                  ),
                  Divider(height: 1),
                  Container(
                    height: height * 0.082,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '로그아웃',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff464646)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Container(
                    height: height * 0.082,
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '회원 탈퇴',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffc6c6c6)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}

