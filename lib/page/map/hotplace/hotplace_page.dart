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
    '전체',
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
                width: width * 0.8,
                height: 440,
                padding: EdgeInsets.only(top: 20, bottom: 25, left: 20, right: 20),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  for (var i = 0 ; i < _HotPlacePageController.hotPlaceIsChecked.length; i++)
                                    _HotPlacePageController.hotPlaceIsChecked[i] = false;
                                },
                                icon: Image.asset('assets/button_image/back_button.png'),
                              ),
                            ), // 초기화
                          ],
                        ),
                      ),
                    ), // 뒤로가기와 초기화 버튼
                    Text(
                      '핫플레이스',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[1],
                                          onChanged: (bool? value) {
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[3],
                                          onChanged: (bool? value) {
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[5],
                                          onChanged: (bool? value) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[7],
                                          onChanged: (bool? value) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[9],
                                          onChanged: (bool? value) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[11],
                                          onChanged: (bool? value) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[13],
                                          onChanged: (bool? value) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[15],
                                          onChanged: (bool? value) {
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
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 115,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: Container(
                                        width: 30,
                                        child: Checkbox(
                                          value: _HotPlacePageController.hotPlaceIsChecked[17],
                                          onChanged: (bool? value) {
                                            _HotPlacePageController.hotPlaceIsChecked[17] = !_HotPlacePageController.hotPlaceIsChecked[17];
                                          },
                                          shape: CircleBorder(),
                                          checkColor: Colors.white,
                                          activeColor: Color(0xfff42957),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${hotPlace[17]}',
                                      style: TextStyle(color: Color(0xff787878), fontSize: 13),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ) // 필터들
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
