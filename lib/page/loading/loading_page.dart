import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/tab/tab_page.dart';
import 'package:myapp/page/onboarding/onboarding.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // 1초동안 로딩화면 보여주고 TabPage로 넘어가기
    Timer(
      Duration(seconds: 1),
      () {
        Get.off(() => TabPage());
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xfff42957),
          ),
          child: Transform.scale(
            child: Image.asset(
              'assets/splash_image/splash_image.png'
            ),
            scale: 0.2,
          )
        ));
  }
}
