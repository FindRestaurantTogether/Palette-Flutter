import 'package:get/get.dart';

class FilterPageController extends GetxController {

  static FilterPageController get to => Get.find();

  // 음식, 카페, 술집, 서비스, 분위기 중 어떤 필터가 눌렸는지
  List<bool> OuterSelected = [false, false, false, false, false].obs;
  // 음식, 카페, 술집, 서비스, 분위기 중 현재 선택된 필터 인덱스
  RxInt CurrentOuterIndex = 5.obs;
  // 음식, 카페, 술집, 서비스, 분위기 중 어떤 필터가 선택되어 빨간색으로 버튼으로 바뀌었는지
  List<bool> FilterSelected = [false, false, false, false, false].obs;

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


  // 음식, 카페, 술집, 서비스, 분위기 전체선택 여부
  List<bool> SwitchSelected = [false, false, false, false, false].obs;
  // 한식, 양식, 중식, 일식, 베트남, 멕시칸, 기타 선택 여부
  List<bool> OuterFoodSelected = [false, false, false, false, false, false, false].obs; // 한식, 중식 ~
  // 프랜차이즈, 개인 선택 여부
  List<bool> OuterCafeSelected = [false, false].obs;
  // 주점, 호프, 와인, 이자카야, 칵테일/양주 선택 여부
  List<bool> OuterAlcoholSelected = [false, false, false, false, false].obs;
  // 주차, 24시 영업, 포장, 예약, 애완동물 출입가능, 코스, 뷔페, 배달, 무한리필, 오마카세, 미슐랭, 콜키지, 룸 선택 여부
  List<bool> OuterServiceSelected = [false, false, false, false, false, false, false, false, false, false, false, false, false].obs;
  // 데이트, 가성비, 조용한, 친절한, 인스타, 깨끗한, 고급, 이색적인, 혼밥, 단체, 다이어트, 뷰가 좋은, 방송 맛집 선택 여부
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