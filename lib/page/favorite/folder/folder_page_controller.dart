import 'package:get/get.dart';

class FolderPageController extends GetxController {

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