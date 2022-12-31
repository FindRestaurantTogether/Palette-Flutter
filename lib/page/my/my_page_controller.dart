import 'package:get/get.dart';

class MyPageController extends GetxController{
  bool isLogin = false;
  bool get iL => isLogin;

  void isLoginChangeState(){
    isLogin = !isLogin;
    update();
  }

  bool alarmOn = true;
  bool get aO => alarmOn;

  void alarmOnChangeState(){
    alarmOn = !alarmOn;
    update();
  }
}