import 'package:get/get.dart';

class WriteReviewPageController extends GetxController{
  static WriteReviewPageController get to => Get.find();

  RxInt currentIndex = 0.obs;

  void changeIndex(int index){
    currentIndex.value = index;
  }
}
