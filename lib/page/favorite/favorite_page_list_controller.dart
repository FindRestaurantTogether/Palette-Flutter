import 'package:get/get.dart';

class FavoriteListPageController extends GetxController {

  // 지역 필터 열고 닫기
  bool openRegion = false;
  bool get oR => openRegion;

  void openRegionChangeState(){
    openRegion = !openRegion;
    update();
  }

  RxList listRestaurant = [].obs;
  RxList listRestaurantIsChecked = [].obs;

  // edit이나 share를 하는 state
  bool editShare = false;
  bool get eS => editShare;

  void editShareChangeState(){
    editShare = !editShare;
    update();
  }

  // 결국 edit을 선택한거다
  bool checkEdit = false;
  bool get cE => checkEdit;

  void checkEditChangeState(){
    checkEdit = !checkEdit;
    update();
  }

  // 결국 share를 선택한거다
  bool checkShare = false;
  bool get cS => checkShare;

  void checkShareChangeState(){
    checkShare = !checkShare;
    update();
  }

}