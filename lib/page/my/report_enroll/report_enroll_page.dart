import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportEnrollPage extends StatefulWidget {
  ReportEnrollPage({Key? key}) : super(key: key);

  @override
  State<ReportEnrollPage> createState() => _ReportEnrollPageState();
}

class _ReportEnrollPageState extends State<ReportEnrollPage> {

  final _TextEditingController = TextEditingController();

  bool isReport = true;

  List<bool> ToggleSelected = [false, false, false];

  @override
  void dispose() {
    _TextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            SizedBox(height: height * 0.08),
            Container(
              child: Stack(
                children: [
                  Container(
                    height: 45,
                    child: Row(
                      children: [
                        SizedBox(width: 30),
                        Container(
                          width: 27,
                          height: 45,
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Get.back();
                            },
                            icon: Image.asset('assets/button_image/back_button.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    child: Center(
                      child: Text(
                        '오류 제보/식당 등록',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff464646)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), // 백 버튼과 오류 제보/식당 등록
            SizedBox(
              height: height * 0.024,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ExpandTapWidget(
                  onTap: () {
                    setState(() {
                      isReport = true;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.all(10),
                    decoration: isReport? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        '오류 제보',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isReport ? FontWeight.bold : null,
                          color: isReport ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
                ExpandTapWidget(
                  onTap: () {
                    setState(() {
                      isReport = false;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.all(10),
                    decoration: !isReport? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        "식당 등록",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: !isReport ? FontWeight.bold : null,
                          color: !isReport ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isReport) ... [ // 오류 제보
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '식당 이름',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: width * 0.87,
                height: height * 0.056,
                decoration: ShapeDecoration(
                    color: Color(0xfff8f8f8),
                    shape: StadiumBorder()
                ),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          Get.back();
                        },
                        icon: Image.asset('assets/button_image/search_button.png'),
                      ),
                    ),
                    Container(
                      width: width * 0.87 - 56,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 12, left: 3),
                          hintText: '오류 제보할 식당을 검색해주세요.',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffa2a2a2)
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '오류 내용',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: width * 0.87,
                height: height * 0.27,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Color(0xfff8f8f8),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(11),
                    hintText: '오류 내용을 상세하게 작성해주세요.',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffa2a2a2)
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: width * 0.816,
                height: height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
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
            ] else ... [ // 식당 등록
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '식당 이름',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ), // 식당 이름
              SizedBox(height: 20),
              Container(
                width: width * 0.87,
                height: height * 0.056,
                decoration: ShapeDecoration(
                    color: Color(0xfff8f8f8),
                    shape: StadiumBorder()
                ),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          Get.back();
                        },
                        icon: Image.asset('assets/button_image/search_button.png'),
                      ),
                    ),
                    Container(
                      width: width * 0.87 - 56,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 12, left: 3),
                          hintText: '등록할 식당 이름을 입력해주세요.',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xffa2a2a2)
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              ), // 등록할 식당 이름을 입력해주세요
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '식당 정보',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ), // 식당 정보
              SizedBox(height: 20),
              Container(
                width: width * 0.87,
                height: height * 0.27,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Color(0xfff8f8f8),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(11),
                    hintText: '식당 위치, 전화번호, 영업시간, 메뉴 등 정보를 자유롭게 입력해주세요.',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffa2a2a2)
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ), // 식당 위치, 전화번호, 영업시간, 메뉴 등 정보를 자유롭게 입력해주세요
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '식당 카테고리',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ), // 식당 카테고리
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 25,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ToggleSelected[0] = !ToggleSelected[0];
                              ToggleSelected[1] = false;
                              ToggleSelected[2] = false;
                            });
                          },
                          child: Text(
                            '음식',
                            style: TextStyle(color: ToggleSelected[0] ? Colors.white : Color(0xffa2a2a2), fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: ToggleSelected[0] ? Color(0xfff42957) : Color(0xfff8f8f8),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ), // 음식
                    SizedBox(width: 5),
                    Container(
                      width: 50,
                      height: 25,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ToggleSelected[1] = !ToggleSelected[1];
                              ToggleSelected[0] = false;
                              ToggleSelected[2] = false;
                            });
                          },
                          child: Text(
                            '카페',
                            style: TextStyle(color: ToggleSelected[1] ? Colors.white : Color(0xffa2a2a2), fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: ToggleSelected[1] ? Color(0xfff42957) : Color(0xfff8f8f8),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ), // 카페
                    SizedBox(width: 5),
                    Container(
                      width: 50,
                      height: 25,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ToggleSelected[2] = !ToggleSelected[2];
                              ToggleSelected[0] = false;
                              ToggleSelected[1] = false;
                            });
                          },
                          child: Text(
                            '술집',
                            style: TextStyle(color: ToggleSelected[2] ? Colors.white : Color(0xffa2a2a2), fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: ToggleSelected[2] ? Color(0xfff42957) : Color(0xfff8f8f8),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ) // 술집
                  ],
                ),
              ), // 토글 버튼
              SizedBox(height: 25),
              Container(
                width: width * 0.816,
                height: height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
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
              ), // 확인
            ]
          ],
        ),
      ),
    );
  }
}



