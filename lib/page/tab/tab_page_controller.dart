import 'package:get/get.dart';

class TabPageController extends GetxService{
  static TabPageController get to => Get.find();

  RxInt CurrentTab = 0.obs;

  void ChangeTab(int tab){
    CurrentTab.value = tab;
  }
}
