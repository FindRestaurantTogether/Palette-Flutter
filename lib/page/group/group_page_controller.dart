import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/group/group_page_model.dart';

class GroupPageController extends GetxController {

  var groups = <groupModel>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchData();
  // }
  //
  // void fetchData() async{
  //   await Future.delayed(Duration(seconds: 1));
  //   List<groupModel> groupData = [
  //     groupModel(
  //         groupName: '서초동 맛집',
  //         groupCheckCalender: true,
  //         groupDate: '2022년 11월 11일',
  //         groupCheckAlarm: true,
  //         groupFriendsList: [
  //           friendModel(image: 'assets/login_image/food.png', name: '김학현', selected: false),
  //           friendModel(image: 'assets/login_image/food.png', name: '유환규', selected: false),
  //           friendModel(image: 'assets/login_image/food.png', name: '김현중', selected: false),
  //         ]
  //     ),
  //   ];
  //
  //   groups.assignAll(groupData);
  // }

  var selectedDate = DateTime.now().obs;
  void chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: selectedDate.value,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 3),
        cancelText: '취소'
    );

    if (pickedDate != null && pickedDate != selectedDate.value){
      selectedDate.value = pickedDate;
    }
  }

}


