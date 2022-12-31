import 'package:get/get.dart';

class FilterPageController extends GetxController {

  static FilterPageController get to => Get.find();

  List<bool> FilterSelected = [false, false, false, false, false].obs;
  List<bool> OuterSelected = [false, false, false, false, false].obs; // 어떤 outerfilter가 눌렸는지
  RxInt CurrentOuterIndex = 5.obs; // inner filter 만드려구

  void ChangeCurrentOuterIndex(int index) {
    CurrentOuterIndex.value = index;
  }
  void ChangeOuterSelected(int index, bool selected) {
    OuterSelected[index] = selected;
  }
  void EraseOuterSelected() {
    for (int i = 0; i < OuterSelected.length; i++)
      ChangeOuterSelected(i, false);
  }



  List<bool> SwitchSelected = [false, false, false, false, false].obs;
  List<bool> OuterFoodSelected = [false, false, false, false, false, false, false].obs; // 한식, 중식 ~
  List<bool> OuterCafeSelected = [false, false].obs;
  List<bool> OuterAlcoholSelected = [false, false, false, false, false].obs;
  List<bool> OuterServiceSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false].obs;
  List<bool> OuterMoodSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false].obs;

  void ChangeOuterFoodSelected(int index, bool selected) {
    OuterFoodSelected[index] = selected;
  }
  void SwitchOuterFoodSelected() {
    if (SwitchSelected[0] == true)
      for (int i = 0; i < OuterFoodSelected.length; i++)
        ChangeOuterFoodSelected(i, true);
    if (SwitchSelected[0] == false)
      for (int i = 0; i < OuterFoodSelected.length; i++)
        ChangeOuterFoodSelected(i, false);
  }
  void FixOuterFoodSelected() {
    if (OuterFoodSelected.contains(true))
      FilterSelected[0] = true;
    else
      FilterSelected[0] = false;
  }

  void ChangeOuterCafeSelected(int index, bool selected) {
    OuterCafeSelected[index] = selected;
  }
  void SwitchOuterCafeSelected() {
    if (SwitchSelected[1] == true)
      for (int i = 0; i < OuterCafeSelected.length; i++)
        ChangeOuterCafeSelected(i, true);
    if (SwitchSelected[1] == false)
      for (int i = 0; i < OuterCafeSelected.length; i++)
        ChangeOuterCafeSelected(i, false);
  }
  void FixOuterCafeSelected() {
    if (OuterCafeSelected.contains(true))
      FilterSelected[1] = true;
    else
      FilterSelected[1] = false;
  }

  void ChangeOuterAlcoholSelected(int index, bool selected) {
    OuterAlcoholSelected[index] = selected;
  }
  void SwitchOuterAlcoholSelected() {
    if (SwitchSelected[2] == true)
      for (int i = 0; i < OuterAlcoholSelected.length; i++)
        ChangeOuterAlcoholSelected(i, true);
    if (SwitchSelected[2] == false)
      for (int i = 0; i < OuterAlcoholSelected.length; i++)
        ChangeOuterAlcoholSelected(i, false);
  }
  void FixOuterAlcoholSelected() {
    if (OuterAlcoholSelected.contains(true))
      FilterSelected[2] = true;
    else
      FilterSelected[2] = false;
  }

  void ChangeOuterServiceSelected(int index, bool selected) {
    OuterServiceSelected[index] = selected;
  }
  void SwitchOuterServiceSelected() {
    if (SwitchSelected[3] == true)
      for (int i = 0; i < OuterServiceSelected.length; i++)
        ChangeOuterServiceSelected(i, true);
    if (SwitchSelected[3] == false)
      for (int i = 0; i < OuterServiceSelected.length; i++)
        ChangeOuterServiceSelected(i, false);
  }
  void FixOuterServiceSelected() {
    if (OuterServiceSelected.contains(true))
      FilterSelected[3] = true;
    else
      FilterSelected[3] = false;
  }

  void ChangeOuterMoodSelected(int index, bool selected) {
    OuterMoodSelected[index] = selected;
  }
  void SwitchOuterMoodSelected() {
    if (SwitchSelected[4] == true)
      for (int i = 0; i < OuterMoodSelected.length; i++)
        ChangeOuterMoodSelected(i, true);
    if (SwitchSelected[4] == false)
      for (int i = 0; i < OuterMoodSelected.length; i++)
        ChangeOuterMoodSelected(i, false);
  }
  void FixOuterMoodSelected() {
    if (OuterMoodSelected.contains(true))
      FilterSelected[4] = true;
    else
      FilterSelected[4] = false;
  }
}