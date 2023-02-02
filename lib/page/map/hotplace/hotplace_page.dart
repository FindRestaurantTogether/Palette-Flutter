import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/hotplace/hotplace_page_controller.dart';

class HotPlacePage extends StatefulWidget {

  HotPlacePage({Key? key}) : super(key: key);

  @override
  State<HotPlacePage> createState() => _HotPlacePageState();
}

class _HotPlacePageState extends State<HotPlacePage> {

  final _HotPlacePageController = Get.put(HotPlacePageController());

  List<String> hotPlace = [
    '강남/논현',
    '선릉/삼성',
    '청담/압구정로데오',
    '신사/가로수길',
    '여의도/영등포',
    '성수/건대',
    '을지로/종로/광화문',
    '서울역/용산',
    '이태원/한남',
    '홍대/신촌',
    '잠실',
    '사당/이수',
    '신림/서울대입구',
    '마곡/등촌',
    '목동',
    '왕십리',
    '혜화/동대문'
  ];

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async{
        Get.back();
        return false;
      }, // 뒤로가기 버튼, 적용된 핫플 필터 백에 전달
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: width * 0.85,
                height: 485,
                padding: EdgeInsets.only(top: 12, bottom: 25, left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  Get.back();
                                }, // 적용된 필터 백에 전달
                                icon: Image.asset('assets/button_image/close_button.png'),
                              ),
                            ), // 나가기
                          ],
                        ),
                      ),
                    ), // 뒤로가기 버튼
                    Text(
                      '핫플레이스',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black
                      ),
                    ), // 핫 플레이스
                    SizedBox(height: 13),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[0],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[0] = !_HotPlacePageController.hotPlaceIsChecked[0];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[0]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[1],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[1] = !_HotPlacePageController.hotPlaceIsChecked[1];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[1]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[2],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[2] = !_HotPlacePageController.hotPlaceIsChecked[2];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[2]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[3],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[3] = !_HotPlacePageController.hotPlaceIsChecked[3];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[3]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[4],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[4] = !_HotPlacePageController.hotPlaceIsChecked[4];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[4]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[5],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[5] = !_HotPlacePageController.hotPlaceIsChecked[5];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[5]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[6],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[6] = !_HotPlacePageController.hotPlaceIsChecked[6];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[6]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[7],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[7] = !_HotPlacePageController.hotPlaceIsChecked[7];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[7]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[8],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[8] = !_HotPlacePageController.hotPlaceIsChecked[8];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[8]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[9],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[9] = !_HotPlacePageController.hotPlaceIsChecked[9];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[9]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[10],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[10] = !_HotPlacePageController.hotPlaceIsChecked[10];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[10]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[11],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[11] = !_HotPlacePageController.hotPlaceIsChecked[11];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[11]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[12],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[12] = !_HotPlacePageController.hotPlaceIsChecked[12];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[12]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[13],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[13] = !_HotPlacePageController.hotPlaceIsChecked[13];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[13]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[14],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[14] = !_HotPlacePageController.hotPlaceIsChecked[14];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[14]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[15],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[15] = !_HotPlacePageController.hotPlaceIsChecked[15];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[15]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          width: 30,
                                          child: Checkbox(
                                            value: _HotPlacePageController.hotPlaceIsChecked[16],
                                            onChanged: (bool? value) {
                                              for (var i=0 ; i<17 ; i++)
                                                _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                              _HotPlacePageController.hotPlaceIsChecked[16] = !_HotPlacePageController.hotPlaceIsChecked[16];
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${hotPlace[16]}',
                                        style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ), // 필터들
                    SizedBox(height: 10),
                    Container(
                      width: width * 0.85 - 32,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        child: Text(
                          '이동',
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
                    ) // 확인박스
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
