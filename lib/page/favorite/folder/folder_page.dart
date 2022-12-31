import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/favorite/favorite_page_folder_controller.dart';
import 'package:myapp/page/favorite/folder/folder_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';

final List<String> DropdownList = ['최신순', '이름순', '거리순'];

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {

  final _FolderPageController = Get.put(FolderPageController());
  final _FavoriteFolderPageController = Get.put(FavoriteFolderPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());
  final textController = TextEditingController();

  bool isList = true;

  String? DropdownSelected = DropdownList.first;

  bool allChecked = false;
  late List<bool> isChecked;

  final selectedFolderIndex = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = List<bool>.filled(_NaverMapPageController.restaurants.where((NaverMapPageModel restaurant) => restaurant.favorite == true).length, false);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var _selectedRestaurants = _FavoriteFolderPageController.folderRestaurant[selectedFolderIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
          children: [
            SizedBox(height: height * 0.08),
            Container(
              child: Stack(
                children: [
                  Container(
                    height: height * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        Container(
                          width: 36,
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black54,
                                  size: 20
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_FavoriteFolderPageController.folderName[selectedFolderIndex]}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff464646)
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FolderPageController.eS
                        ? Row(
                      children: [
                        SizedBox(width: 17),
                        Container(
                            width: 110,
                            height: 35,
                            child:  Row(
                              children: [
                                Container(
                                  width: 30,
                                  child: Checkbox(
                                    value: allChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        print(allChecked);
                                        allChecked = !allChecked;
                                        print(allChecked);
                                        if (allChecked == true){
                                          isChecked = List<bool>.filled(_selectedRestaurants.length, true);
                                        } else if (allChecked == false) {
                                          isChecked = List<bool>.filled(_selectedRestaurants.length, false);
                                        }
                                      });
                                    },
                                    shape: CircleBorder(),
                                    checkColor: Colors.white,
                                    activeColor: Color(0xfff42957),
                                  ),
                                ),
                                Text(
                                  ' 전체 선택',
                                  style: TextStyle(fontSize: 16, color: Color(0xff464646)),
                                ),
                              ],
                            )
                        ),
                      ],
                    ) // 전체선택 check box
                        : Row(
                      children: [
                        SizedBox(width: 20),
                        Container(
                          width: width * 0.184,
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
                              onPressed: () {},
                              child: Text(
                                '지역',
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
                          width: width * 0.27,
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
                              style: ElevatedButton.styleFrom(primary: Colors.white, shape: StadiumBorder()),
                              onPressed: () {},
                              child: DropdownButton2(
                                isExpanded: true,
                                items: DropdownList
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
                                value: DropdownSelected,
                                onChanged: (value) {
                                  setState(() {
                                    DropdownSelected = value as String;
                                  });
                                },
                                underline: Container(),
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
                      ],
                    ), // 지역 & 최신순
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 38,
                          decoration: ShapeDecoration(
                              color: _FolderPageController.eS? Color(0xfff42957) : Colors.transparent,
                              shape: StadiumBorder()
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _FolderPageController.cS ?
                              _FolderPageController.cE
                                  ? SizedBox()  // 의미 없음
                                  : GestureDetector(
                                onTap: () {},
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.open_in_new, size: 20, color: Color(0xfff42957))
                                ),
                              )
                                  : _FolderPageController.cE
                                  ? GestureDetector(
                                onTap: () {},
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit, size: 20, color: Color(0xfff42957))
                                ),
                              )
                                  : SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: (){
                                        setState(() {
                                          _FolderPageController.editShareChangeState();
                                          _FolderPageController.checkEditChangeState();
                                        });
                                      },
                                      icon: Icon(Icons.edit, size: 20, color: Colors.grey)
                                  )
                              ),
                              SizedBox(width: 10),
                              _FolderPageController.cE ?
                              _FolderPageController.cS
                                  ? SizedBox()  // 의미 없음
                                  : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _FolderPageController.editShareChangeState();
                                    _FolderPageController.checkEditChangeState();
                                    isChecked = List<bool>.filled(_selectedRestaurants.length, false);
                                    allChecked = false;
                                  });
                                },
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff42957),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, size: 20, color: Colors.white)
                                ),
                              )
                                  : _FolderPageController.cS
                                  ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _FolderPageController.editShareChangeState();
                                    _FolderPageController.checkShareChangeState();
                                    List<bool>.filled(_selectedRestaurants.length, false);
                                    allChecked = false;
                                  });
                                },
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff42957),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close, size: 20, color: Colors.white)
                                ),
                              )
                                  : SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: (){
                                        setState(() {
                                          _FolderPageController.editShareChangeState();
                                          _FolderPageController.checkShareChangeState();
                                        });
                                      },
                                      icon: Icon(Icons.open_in_new, size: 20, color: Colors.grey)
                                  )
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 20)
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2),
              ],
            ), // 리스트 필터
            Expanded(
                child: Stack(
                  children: [
                    ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(3),
                      itemCount: _selectedRestaurants.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                            onTap: () {
                              if (_FolderPageController.eS == false) {
                                Get.to(() => DetailPage(), arguments: _selectedRestaurants.elementAt(index));
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 15, right: 20, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _FolderPageController.eS
                                      ? Row(
                                    children: [
                                      Container(
                                        height: 89,
                                        width: 30,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Checkbox(
                                            value: isChecked[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked[index] = !isChecked[index]!;
                                              });
                                            },
                                            shape: CircleBorder(),
                                            checkColor: Colors.white,
                                            activeColor: Color(0xfff42957),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 19, left: 8),
                                        width: 139,
                                        height: 107,
                                        child: Column(
                                          children: [
                                            Container(
                                                height: 25,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '${_selectedRestaurants.elementAt(index).name}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    _selectedRestaurants.elementAt(index).open
                                                        ? Container(
                                                      height: 20,
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          width: 5,
                                                          height: 5,
                                                          decoration: BoxDecoration(
                                                              color: Colors.cyan.shade300,
                                                              shape: BoxShape.circle),
                                                        ),
                                                      ),
                                                    )
                                                        : Container(
                                                      height: 20,
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          width: 5,
                                                          height: 5,
                                                          decoration: BoxDecoration(
                                                              color: Colors.red.shade300,
                                                              shape: BoxShape.circle),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 24,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            '  ${_selectedRestaurants.elementAt(index).classification}',
                                                            style: TextStyle(
                                                                color: Colors.grey, fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ), // 음식점 이름
                                            Container(
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xfff42957),
                                                    size: 13,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    '${_selectedRestaurants.elementAt(index).overallRating}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    '(${_selectedRestaurants.elementAt(index).numberOfOverallRating}건)',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),// 별점
                                            Container(
                                              height: 20,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${_selectedRestaurants.elementAt(index).address.substring(0,_selectedRestaurants.elementAt(index).address.indexOf('동') + 1)}',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ), // 주소
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(
                                    padding: EdgeInsets.only(top: 19, left: 11),
                                    width: 165,
                                    height: 107,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 25,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${_selectedRestaurants.elementAt(index).name}',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                _selectedRestaurants.elementAt(index).open
                                                    ? Container(
                                                  height: 20,
                                                  child: Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                          color: Colors.cyan.shade300,
                                                          shape: BoxShape.circle),
                                                    ),
                                                  ),
                                                )
                                                    : Container(
                                                  height: 20,
                                                  child: Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red.shade300,
                                                          shape: BoxShape.circle),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 24,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '  ${_selectedRestaurants.elementAt(index).classification}',
                                                        style: TextStyle(
                                                            color: Colors.grey, fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                        ), // 음식점 이름
                                        Container(
                                          height: 30,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Color(0xfff42957),
                                                size: 15,
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                '${_selectedRestaurants.elementAt(index).overallRating}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                '(${_selectedRestaurants.elementAt(index).numberOfOverallRating}건)',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),// 별점
                                        Container(
                                          height: 20,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${_selectedRestaurants.elementAt(index).address.substring(0,_selectedRestaurants.elementAt(index).address.indexOf('동') + 1)}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ), // 주소
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 95,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: AssetImage(_selectedRestaurants.elementAt(index).exteriorImage),
                                          fit: BoxFit.fill
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                    if (_FolderPageController.cE == true) ... [
                      Positioned(
                        left: 32,
                        bottom: 20,
                        child: Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              '삭제',
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
                      )
                    ]
                    else if (_FolderPageController.cS == true) ... [
                      Positioned(
                        left: 32,
                        bottom: 20,
                        child: Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              '공유',
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
                      )
                    ]
                  ],
                )
            ) // 음식점들 나열
          ],
      ),
    );
  }
}
