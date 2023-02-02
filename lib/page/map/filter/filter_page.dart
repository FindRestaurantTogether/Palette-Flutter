import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/navermap/utils.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  final _FilterPageController = Get.put(FilterPageController());

  List<String> FilterList = ["음식", "카페", "술집", "서비스", "분위기"];
  List<String> FilterListFood = ["한식", "양식", "중식", "일식", "아시안", "멕시칸", "기타"];
  List<String> FilterListCafe = ["프랜차이즈", "개인"];
  List<String> FilterListAlcohol = ["주점", "호프", "와인", "이자카야", "칵테일/양주"];
  List<String> FilterListService = ["주차", "24시 영업", "포장", "예약", "애완동물 출입가능", "코스", "뷔페", "배달", "무한리필", "오마카세", "미슐랭", "콜키지", "룸"];
  List<String> FilterListMood = ["데이트", "가성비", "조용한", "친절한", "인스타", "깨끗한", "고급", "이색적인","혼밥", "단체", "다이어트", "뷰가 좋은", "방송 맛집"];

  var filter = new List.empty(growable: true);

  @override
  void dispose() {
    _FilterPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Obx(() {
      return Filter(_FilterPageController, width, height);
    });
  }

  // 음식, 카페, 술집, 서비스, 분위기 알약
  Widget Filter(FilterPageController Controller, double width, double height) {
    return Column(
        children: [
          Row(
            children: [
              SizedBox(width: width * 0.035),
              Expanded(
                child: Container(
                  height: 45,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    itemCount: FilterList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          SizedBox(width: width * 0.021),
                          Controller.OuterSelected[index]
                              ?  Controller.FilterSelected[index]
                                ? Container(
                                  width: width * 0.184,
                                  height: height * 0.04,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Controller.ChangeOuterSelected(index, false);
                                        Controller.ChangeCurrentOuterIndex(5);
                                      },
                                      child: Text(
                                        FilterList[index],
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xfff42957),
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          shape: StadiumBorder()
                                      )
                                  ),
                                )
                                : Container(
                                  width: width * 0.184,
                                  height: height * 0.04,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Controller.ChangeOuterSelected(index, false);
                                        Controller.ChangeCurrentOuterIndex(5);
                                      },
                                      child: Text(
                                        FilterList[index],
                                        style: TextStyle(color: Color(0xff787878), fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          shape: StadiumBorder()
                                      )
                                  ),
                                )
                              : Controller.FilterSelected[index]
                                ? Container(
                                  width: width * 0.184,
                                  height: height * 0.04,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Controller.EraseOuterSelected();
                                        Controller.ChangeOuterSelected(index, true);
                                        Controller.ChangeCurrentOuterIndex(index);
                                      },
                                      child: Text(
                                        FilterList[index],
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xfff42957),
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          shape: StadiumBorder()
                                      )
                                  ),
                                )
                                : Container(
                                  width: width * 0.184,
                                  height: height * 0.04,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Controller.EraseOuterSelected();
                                        Controller.ChangeOuterSelected(index, true);
                                        Controller.ChangeCurrentOuterIndex(index);
                                      },
                                      child: Text(
                                        FilterList[index],
                                        style: TextStyle(color: Color(0xff787878), fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          shape: StadiumBorder()
                                      )
                                  ),
                                ),
                        ],
                      ); // outer
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          // 음식, 카페, 술집, 서비스, 분위기 필터 밑에 뜨는거
          if (Controller.CurrentOuterIndex == 0) ... [FilterFood(Controller, width, height)],
          if (Controller.CurrentOuterIndex == 1) ... [FilterCafe(Controller, width, height)],
          if (Controller.CurrentOuterIndex == 2) ... [FilterAlcohol(Controller, width, height)],
          if (Controller.CurrentOuterIndex == 3) ... [FilterService(Controller, width, height)],
          if (Controller.CurrentOuterIndex == 4) ... [FilterMood(Controller, width, height)],
        ] // outer filter & inner filter
    );
  }

  // 음식, 카페, 술집, 서비스, 분위기 필터 밑에 뜨는거
  Widget FilterFood(FilterPageController Controller, double width, double height) {
    return Center(
      child: Container(
        width: width * 0.872,
        height: height * 0.17,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 22, right: 20),
        child: Column(
          children: [
            Container(
              height: height * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' 음식',
                    style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ' 전체 ',
                        style: TextStyle(color: Color(0xff787878), fontSize: 12),
                      ), // 전체 텍스트
                      Container(
                        // color: Colors.red,
                        width: width * 0.082,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                              activeColor: Color(0xfff42957),
                              value: Controller.SwitchSelected[0], // SwitchSelected 2번째 index 값에 따라
                              onChanged: (value) {
                                setState(() {
                                  Controller.SwitchSelected[0] = value; // SwitchSelected 2번째 index 값 바꿔주기
                                  Controller.FilterSelected[0] = value; // FilterSelected 바꿔줘서 outerfilter 색 칠해주기
                                  Controller.SwitchOuterFoodSelected(); // SwitchOuterAlcoholSelected 함수를 통해 모두 선택 또는 선택해제하기
                                });
                              }),
                        ),
                      ) // 스위치 버튼
                    ],
                  ),
                ],
              ),
            ), // 음식과 전체
            Container(
              height: height * 0.016,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    Controller.OuterFoodSelected[i]
                        ? Container(
                          width: 48,
                          child: OutlinedButton(
                              onPressed: () async {
                                setState(() {
                                  Controller.ChangeOuterFoodSelected(i, false);
                                  Controller.FixOuterFoodSelected();
                                });
                                filter = read_all();
                                Network network = Network(filter, '');
                                var store = await network.getJsonData();
                              }, // 필터가 눌렸음을 백에 알려줘야 함
                              child: Text(
                                FilterListFood[i],
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Color(0xfff42957),
                                  side: BorderSide(width: 1, color: Color(0xfff42957)),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  shape: StadiumBorder())),
                        ) // 눌렸을 때
                        : Container(
                          width: 48,
                          child: OutlinedButton(
                              onPressed: () async {
                                setState(() {
                                  Controller.ChangeOuterFoodSelected(i, true);
                                  Controller.FixOuterFoodSelected();
                                });
                                filter = read_all();
                                Network network = Network(filter, '');
                                var store = await network.getJsonData();
                              }, // 필터가 눌렸음을 백에 알려줘야 함
                              child: Text(
                                FilterListFood[i],
                                style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Color(0xfffff6f8),
                                  side: BorderSide(width: 1, color: Color(0xfff42957)),
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  shape: StadiumBorder()
                              )
                          ),
                        ), // 안 눌렸을 때
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 한식 ~ 일식
                  for (int i = 4; i < 5; i++) ...[
                    Controller.OuterFoodSelected[i]
                        ? Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterFoodSelected(i, false);
                              Controller.FixOuterFoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListFood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterFoodSelected(i, true);
                              Controller.FixOuterFoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListFood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder()
                          )
                      ),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ] // 아시안
                ],
              ),
            ), // 첫째줄 필터
            Container(
              height: height * 0.01,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 5; i < 6; i++) ...[
                    Controller.OuterFoodSelected[i]
                        ? Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterFoodSelected(i, false);
                              Controller.FixOuterFoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListFood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ) // 눌려졌을 때 필터
                        : Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterFoodSelected(i, true);
                              Controller.FixOuterFoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListFood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ), // 안 눌려졌을 때 필터
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 멕시칸
                  for (int i = 6; i < FilterListFood.length; i++) ...[
                    Controller.OuterFoodSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterFoodSelected(i, false);
                              Controller.FixOuterFoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListFood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterFoodSelected(i, true);
                              Controller.FixOuterFoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListFood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ] // 기타
                ],
              ),
            ), // 둘째줄 필터
          ],
        ), // innerfilter 박스 내 내용물
      ),
    );
  }
  Widget FilterCafe(FilterPageController Controller, double width, double height) {
    return Center(
      child: Container(
        width: width * 0.872,
        height: height * 0.13,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 22, right: 20),
        child: Column(
          children: [
            Container(
              height: height * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' 카페',
                    style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ' 전체 ',
                        style: TextStyle(color: Color(0xff787878), fontSize: 12),
                      ), // 전체 텍스트
                      Container(
                        // color: Colors.red,
                        width: width * 0.082,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                              activeColor: Color(0xfff42957),
                              value: Controller.SwitchSelected[1], // SwitchSelected 2번째 index 값에 따라
                              onChanged: (value) {
                                setState(() {
                                  Controller.SwitchSelected[1] = value; // SwitchSelected 2번째 index 값 바꿔주기
                                  Controller.FilterSelected[1] = value; // FilterSelected 바꿔줘서 outerfilter 색 칠해주기
                                  Controller.SwitchOuterCafeSelected(); // SwitchOuterAlcoholSelected 함수를 통해 모두 선택 또는 선택해제하기
                                });
                              }),
                        ),
                      ) // 스위치 버튼
                    ],
                  ),
                ],
              ),
            ), // 카페 전체
            Container(
              height: height * 0.016,
            ), // 빈공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 1; i++) ...[
                    Controller.OuterCafeSelected[i]
                        ? Container(
                      width: 72,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterCafeSelected(i, false);
                              Controller.FixOuterCafeSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListCafe[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 74,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterCafeSelected(i, true);
                              Controller.FixOuterCafeSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListCafe[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 프랜차이즈
                  for (int i = 1; i < 2; i++) ...[
                    Controller.OuterCafeSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterCafeSelected(i, false);
                              Controller.FixOuterCafeSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListCafe[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterCafeSelected(i, true);
                              Controller.FixOuterCafeSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListCafe[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ] // 개인
                ],
              ),
            ), // 필터
          ],
        ), // innderfilter 박스 내 내용물
      ),
    );
  }
  Widget FilterAlcohol(FilterPageController Controller, double width, double height) {
    return Center(
      child: Container(
        width: width * 0.872,
        height: height * 0.17,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 22, right: 22),
        child: Column(
          children: [
            Container(
              height: height * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' 술집',
                    style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ' 전체 ',
                        style: TextStyle(color: Color(0xff787878), fontSize: 12),
                      ), // 전체 텍스트
                      Container(
                        // color: Colors.red,
                        width: width * 0.082,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                              activeColor: Color(0xfff42957),
                              value: Controller.SwitchSelected[2], // SwitchSelected 2번째 index 값에 따라
                              onChanged: (value) {
                                setState(() {
                                  Controller.SwitchSelected[2] = value; // SwitchSelected 2번째 index 값 바꿔주기
                                  Controller.FilterSelected[2] = value; // FilterSelected 바꿔줘서 outerfilter 색 칠해주기
                                  Controller.SwitchOuterAlcoholSelected(); // SwitchOuterAlcoholSelected 함수를 통해 모두 선택 또는 선택해제하기
                                });
                              }),
                        ),
                      ) // 스위치 버튼
                    ],
                  ),
                ],
              ),
            ), // 술집 전체
            Container(
              height: height * 0.016,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 3; i++) ...[
                    Controller.OuterAlcoholSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterAlcoholSelected(i, false);
                              Controller.FixOuterAlcoholSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListAlcohol[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterAlcoholSelected(i, true);
                              Controller.FixOuterAlcoholSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListAlcohol[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 주점 ~ 와인
                  for (int i = 3; i < 4; i++) ...[
                    Controller.OuterAlcoholSelected[i]
                        ? Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterAlcoholSelected(i, false);
                              Controller.FixOuterAlcoholSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListAlcohol[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterAlcoholSelected(i, true);
                              Controller.FixOuterAlcoholSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListAlcohol[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ] // 이자카야
                ],
              ),
            ), // 첫째줄 필터
            Container(
              height: height * 0.01,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 4; i < FilterListAlcohol.length; i++) ...[
                    Controller.OuterAlcoholSelected[i]
                        ? Container(
                      width: 78,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterAlcoholSelected(i, false);
                              Controller.FixOuterAlcoholSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListAlcohol[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 78,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterAlcoholSelected(i, true);
                              Controller.FixOuterAlcoholSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListAlcohol[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 칵테일/양주
                ],
              ),
            ), // 둘째줄 필터
          ],
        ), // innderfilter 박스 내 내용물
      ),
    );
  }
  Widget FilterService(FilterPageController Controller, double width, double height) {
    return Center(
      child: Container(
        width: width * 0.872,
        height: height * 0.25,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 22, right: 22),
        child: Column(
          children: [
            Container(
              height: height * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' 서비스',
                    style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ' 전체 ',
                        style: TextStyle(color: Color(0xff787878), fontSize: 12),
                      ), // 전체 텍스트
                      Container(
                        // color: Colors.red,
                        width: width * 0.082,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                              activeColor: Color(0xfff42957),
                              value: Controller.SwitchSelected[3], // SwitchSelected 2번째 index 값에 따라
                              onChanged: (value) {
                                setState(() {
                                  Controller.SwitchSelected[3] = value; // SwitchSelected 2번째 index 값 바꿔주기
                                  Controller.FilterSelected[3] = value; // FilterSelected 바꿔줘서 outerfilter 색 칠해주기
                                  Controller.SwitchOuterServiceSelected(); // SwitchOuterAlcoholSelected 함수를 통해 모두 선택 또는 선택해제하기
                                });
                              }),
                        ),
                      ) // 스위치 버튼
                    ],
                  ),
                ],
              ),
            ), // 서비스 & 전체
            Container(
              height: height * 0.016,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 1; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 주차
                  for (int i = 1; i < 2; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 80,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 74,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 24시 영업
                  for (int i = 2; i < 4; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: width * 0.13,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: width * 0.13,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 포장 예약
                ],
              ),
            ), // 첫째줄 필터
            Container(
              height: height * 0.01,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 4; i < 5; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 104,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 104,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 애완동물 출입가능
                  for (int i = 5; i < 8; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ] // 코스, 뷔페, 배달
                ],
              ),
            ), // 두번째줄 필터
            Container(
              height: height * 0.01,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 8; i < 10; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 무한리필, 오마카세
                  for (int i = 10; i < 12; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 미슐랭, 콜키지
                ],
              ),
            ), // 세번째줄 필터
            Container(
              height: height * 0.01,
            ), // 빈 공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 12; i < FilterListService.length; i++) ...[
                    Controller.OuterServiceSelected[i]
                        ? Container(
                      width: 40,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, false);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 40,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterServiceSelected(i, true);
                              Controller.FixOuterServiceSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListService[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 룸
                ],
              ),
            ), // 네번째줄 필터
          ],
        ), // innerfilter 박스 내 내용물
      ),
    );
  }
  Widget FilterMood(FilterPageController Controller, double width, double height) {
    return Center(
      child: Container(
        width: width * 0.872,
        height: height * 0.25,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 22, right: 22),
        child: Column(
          children: [
            Container(
              height: height * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' 분위기',
                    style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        ' 전체 ',
                        style: TextStyle(color: Color(0xff787878), fontSize: 12),
                      ), // 전체 텍스트
                      Container(
                        // color: Colors.red,
                        width: width * 0.082,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                              activeColor: Color(0xfff42957),
                              value: Controller.SwitchSelected[4], // SwitchSelected 2번째 index 값에 따라
                              onChanged: (value) {
                                setState(() {
                                  Controller.SwitchSelected[4] = value; // SwitchSelected 2번째 index 값 바꿔주기
                                  Controller.FilterSelected[4] = value; // FilterSelected 바꿔줘서 outerfilter 색 칠해주기
                                  Controller.SwitchOuterMoodSelected(); // SwitchOuterAlcoholSelected 함수를 통해 모두 선택 또는 선택해제하기
                                });
                              }),
                        ),
                      ) // 스위치 버튼
                    ],
                  ),
                ],
              ),
            ), // 분위기 전체
            Container(
              height: height * 0.016,
            ), // 빈공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 데이트 ~ 친절한
                ],
              ),
            ), // 첫번째필터
            Container(
              height: height * 0.01,
            ), // 빈공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 4; i < 6; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 56,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 인스타, 깨끗한
                  for (int i = 6; i < 7; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 고급
                  for (int i = 7; i < 8; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 이색적인
                ],
              ),
            ), // 두번째 필터
            Container(
              height: height * 0.01,
            ), // 빈공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 8; i < 10; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 48,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 혼밥, 단체
                  for (int i = 10; i < 11; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 64,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 다이어트
                  for (int i = 11; i < 12; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 70,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 70,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 뷰가 좋은
                ],
              ),
            ), // 세번째 필터
            Container(
              height: height * 0.01,
            ), // 빈공간
            Container(
              height: height * 0.03,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 12; i < FilterListService.length; i++) ...[
                    Controller.OuterMoodSelected[i]
                        ? Container(
                      width: 70,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, false);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                        : Container(
                      width: 70,
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              Controller.ChangeOuterMoodSelected(i, true);
                              Controller.FixOuterMoodSelected();
                            });
                            filter = read_all();
                            Network network = Network(filter, '');
                            var store = await network.getJsonData();
                          },
                          child: Text(
                            FilterListMood[i],
                            style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfffff6f8),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(
                      width: width * 0.016,
                    ),
                  ], // 방송 맛집
                ],
              ),
            ), // 네번째 필터
          ],
        ), // innerfilter 박스 내 내용물
      ),
    );
  }
}
