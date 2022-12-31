import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/dialog/dialog_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({Key? key}) : super(key: key);

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {

  final _DialogPageController = Get.put(DialogPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        // height: height * 0.85,
        height: height * 0.6,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.056),
            Container(
              width: width * 0.85,
              height: height * 0.06,
              padding: EdgeInsets.all(5),
              decoration: ShapeDecoration(
                  color: Color(0xfff42957),
                  shape: StadiumBorder()
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _DialogPageController.changeIndex(0);
                      });
                    },
                    child: _DialogPageController.currentIndex == 0
                        ? Container(
                          width: width * 0.41,
                          height: height * 0.05,
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: StadiumBorder()
                          ),
                          child: Center(
                            child: Text(
                              '나의 맵',
                              style: TextStyle(
                                  color: Color(0xfff42957),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                        : Container(
                            width: width * 0.41,
                            height: height * 0.05,
                            decoration: ShapeDecoration(
                                shape: StadiumBorder()
                            ),
                            child: Center(
                              child: Text(
                                '나의 맵',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _DialogPageController.changeIndex(1);
                      });
                    },
                    child: _DialogPageController.currentIndex == 1
                        ? Container(
                          width: width * 0.41,
                          height: height * 0.05,
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: StadiumBorder()
                          ),
                          child: Center(
                            child: Text(
                              '맵 참여자',
                              style: TextStyle(
                                  color: Color(0xfff42957),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                        : Container(
                            width: width * 0.41,
                            height: height * 0.05,
                            decoration: ShapeDecoration(
                                shape: StadiumBorder()
                            ),
                            child: Center(
                              child: Text(
                                '맵 참여자',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            ),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17),
            if (_DialogPageController.currentIndex.value == 0) ... [
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  itemCount: _DialogPageController.MapNames.length,
                  itemBuilder: (context, index){
                    return Column(
                        children: [
                          Container(
                            width: width * 0.84,
                            height: height * 0.08,
                            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xfff42957),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(14)),
                              color: Color(0xfffff6f8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${_DialogPageController.MapNames[index]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 18),
                                    Row(
                                      children: [
                                        for(int i = 0 ; i < _DialogPageController.AvatarImages.length; i++ ) ... [
                                          Align(
                                            widthFactor: 0.5,
                                            child: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 7,
                                                backgroundImage: AssetImage(_DialogPageController.AvatarImages[i]),
                                              ),
                                            ),
                                          ),
                                        ],
                                        SizedBox(width: 8),
                                        Text(
                                          '${_DialogPageController.AvatarImages.length}인',
                                          style: TextStyle(
                                              color: Color(0xfff42957),
                                              fontSize: 11
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 18, color: Color(0xfff42957)),
                                    SizedBox(width: 1),
                                    Text(
                                      '${_NaverMapPageController.restaurants.length}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xfff42957),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Icon(Icons.arrow_forward_ios, color: Color(0xfff42957), size: 14),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5)
                        ]
                    );
                  },
                ),
              ),
            ] else ... [
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(36,0,36,0),
                  itemCount: _DialogPageController.AvatarImages.length,
                  itemBuilder: (context, index){
                    return Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(_DialogPageController.AvatarImages[index]),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    '방채영(나)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xfff42957),
                                    ),
                                  )
                                ],
                              ), // 아바타 & 이름
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 18, color: Color(0xfff42957)),
                                  SizedBox(width: 1),
                                  Text(
                                    '${_NaverMapPageController.restaurants.length}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xfff42957),
                                    ),
                                  ),
                                  SizedBox(width: 27),
                                  Container(
                                    width: 76,
                                    height: 25,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     color: Color(0xfffff6f8),
                                    //     border: Border.all(
                                    //       width: 1,
                                    //       color: Color(0xfff42957),
                                    //     ),
                                    // ),
                                    // child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     Text(
                                    //       '친구',
                                    //       style: TextStyle(
                                    //           color: Color(0xfff42957),
                                    //           fontSize: 12
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: 5),
                                    //     Icon(Icons.check, color: Color(0xfff42957), size: 13)
                                    //   ],
                                    // ),
                                  ) // 친구 버튼
                                ],
                              ), // 지도 핀 갯수 & 친구 여부
                            ],
                          ),
                        ]
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
              )
            ]
          ],
        )
    );
  }
}
