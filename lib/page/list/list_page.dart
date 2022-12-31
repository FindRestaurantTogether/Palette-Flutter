import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/list/listview_page.dart';

final List<String> DropdownList = ['거리순', '평점순', '리뷰순'];
final List<String> DropdownList2 = ['3.0', '3.5', '4.0', '4.5'];

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  
  String? DropdownSelected = DropdownList.first;
  String? DropdownSelected2 = DropdownList2.first;

  bool Open = false;
  
  final _TextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          SizedBox(height: height * 0.076),
          Container(
              width: width * 0.87,
              height: height * 0.06,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 2),
                    ),
                  ],
              ),
              child: Center(
                child: Container(
                  width: width * 0.83,
                  child: TextFormField(
                    controller: _TextEditingController,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.map,
                          color: Colors.black54,
                          size: 23,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _TextEditingController.clear();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey,
                          size: 25,
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: '장소, 주소, 음식 검색',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xffb9b9b9),
                      ),
                    ),
                  ),
                ),
              )
          ),
          SizedBox(height: height * 0.028),
          Center(
            child: Container(
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          width: width * 0.26,
                          height: height * 0.04,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.only(left: 18, right: 12),
                                  primary: Colors.white,
                                  shape: StadiumBorder()
                              ),
                              onPressed: () {},
                              child: DropdownButton2(
                                isExpanded: true,
                                items: DropdownList
                                    .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff787878),
                                      ),
                                    )
                                )).toList(),
                                value: DropdownSelected,
                                onChanged: (value) {
                                  setState(() {
                                    DropdownSelected = value as String;
                                  });
                                },
                                underline: Container(),
                                icon: Icon(Icons.keyboard_arrow_down),
                                buttonElevation: 0,
                                dropdownWidth: 95,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                itemHeight: 40,
                                offset: Offset(-15, -1),
                              )
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Open
                            ? Container(
                                width: width * 0.2,
                                height: height * 0.04,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        Open = false;
                                      });
                                    },
                                    child: Text(
                                      '영업중',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xff787878),
                                      shape: StadiumBorder(),
                                    )
                                ),
                            )
                            : Container(
                                width: width * 0.2,
                                height: height * 0.04,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        Open = true;
                                      });
                                    },
                                    child: Text(
                                      '영업중',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff787878),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: StadiumBorder(),
                                    )
                                ),
                            ),
                        SizedBox(width: 10),
                        Container(
                          width: width * 0.22,
                          height: height * 0.04,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.only(left: 18, right: 12),
                                primary: Colors.white,
                                shape: StadiumBorder()
                            ),
                            onPressed: () {},
                            child: DropdownButton2(
                              isExpanded: true,
                              items: DropdownList2
                                  .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff787878),
                                    ),
                                  )
                              )).toList(),
                              value: DropdownSelected2,
                              onChanged: (value) {
                                setState(() {
                                  DropdownSelected2 = value as String;
                                });
                              },
                              underline: Container(),
                              icon: Icon(Icons.keyboard_arrow_down),
                              buttonElevation: 0,
                              dropdownWidth: 78,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              itemHeight: 40,
                              offset: Offset(-15, -1),
                            )
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(height: height * 0.032),
          Container(
            width: width,
            height: 4,
            color: Color(0xffeeeeee),
          ), // 회색 바
          Expanded(child: ListviewPage())
        ],
      ),
    );
  }
}
