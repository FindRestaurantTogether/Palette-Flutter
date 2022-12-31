import 'package:get/get.dart';

class DialogPageController extends GetxController{
  static DialogPageController get to => Get.find();

  RxInt currentIndex = 0.obs;

  void changeIndex(int index){
    currentIndex.value = index;
  }

  var AvatarImages = <String>['assets/login_image/food.png'].obs;
  var MapNames = <String>['나의 지도'].obs;
}
