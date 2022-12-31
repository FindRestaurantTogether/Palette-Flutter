import 'package:get/get.dart';

class MapPageController extends GetxController{
  bool bottomSheet = false;
  bool get bS => bottomSheet;

  void ChangeState(){
    bottomSheet = !bottomSheet;
    update();
  }
}
