import 'package:get/get.dart';

class FolderPageController extends GetxController {

  // 지역 필터 열고 닫기
  RxBool openRegion = false.obs;

  // edit이나 share를 하는 state
  RxBool editShare = false.obs;

  // 결국 edit을 선택한거다
  RxBool checkEdit = false.obs;

  // 결국 share를 선택한거다
  RxBool checkShare = false.obs;

}