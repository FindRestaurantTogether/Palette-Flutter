import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_list_controller.dart';
import 'package:myapp/page/favorite/folder/folder_page_controller.dart';

final List<String> DropdownList = ['최신순', '이름순', '거리순'];

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {

  final _FolderPageController = Get.put(FolderPageController());
  final _FavoriteListPageController = Get.put(FavoriteListPageController());
  final _TextEditingController = TextEditingController();

  bool isList = true;

  String? DropdownSelected = DropdownList.first;

  bool switchSelected = false;
  List<String> regionList = ["내 주변", "강남/서초", "강동/송파", "동작/관악/금천", "마포/은평/서대문", "성동/광진/중랑/동대문", "성북/강북/도봉/노원", "영등포/구로/강서/양천", "용산/종로/중구"];
  List<bool> regionSelected = [false, false, false, false, false, false, false, false, false];

  final selectedFolderIndex = Get.arguments;

  bool favoriteFolderRestaurantAllChecked = false;
  List<bool> favoriteFolderRestaurantIsChecked = List<bool>.filled(50, false);

  @override
  void dispose() {
    // _FolderPageController.dispose();
    // _FavoriteFolderPageController.dispose();
    // _TextEditingController.dispose();
    Hive.box('favorite').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');
    FavoriteModel favoriteFolder = favoriteBox.values.toList().cast<FavoriteModel>()[selectedFolderIndex];

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
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
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
                          favoriteFolder.favoriteFolderName,
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
                                height: 30,
                                child:  Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      child: Checkbox(
                                        value: favoriteFolderRestaurantAllChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            favoriteFolderRestaurantAllChecked = !favoriteFolderRestaurantAllChecked;
                                            if (favoriteFolderRestaurantAllChecked == true){
                                              favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteFolder.favoriteFolderRestaurantList.length, true);
                                            } else if (favoriteFolderRestaurantAllChecked == false) {
                                              favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteFolder.favoriteFolderRestaurantList.length, false);
                                            }
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: Color(0xfff42957),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 1),
                                      child: Text(
                                        ' 전체 선택',
                                        style: TextStyle(fontSize: 16, color: Color(0xff464646)),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ) // 전체선택 check box
                        : Row(
                      children: [
                        SizedBox(width: 26),
                        Container(
                          width: 70,
                          height: 30,
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
                                  _FavoriteListPageController.openRegionChangeState();
                                });
                              },
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
                                selectedItemBuilder: (BuildContext context) {
                                  return DropdownList.map((String value) {
                                    return Center(
                                      child: Text(
                                        DropdownSelected!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:  Color(0xfff42957),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
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
                                icon: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: Image.asset('assets/button_image/down_button.png'),
                                ),
                                dropdownWidth: width * 0.26,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                itemHeight: 40,
                                offset: Offset(-15, -3),
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
                                    favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteFolder.favoriteFolderRestaurantList.length, false);
                                    favoriteFolderRestaurantAllChecked = false;
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
                                    favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteFolder.favoriteFolderRestaurantList.length, false);
                                    favoriteFolderRestaurantAllChecked = false;
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
                if (_FavoriteListPageController.oR == true) ... [
                  SizedBox(height: 7),
                  Center(
                    child: Container(
                      width: width - 50,
                      height: height * 0.254,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, -1),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 16, bottom: 16, left: 22, right: 20),
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.03,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' 지역',
                                  style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      ' 전체 ',
                                      style: TextStyle(color: Color(0xff787878), fontSize: 12),
                                    ), // 전체 텍스트
                                    Container(
                                      width: width * 0.082,
                                      child: Transform.scale(
                                        scale: 0.5,
                                        child: CupertinoSwitch(
                                            activeColor: Color(0xfff42957),
                                            value: switchSelected, // SwitchSelected 값에 따라
                                            onChanged: (value) {
                                              setState(() {
                                                switchSelected = value; // SwitchSelected 값 바꿔주기

                                                if (switchSelected == true)
                                                  for (int i = 0; i < regionSelected.length; i++)
                                                    regionSelected[i] = true;
                                                if (switchSelected == false)
                                                  for (int i = 0; i < regionSelected.length; i++)
                                                    regionSelected[i] = false; // SwitchOuterAlcoholSelected 함수를 통해 모두 선택 또는 선택해제하기
                                              });
                                            }),
                                      ),
                                    ) // 스위치 버튼
                                  ],
                                ),
                              ],
                            ),
                          ), // 지역과 전체
                          SizedBox(
                            height: height * 0.016,
                          ), // 빈 공간
                          Container(
                            height: height * 0.03,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 0; i < 1; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 64,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 64,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 내 주변
                                for (int i = 1; i < 2; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 72,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 72,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 강남/서초
                                for (int i = 2; i < 3; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 72,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 72,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ] // 강동/송파
                              ],
                            ),
                          ), // 첫째줄 필터
                          SizedBox(
                            height: height * 0.01,
                          ), // 빈 공간
                          Container(
                            height: height * 0.03,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 3; i < 4; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 100,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 100,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 동작/관악/금천
                                for (int i = 4; i < 5; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 112,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 112,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 마포/은평/서대문
                              ],
                            ),
                          ), // 둘째줄 필터
                          SizedBox(
                            height: height * 0.01,
                          ), // 빈 공간
                          Container(
                            height: height * 0.03,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 5; i < 6; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 136,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 136,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 성동/광진/중랑/동대문
                                for (int i = 6; i < 7; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 126,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 126,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 성북/강북/도봉/노원
                              ],
                            ),
                          ), // 세번째줄 필터
                          SizedBox(
                            height: height * 0.01,
                          ), // 빈 공간
                          Container(
                            height: height * 0.03,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (int i = 7; i < 8; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 136,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 136,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 영등포/구로/강서/양천
                                for (int i = 8; i < 9; i++) ...[
                                  regionSelected[i]
                                      ? Container(
                                    width: 100,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfff42957),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder())),
                                  )
                                      : Container(
                                    width: 100,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            regionSelected[i] = !regionSelected[i];
                                          });
                                        },
                                        child: Text(
                                          regionList[i],
                                          style: TextStyle(color: Color(0xfff42957), fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xfffff6f8),
                                            side: BorderSide(width: 1, color: Color(0xfff42957)),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            shape: StadiumBorder()
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.016,
                                  ),
                                ], // 용산/종로/중구
                              ],
                            ),
                          ), // 네번째줄 필터
                        ],
                      ), // innerfilter 박스 내 내용물
                    ),
                  )
                ],
              ],
            ), // 리스트 필터
            Expanded(
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: Hive.box<FavoriteModel>('favorite').listenable(),
                      builder: (BuildContext context, Box<FavoriteModel> box, _) {
                        return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(3),
                          itemCount: favoriteFolder.favoriteFolderRestaurantList.length,
                          itemBuilder: (BuildContext context, int index){
                            RestaurantModel favoriteRestaurant = favoriteFolder.favoriteFolderRestaurantList[index];
                            return ExpandTapWidget(
                                onTap: () {
                                  if (_FolderPageController.eS == false) {
                                    Get.to(() => DetailPage(), arguments: favoriteRestaurant);
                                  }
                                },
                                tapPadding: EdgeInsets.all(25),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: _FolderPageController.eS ? 17: 25, top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _FolderPageController.eS
                                          ? Row(
                                        children: [
                                          Container(
                                            height: 95,
                                            width: 35,
                                            padding: EdgeInsets.only(top: 1, left: 4),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Checkbox(
                                                value: favoriteFolderRestaurantIsChecked[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    favoriteFolderRestaurantIsChecked[index] = !favoriteFolderRestaurantIsChecked[index]!;
                                                  });
                                                },
                                                shape: CircleBorder(),
                                                checkColor: Colors.white,
                                                activeColor: Color(0xfff42957),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 3, right: 15, bottom: 10, top: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          child: Text(
                                                            favoriteRestaurant.store_name,
                                                            style: TextStyle(
                                                                color: Color(0xff464646),
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 1,
                                                        ),
                                                        if (favoriteRestaurant.open == 'open')
                                                          Container(
                                                            height: 20,
                                                            child: Align(
                                                              alignment: Alignment.topCenter,
                                                              child: Container(
                                                                width: 5,
                                                                height: 5,
                                                                decoration: BoxDecoration(
                                                                    color: Color(0xff57dde0),
                                                                    shape: BoxShape.circle),
                                                              ),
                                                            ),
                                                          )
                                                        else if (favoriteRestaurant.open == 'close')
                                                          Container(
                                                            height: 20,
                                                            child: Align(
                                                              alignment: Alignment.topCenter,
                                                              child: Container(
                                                                width: 5,
                                                                height: 5,
                                                                decoration: BoxDecoration(
                                                                    color: Color(0xfff42957),
                                                                    shape: BoxShape.circle),
                                                              ),
                                                            ),
                                                          )
                                                        else if (favoriteRestaurant.open == 'breaktime')
                                                            Container(
                                                              height: 20,
                                                              child: Align(
                                                                alignment: Alignment.topCenter,
                                                                child: Container(
                                                                  width: 5,
                                                                  height: 5,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.yellow,
                                                                      shape: BoxShape.circle),
                                                                ),
                                                              ),
                                                            )
                                                          else if (favoriteRestaurant.open == 'null')
                                                              Container(
                                                                height: 20,
                                                                child: Align(
                                                                  alignment: Alignment.topCenter,
                                                                  child: Container(
                                                                    width: 5,
                                                                    height: 5,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        shape: BoxShape.circle),
                                                                  ),
                                                                ),
                                                              ),
                                                        Container(
                                                          height: 20,
                                                          padding: EdgeInsets.only(bottom: 1),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                '  ${favoriteRestaurant.category}',
                                                                style: TextStyle(
                                                                    color: Color(0xff838383), fontSize: 10),
                                                              ),
                                                              SizedBox(height: 1)
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
                                                        size: 14,
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        favoriteRestaurant.naver_star.toString(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff464646)
                                                        ),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        '(${favoriteRestaurant.naver_cnt}건)',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(0xff464646)
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
                                                        '${favoriteRestaurant.jibun_address.substring(0,favoriteRestaurant.jibun_address.indexOf('동') + 1)}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(0xff464646)
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ), // 주소
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                          : Container(
                                        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      child: Text(
                                                        favoriteRestaurant.store_name,
                                                        style: TextStyle(
                                                            color: Color(0xff464646),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 1,
                                                    ),
                                                    if (favoriteRestaurant.open == 'open')
                                                      Container(
                                                        height: 20,
                                                        child: Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Container(
                                                            width: 5,
                                                            height: 5,
                                                            decoration: BoxDecoration(
                                                                color: Color(0xff57dde0),
                                                                shape: BoxShape.circle),
                                                          ),
                                                        ),
                                                      )
                                                    else if (favoriteRestaurant.open == 'close')
                                                      Container(
                                                        height: 20,
                                                        child: Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Container(
                                                            width: 5,
                                                            height: 5,
                                                            decoration: BoxDecoration(
                                                                color: Color(0xfff42957),
                                                                shape: BoxShape.circle),
                                                          ),
                                                        ),
                                                      )
                                                    else if (favoriteRestaurant.open == 'breaktime')
                                                        Container(
                                                          height: 20,
                                                          child: Align(
                                                            alignment: Alignment.topCenter,
                                                            child: Container(
                                                              width: 5,
                                                              height: 5,
                                                              decoration: BoxDecoration(
                                                                  color: Colors.yellow,
                                                                  shape: BoxShape.circle),
                                                            ),
                                                          ),
                                                        )
                                                      else if (favoriteRestaurant.open == 'null')
                                                          Container(
                                                            height: 20,
                                                            child: Align(
                                                              alignment: Alignment.topCenter,
                                                              child: Container(
                                                                width: 5,
                                                                height: 5,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    shape: BoxShape.circle),
                                                              ),
                                                            ),
                                                          ),
                                                    Container(
                                                      height: 20,
                                                      padding: EdgeInsets.only(bottom: 1),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            '  ${favoriteRestaurant.category}',
                                                            style: TextStyle(
                                                                color: Color(0xff838383), fontSize: 10),
                                                          ),
                                                          SizedBox(height: 1)
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
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    favoriteRestaurant.naver_star.toString(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xff464646)
                                                    ),
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    '(${favoriteRestaurant.naver_cnt}건)',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Color(0xff464646)
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
                                                    '${favoriteRestaurant.jibun_address.substring(0,favoriteRestaurant.jibun_address.indexOf('동') + 1)}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xff464646)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ), // 주소
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: AssetImage(favoriteRestaurant.store_image[0]),
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
                        );
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
                            onPressed: () {

                            },
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
