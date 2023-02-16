import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_folder_controller.dart';
import 'package:myapp/page/favorite/favorite_page_list_controller.dart';
import 'package:myapp/page/favorite/folder/folder_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';

final List<String> DropdownList = ['최신순', '이름순'];
// final List<String> DropdownList2 = ['최신순', '이름순'];

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  bool isList = true;

  String? DropdownSelected = DropdownList.first;
  // String? DropdownSelected2 = DropdownList2.first;

  final _FavoriteListPageController = Get.put(FavoriteListPageController());
  final _FavoriteFolderPageController = Get.put(FavoriteFolderPageController());
  
  final _TextEditingController = TextEditingController();

  bool switchSelected = false;
  List<String> regionList = ["내 주변", "강남/서초", "강동/송파", "동작/관악/금천", "마포/은평/서대문", "성동/광진/중랑/동대문", "성북/강북/도봉/노원", "영등포/구로/강서/양천", "용산/종로/중구"];
  List<bool> regionSelected = [false, false, false, false, false, false, false, false, false];

  bool favoriteListRestaurantAllChecked = false;
  List<bool> favoriteListRestaurantIsChecked = List<bool>.filled(50, false);

  @override
  void dispose() {
    // _FavoriteListPageController.dispose();
    // _FavoriteFolderPageController.dispose();
    Hive.box('favorite').close();
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
            SizedBox(height: height * 0.08), // 빈 공간
            Container(
              child: Center(
                child: Text(
                  '찜한 장소',
                  style: TextStyle(
                    color: Color(0xff464646),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ), // 찜한 장소
            SizedBox(
              height: height * 0.024,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ExpandTapWidget(
                  onTap: () {
                    setState(() {
                      isList = true;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.all(10),
                    decoration: isList? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        '리스트',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isList ? FontWeight.bold : null,
                          color: isList ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
                ExpandTapWidget(
                  onTap: () {
                    setState(() {
                      isList = false;
                    });
                  },
                  tapPadding: EdgeInsets.all(50),
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.all(10),
                    decoration: !isList? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                    child: Center(
                      child: Text(
                        "폴더",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: !isList ? FontWeight.bold : null,
                          color: !isList ? Color(0xfff42957) : Color(0xffa0a0a0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ), // 리스트 & 폴더
            if (isList) ... [ // 리스트
              ValueListenableBuilder(
                valueListenable: Hive.box<FavoriteModel>('favorite').listenable(),
                builder: (BuildContext context, Box<FavoriteModel> box, _) {
                  List<RestaurantModel> favoriteRestaurants = [];
                  List<FavoriteModel> favoriteFolders = box.values.toList().cast<FavoriteModel>();
                  for (int i=0 ; i<favoriteFolders.length; i++){
                    FavoriteModel favoriteFolder = favoriteFolders[i];
                    favoriteRestaurants.assignAll(favoriteFolder.favoriteFolderRestaurantList);
                  }
                  return Column(
                    children: [
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _FavoriteListPageController.eS
                              ? Row(
                            children: [
                              SizedBox(width: 17),
                              Container(
                                width: 110,
                                height: 30,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      child: Checkbox(
                                        value: favoriteListRestaurantAllChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            favoriteListRestaurantAllChecked = !favoriteListRestaurantAllChecked;
                                            if (favoriteListRestaurantAllChecked == true){
                                              favoriteListRestaurantIsChecked = List<bool>.filled(favoriteRestaurants.length, true);
                                            } else if (favoriteListRestaurantAllChecked == false) {
                                              favoriteListRestaurantIsChecked = List<bool>.filled(favoriteRestaurants.length, false);
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
                                ),
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
                                      color: Colors.black.withOpacity(0.1),
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
                                        color: regionSelected.contains(true) ? Colors.white : Color(0xff787878),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: regionSelected.contains(true) ? Color(0xfff42957) : Colors.white,
                                        shape: StadiumBorder(),
                                        shadowColor: Colors.transparent
                                    )
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 90,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.only(left: 12, right: 15),
                                      primary: Colors.white,
                                      shadowColor: Colors.transparent,
                                      shape: StadiumBorder(),
                                    ),
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
                                    color: _FavoriteListPageController.eS? Color(0xfff42957) : Colors.transparent,
                                    shape: StadiumBorder()
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _FavoriteListPageController.cS ?
                                    _FavoriteListPageController.cE
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
                                        : _FavoriteListPageController.cE
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
                                                _FavoriteListPageController.editShareChangeState();
                                                _FavoriteListPageController.checkEditChangeState();
                                              });
                                            },
                                            icon: Icon(Icons.edit, size: 20, color: Colors.grey)
                                        )
                                    ),
                                    SizedBox(width: 10),
                                    _FavoriteListPageController.cE ?
                                    _FavoriteListPageController.cS
                                        ? SizedBox()  // 의미 없음
                                        : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _FavoriteListPageController.editShareChangeState();
                                          _FavoriteListPageController.checkEditChangeState();
                                          favoriteListRestaurantIsChecked = List<bool>.filled(favoriteRestaurants.length, false);
                                          favoriteListRestaurantAllChecked = false;
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
                                        : _FavoriteListPageController.cS
                                        ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _FavoriteListPageController.editShareChangeState();
                                          _FavoriteListPageController.checkShareChangeState();
                                          List<bool>.filled(favoriteRestaurants.length, false);
                                          favoriteListRestaurantAllChecked = false;
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
                                                _FavoriteListPageController.editShareChangeState();
                                                _FavoriteListPageController.checkShareChangeState();
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
                  );
                },
              ), // 리스트 필터
              ValueListenableBuilder(
                valueListenable: Hive.box<FavoriteModel>('favorite').listenable(),
                builder: (BuildContext context, Box<FavoriteModel> box, _) {
                  List<RestaurantModel> favoriteRestaurants = [];
                  List<FavoriteModel> favoriteFolders = box.values.toList().cast<FavoriteModel>();
                  for (int i=0 ; i<favoriteFolders.length; i++){
                    FavoriteModel favoriteFolder = favoriteFolders[i];
                    favoriteRestaurants.addAll(favoriteFolder.favoriteFolderRestaurantList);
                  }
                  return Expanded(
                    child: Stack(
                      children: [
                        ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(3),
                          itemCount: favoriteRestaurants.length,
                          itemBuilder: (context, index){
                            return ExpandTapWidget(
                                onTap: () {
                                  if (_FavoriteListPageController.eS == false) {
                                    Get.to(() => DetailPage(), arguments: favoriteRestaurants[index]);
                                  }
                                },
                                tapPadding: EdgeInsets.all(25),
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: _FavoriteListPageController.eS ? 17: 25, top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _FavoriteListPageController.eS
                                          ? Row(
                                        children: [
                                          Container(
                                            height: 95,
                                            width: 35,
                                            padding: EdgeInsets.only(top: 1, left: 4),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Checkbox(
                                                value: favoriteListRestaurantIsChecked[index],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    favoriteListRestaurantIsChecked[index] = !favoriteListRestaurantIsChecked[index]!;
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
                                                            favoriteRestaurants[index].store_name,
                                                            style: TextStyle(
                                                                color: Color(0xff464646),
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 1,
                                                        ),
                                                        if (favoriteRestaurants[index].open == 'open')
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
                                                        else if (favoriteRestaurants[index].open == 'close')
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
                                                        else if (favoriteRestaurants[index].open == 'breaktime')
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
                                                          else if (favoriteRestaurants[index].open == 'null')
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
                                                                '  ${favoriteRestaurants[index].category}',
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
                                                        '${favoriteRestaurants[index].naver_star}',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff464646)
                                                        ),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        '(${favoriteRestaurants[index].naver_cnt}건)',
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
                                                        '${favoriteRestaurants[index].jibun_address.substring(0,favoriteRestaurants[index].jibun_address.indexOf('동') + 1)}',
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
                                          )
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
                                                        favoriteRestaurants[index].store_name,
                                                        style: TextStyle(
                                                            color: Color(0xff464646),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 1,
                                                    ),
                                                    if (favoriteRestaurants[index].open == 'open')
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
                                                    else if (favoriteRestaurants[index].open == 'close')
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
                                                    else if (favoriteRestaurants[index].open == 'breaktime')
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
                                                      else if (favoriteRestaurants[index].open == 'null')
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
                                                            '  ${favoriteRestaurants[index].category}',
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
                                                    size: 15,
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    '${favoriteRestaurants[index].naver_star}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 3),
                                                  Text(
                                                    '(${favoriteRestaurants[index].naver_cnt}건)',
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
                                                    '${favoriteRestaurants[index].jibun_address.substring(0,favoriteRestaurants[index].jibun_address.indexOf('동') + 1)}',
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
                                        width: 120,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: AssetImage(favoriteRestaurants[index].store_image[0]),
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
                        if (_FavoriteListPageController.cE == true) ... [
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
                        else if (_FavoriteListPageController.cS == true) ... [
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
                    ),
                  );
                },
              ) // Favorite == true인 음식점들 나열
            ] else ... [ // 폴더
              SizedBox(height: 10), // 15
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         SizedBox(width: 22),
              //         Container(
              //           width: width * 0.5,
              //           height: height * 0.04,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.all(Radius.circular(50)),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.black.withOpacity(0.05),
              //                 spreadRadius: 2,
              //                 blurRadius: 7,
              //                 offset: Offset(0, 2),
              //               ),
              //             ],
              //           ),
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               primary: Colors.white,
              //               shape: StadiumBorder(),
              //               minimumSize: Size.zero,
              //               padding: EdgeInsets.zero,
              //             ),
              //             onPressed: () {},
              //             child: Row(
              //               children: [
              //                 SizedBox(
              //                   width: 40,
              //                   height: 40,
              //                   child: IconButton(
              //                     splashColor: Colors.transparent,
              //                     highlightColor: Colors.transparent,
              //                     onPressed: () {},
              //                     icon: Image.asset('assets/button_image/search_button.png'),
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: width * 0.5 - 40,
              //                   child: TextFormField(
              //                     decoration: InputDecoration(
              //                       border: InputBorder.none,
              //                       hintStyle: TextStyle(
              //                         fontSize: 14,
              //                         color: Color(0xffb9b9b9),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ), // 검색창
              //     Row(
              //       children: [
              //         Container(
              //           width: width * 0.16,
              //           height: height * 0.04,
              //           child: DropdownButtonHideUnderline(
              //               child: DropdownButton2(
              //                 isExpanded: true,
              //                 items: DropdownList2
              //                     .map((item) => DropdownMenuItem<String>(
              //                     value: item,
              //                     child: Text(
              //                       item,
              //                       style: TextStyle(
              //                         fontSize: 15,
              //                         color: Color(0xff787878),
              //                       ),
              //                     )
              //                 )).toList(),
              //                 value: DropdownSelected2,
              //                 onChanged: (value) {
              //                   setState(() {
              //                     DropdownSelected2 = value as String;
              //                   });
              //                 },
              //                 icon: SizedBox(
              //                   width: 12,
              //                   height: 12,
              //                   child: Image.asset('assets/button_image/down_button.png'),
              //                 ),
              //                 underline: Container(),
              //                 buttonElevation: 0,
              //                 dropdownWidth: width * 0.23,
              //                 dropdownDecoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                 ),
              //                 itemHeight: 40,
              //                 offset: Offset(-15, -1),
              //               )
              //           ),
              //         ),
              //         SizedBox(width: 23),
              //       ],
              //     ), // 필터
              //   ],
              // ), // 폴더 필터
              // SizedBox(height: 10),
              Expanded(
                  child: Stack(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: Hive.box<FavoriteModel>('favorite').listenable(),
                        builder: (BuildContext context,  Box<FavoriteModel> box, _) {
                          List<FavoriteModel> favoriteFolders = box.values.toList().cast<FavoriteModel>();
                          return ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(3),
                            itemCount: favoriteFolders.length,
                            itemBuilder: (BuildContext context, int index){
                              FavoriteModel favoriteFolder = favoriteFolders[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => FolderPage(), arguments: index);
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.06,
                                          ),
                                          Container(
                                            width: width * 0.3,
                                            height: 75,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black12
                                            ),
                                            child: Center(
                                              child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset('assets/folder_image/folder_palette.png')
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.04,
                                          ),
                                          Container(
                                            width: width * 0.52,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      ' ${favoriteFolder.favoriteFolderName}',
                                                      style: TextStyle(
                                                          color: Color(0xff464646),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18
                                                      ),
                                                    ), // 폴더 이름
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return Material(
                                                                  color: Colors.transparent,
                                                                  child: Center(
                                                                    child: Container(
                                                                        width: 300,
                                                                        height: 235,
                                                                        padding: EdgeInsets.all(20),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.circular(30)
                                                                        ),
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: (){
                                                                                    Navigator.pop(context);
                                                                                    _TextEditingController.clear();
                                                                                  },
                                                                                  child: Container(
                                                                                      height: 50,
                                                                                      child: Align(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: Icon(Icons.close, size: 26)
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 75,
                                                                                ),
                                                                                Container(
                                                                                  height: 50,
                                                                                  child: Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      '폴더 수정',
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 22
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 4, right: 4),
                                                                              child: TextFormField(
                                                                                autofocus: true,
                                                                                controller: _TextEditingController,
                                                                                maxLength: 20,
                                                                                decoration: InputDecoration(
                                                                                    hintText: _FavoriteFolderPageController.folderName[index],
                                                                                    suffixIcon: IconButton(
                                                                                        onPressed: () {
                                                                                          _TextEditingController.clear();
                                                                                        },
                                                                                        icon: Padding(
                                                                                          padding: EdgeInsets.only(left: 15),
                                                                                          child: Icon(Icons.clear, size: 18),
                                                                                        )
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 15),
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 125,
                                                                                  height: 50,
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                      _FavoriteFolderPageController.removeFolder(index);
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
                                                                                SizedBox(width: 10),
                                                                                Container(
                                                                                  width: 125,
                                                                                  height: 50,
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () {
                                                                                      FavoriteModel? selectedFavoriteFolder = box.getAt(index);
                                                                                      selectedFavoriteFolder!.favoriteFolderName = _TextEditingController.text;
                                                                                      selectedFavoriteFolder.save();
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                        '확인'
                                                                                    ),
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      primary: Color(0xff57dde0),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        )
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: SizedBox(
                                                              width: 22,
                                                              height: 22,
                                                              child: Image.asset('assets/button_image/edit_button.png')
                                                          ),
                                                        ),
                                                        // SizedBox(width: 10),
                                                        // Icon(Icons.open_in_new, size: 20, color: Colors.black54),
                                                      ],
                                                    ), // 편집 및 공유 버튼
                                                  ],
                                                ), // 식당 이름 & 아이콘 2개
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                        width: 22,
                                                        height: 22,
                                                        child: Image.asset('assets/button_image/red_location_button.png')
                                                    ),
                                                    Text(
                                                      '  ${favoriteFolder.favoriteFolderRestaurantList.length.toString()}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xfff42957)
                                                      ),
                                                    ),
                                                    SizedBox(width: 30),
                                                    for(var i = 0; i < favoriteFolder.favoriteFolderRestaurantList.length; i++) ... [
                                                      if (i == 0) ... [
                                                        Text(
                                                          overflow: TextOverflow.ellipsis,
                                                          '${favoriteFolder.favoriteFolderRestaurantList[i].store_name}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(0xffb9b9b9)
                                                          ),
                                                        )
                                                      ] else ... [
                                                        Text(
                                                          overflow: TextOverflow.ellipsis,
                                                          ', ${favoriteFolder.favoriteFolderRestaurantList[i].store_name}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(0xffb9b9b9)
                                                          ),
                                                        )
                                                      ]
                                                    ]
                                                  ],
                                                ), // 핀 갯수 & 음식점 이름
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          );
                        },
                      ),
                      Positioned(
                        right: 20,
                        bottom: 30,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: FloatingActionButton(
                            heroTag: null,
                            child: Image.asset('assets/button_image/add_button.png'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Container(
                                          width: 300,
                                          height: 235,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      _TextEditingController.clear();
                                                    },
                                                    child: Container(
                                                        height: 50,
                                                        child: Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Icon(Icons.close, size: 26)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 75,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        '새 폴더',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 4, right: 4),
                                                child: TextField(
                                                  controller: _TextEditingController,
                                                  maxLength: 20,
                                                  decoration: InputDecoration(
                                                      hintText: '폴더명을 입력해주세요.',
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            _TextEditingController.clear();
                                                          },
                                                          icon: Padding(
                                                            padding: EdgeInsets.only(left: 15),
                                                            child: Icon(Icons.clear, size: 18),
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Container(
                                                width: 300,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _FavoriteFolderPageController.addFolder(_TextEditingController.text);
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
                                              ) //
                                            ],
                                          )
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )
              )
            ]
          ],
        ),
      ),
    );
  }
}