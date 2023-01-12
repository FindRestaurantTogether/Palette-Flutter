import 'package:get/get.dart';

class WriteReviewPageController extends GetxController{
  static WriteReviewPageController get to => Get.find();

  RxInt currentIndex = 0.obs; // 메뉴(0) or 매장(1)

  void changeIndex(int index){
    currentIndex.value = index;
  }

  RxInt currentStep = 0.obs; // 메뉴 선택(0) or 별점 매기기(1)

}
