import 'package:get/get.dart';

class DialogPageController extends GetxController{

  RxInt currentIndex = 0.obs;

  void changeIndex(int index){
    currentIndex.value = index;
  }

  var AvatarImages = <String>['assets/login_image/food.png'].obs;
  var MapNames = <String>['나의 지도'].obs;
}
