import 'package:get/get.dart';

class DetailPageController extends GetxController{
  bool moreInformation = false;
  bool get mI => moreInformation;

  void changeState(){
    moreInformation = !moreInformation;
    update();
  }
}