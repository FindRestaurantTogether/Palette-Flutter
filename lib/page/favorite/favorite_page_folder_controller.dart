 import 'package:get/get.dart';

class FavoriteFolderPageController extends GetxController {

  RxList folderName = ['기본 폴더'].obs;
  RxList folderRestaurant = [[]].obs;

  void addFolder(String name) {
    folderName.add(name);
    folderRestaurant.add([]);
  }

  void editFolderName(int index, String name) {
    folderName[index] = name;
  }

  void removeFolder(int index) {
    folderName.removeAt(index);
    folderRestaurant.removeAt(index);
  }

}