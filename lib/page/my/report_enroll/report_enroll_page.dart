import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportEnrollPage extends StatefulWidget {
  ReportEnrollPage({Key? key}) : super(key: key);

  @override
  State<ReportEnrollPage> createState() => _ReportEnrollPageState();
}

class _ReportEnrollPageState extends State<ReportEnrollPage> {

  final textController = TextEditingController();

  bool isReport = true;

  late List<bool> ToggleSelected;

  @override
  void initState() {
    ToggleSelected = [false, false, false];
    super.initState();
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
              height: 50,
              child: Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: (){
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black54,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      '오류 제보/식당 등록',
                      style: TextStyle(
                        color: Color(0xff464646),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ), // 오류 제보/식당 등록
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
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    prefixIcon: Icon(Icons.search, size: 18),
                    hintText: '오류 제보할 식당을 검색해주세요.',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xffa2a2a2)
                    ),
                    border: InputBorder.none,
                  ),
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
              ),
              SizedBox(height: 20),
              Container(
                width: width * 0.87,
                height: height * 0.056,
                decoration: ShapeDecoration(
                    color: Color(0xfff8f8f8),
                    shape: StadiumBorder()
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    prefixIcon: Icon(Icons.search, size: 18),
                    hintText: '오류 제보할 식당을 검색해주세요.',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffa2a2a2)
                    ),
                    border: InputBorder.none,
                  ),
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
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 37),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 25,
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            '음식',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(width: 3),
                    Container(
                      width: 50,
                      height: 25,
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            '카페',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    ),
                    SizedBox(width: 3),
                    Container(
                      width: 50,
                      height: 25,
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            '술집',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xfff42957),
                              side: BorderSide(width: 1, color: Color(0xfff42957)),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              shape: StadiumBorder())),
                    )
                  ],
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
            ]
          ],
        ),
      ),
    );
  }
}



