import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class SelectMenuPage extends StatefulWidget {

  final List<String> menuName;
  SelectMenuPage({Key? key, required this.menuName}) : super(key: key);

  @override
  State<SelectMenuPage> createState() => _SelectMenuPageState(menuName: menuName);
}

class _SelectMenuPageState extends State<SelectMenuPage> {

  final List<String> menuName;
  _SelectMenuPageState({required this.menuName});

  late String selectedMenu;

  final _TextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: width * 0.8,
            height: height * 0.5,
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
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '메뉴',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 22,
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
                    Material(
                      color: Colors.white,
                      child: Container(
                        width: width * 0.8,
                        height: height * 0.2,
                        child: WheelChooser.byController(
                            controller: FixedExtentScrollController(),
                            onValueChanged: (menu) {
                              selectedMenu = menu;
                            },
                            unSelectTextStyle: TextStyle(color: Colors.black12, fontWeight: FontWeight.bold, fontSize: 12),
                            selectTextStyle: TextStyle(color: Color(0xfff42957), fontWeight: FontWeight.bold, fontSize: 12),
                            squeeze: 1.4,
                            perspective: 0.005,
                            datas: [
                              for(var i=0; i<menuName.length; i++)
                                menuName[i],
                            ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
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
              ],
            ),
          ),
        )
      ],
    );
  }
}
