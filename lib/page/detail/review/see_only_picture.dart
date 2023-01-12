import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeOnlyPicturePage extends StatefulWidget {
  SeeOnlyPicturePage({Key? key}) : super(key: key);

  @override
  State<SeeOnlyPicturePage> createState() => _SeeOnlyPicturePageState();
}

class _SeeOnlyPicturePageState extends State<SeeOnlyPicturePage> {

  int whichGrid = 0;

  @override
  Widget build(BuildContext context) {

    final selectedRestaurant = Get.arguments;

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
                        "'${selectedRestaurant.name}' 사진",
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
                      whichGrid = 0;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.3333333,
                    padding: EdgeInsets.all(10),
                    decoration: whichGrid == 0 ? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        '전체',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: whichGrid == 0 ? FontWeight.bold : null,
                          color: whichGrid == 0 ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
                ExpandTapWidget(
                  onTap: () {
                    setState(() {
                      whichGrid = 1;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.3333333,
                    padding: EdgeInsets.all(10),
                    decoration: whichGrid == 1 ? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        '메뉴',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: whichGrid == 1 ? FontWeight.bold : null,
                          color: whichGrid == 1 ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
                ExpandTapWidget(
                  onTap: () {
                    setState(() {
                      whichGrid = 2;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.3333333,
                    padding: EdgeInsets.all(10),
                    decoration: whichGrid == 2 ? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        '매장',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: whichGrid == 2 ? FontWeight.bold : null,
                          color: whichGrid == 2 ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (whichGrid == 0) ... [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: 15, //item 개수
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 1 / 1, //item 의 가로 1, 세로 2 의 비율
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(color: Colors.black12);
                  },
                ),
              ),
            ] else if (whichGrid == 1)... [

            ] else ... [

            ],
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}



