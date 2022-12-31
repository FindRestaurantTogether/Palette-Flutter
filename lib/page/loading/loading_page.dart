import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/onboarding/onboarding.dart';
import 'package:myapp/page/tab/tab_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
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
            scale: 0.25,
          )
        ));
  }
}
