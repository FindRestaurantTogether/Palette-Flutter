import 'package:get/get.dart';

class MyPageController extends GetxController{

  RxString loggedUserUid = ''.obs;
  RxString loggedUserImageUrl = ''.obs;
  RxString loggedUserName = ''.obs;
  RxString loggedUserEmail = ''.obs;

  RxBool isLogin = false.obs;

  bool alarmOn = true;
  bool get aO => alarmOn;

  void alarmOnChangeState(){
    alarmOn = !alarmOn;
    update();
  }
}