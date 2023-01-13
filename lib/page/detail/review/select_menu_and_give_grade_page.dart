import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';                                                                            
import 'package:myapp/page/detail/review/write_reveiw_page_controller.dart';

class SelectMenuAndGiveGradePage extends StatefulWidget {

  final List<String> menuName;
  SelectMenuAndGiveGradePage({Key? key, required this.menuName}) : super(key: key);

  @override
  State<SelectMenuAndGiveGradePage> createState() => _SelectMenuAndGiveGradePageState(menuName: menuName);
}

class _SelectMenuAndGiveGradePageState extends State<SelectMenuAndGiveGradePage> {

  final List<String> menuName;
  _SelectMenuAndGiveGradePageState({required this.menuName});

  int selectedMenuIndex = 0;
  late String selectedMenu;

  int selectedGradeIndex = 5;
  late double selectedGrade;
  List<double> gradeList = [
    0.5,
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
    4.5,
    5.0
  ];

  final _TextEditingController = TextEditingController();
  final _WriteReviewPageController = WriteReviewPageController();
  late FixedExtentScrollController _FixedExtentScrollController;

  @override
  void initState() {
    _FixedExtentScrollController = FixedExtentScrollController(initialItem: 0);
    super.initState();
  }

  @override
  void dispose() {
    _FixedExtentScrollController.dispose();
    _TextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Obx(() {
      return _WriteReviewPageController.currentStep.value == 0
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: width * 0.8,
                  height: _WriteReviewPageController.currentStep.value == 0 ? height * 0.5 : height * 0.45,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '메뉴',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '선택',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Material(
                            color: Colors.transparent,
                            child: Container(
                              width: width * 0.65,
                              height: height * 0.04,
                              decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: Colors.grey.withOpacity(0.1)
                              ),
                              child: TextFormField(
                                controller: _TextEditingController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), // 메뉴 선택
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 0.2,
                              child: CupertinoPicker(
                                scrollController: _FixedExtentScrollController,
                                selectionOverlay: Container(), // CupertinoPickerDefaultSelectionOverlay(background: Color(0xfffff6f8).withOpacity(0.3)),
                                looping: true,
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedMenuIndex = index;
                                    selectedMenu = menuName[index];
                                  });
                                },
                                children: List.generate(menuName.length, (index) {
                                  final menu = menuName[index];
                                  final menuIsSelected = selectedMenuIndex == index;
                                  final menuColor = menuIsSelected ?  Color(0xfff42957) : Colors.black12;

                                  return  Center(
                                      child: Text(
                                        menu,
                                        style: TextStyle(
                                            color: menuColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),
                                      )
                                  );
                                }),
                              )
                            ),
                          ],
                        ),
                      ), // cupertino picker
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            print(selectedMenu);
                            _WriteReviewPageController.currentStep.value = 1;
                          },
                          child: Text(
                            '다음',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xfff42957),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ), // 다음 버튼
                    ],
                  ),
                ),
              )
            ],
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: width * 0.8,
                  height: height * 0.45,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedMenu,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ), // 메뉴 이름
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 0.2,
                              width: width,
                              child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return CupertinoPicker(
                                      scrollController: _FixedExtentScrollController,
                                      selectionOverlay: Container(),
                                      itemExtent: 40,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          selectedGradeIndex = index;
                                          selectedGrade = gradeList[index];
                                        });
                                      },
                                      children: List.generate(gradeList.length, (index) {
                                        final grade = gradeList[index];
                                        final gradeIsSelected = selectedGradeIndex == index;
                                        final gradeColor = gradeIsSelected ?  Color(0xfff42957) : Colors.black12;

                                        return  Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                for (var i=1; i<grade+1; i++) ... [
                                                  if (i-0.5 == grade)
                                                    Icon(Icons.star_half, color: gradeColor)
                                                  else
                                                    Icon(Icons.star, color: gradeColor)
                                                ],
                                                for (var i=5; i>grade; i--) ... [
                                                  if (i-0.5 != grade)
                                                    Icon(Icons.star_outline, color: gradeColor)
                                                ],
                                                SizedBox(width: 20),
                                                Text(
                                                  grade.toString(),
                                                  style: TextStyle(
                                                      color: gradeColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),
                                                ),
                                              ],
                                            )
                                        );
                                      }),
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      ), // cupertino picker
                      Column(
                        children: [
                          SizedBox(height: 15),
                          Container(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                print(selectedGrade);
                                Get.back();
                              },
                              child: Text(
                                '완료',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xfff42957),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), // 완료버튼
                    ],
                  ),
                ),
              )
            ],
          );
    });
  }
}
