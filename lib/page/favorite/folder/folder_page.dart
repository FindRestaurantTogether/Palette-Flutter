import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_controller.dart';
import 'package:myapp/page/favorite/folder/folder_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

final List<String> folderDropdownList = ['최신순', '이름순'];

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {

  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _FavoritePageController = Get.put(FavoritePageController());
  final _FolderPageController = Get.put(FolderPageController());
  // final _TextEditingController = TextEditingController();

  bool isList = true;

  String? DropdownSelected = folderDropdownList.first;

  List<String> regionList = ["강남/서초", "강동/송파", "동작/관악/금천", "마포/은평/서대문", "성동/광진/중랑/동대문", "성북/강북/도봉/노원", "영등포/구로/강서/양천", "용산/종로/중구"];
  List<bool> regionSelected = [false, false, false, false, false, false, false, false];

  final selectedFolderIndex = Get.arguments;

  bool favoriteFolderRestaurantAllChecked = false;
  late List<bool> favoriteFolderRestaurantIsChecked;

  // @override
  // void dispose() {
  //   _FavoritePageController.dispose();
  //   _FolderPageController.dispose();
  //   Hive.box('favorite').close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');
    FavoriteModel favoriteFolder = favoriteBox.values.toList().cast<FavoriteModel>()[selectedFolderIndex];

    List<RestaurantModel> favoriteRestaurantList = [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(() {
          return Column(
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
                      _FolderPageController.editShare.value
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
                                            favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, true);
                                          } else if (favoriteFolderRestaurantAllChecked == false) {
                                            favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
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
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  _FolderPageController.openRegion.value = !_FolderPageController.openRegion.value;
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
                                    return folderDropdownList.map((String value) {
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
                                  items: folderDropdownList
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
                                  dropdownWidth: 90,
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
                                color: _FolderPageController.editShare.value? Color(0xfff42957) : Colors.transparent,
                                shape: StadiumBorder()
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _FolderPageController.checkShare.value
                                    ? _FolderPageController.checkEdit.value
                                    ? SizedBox()  // 의미 없음
                                    : Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.open_in_new, size: 20, color: Color(0xfff42957))
                                )
                                    : _FolderPageController.checkEdit.value
                                    ? Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit, size: 20, color: Color(0xfff42957))
                                )
                                    : SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          if (_FolderPageController.openRegion.value == true) {
                                            _FolderPageController.openRegion.value = false;
                                          }
                                          _FolderPageController.editShare.value = !_FolderPageController.editShare.value;
                                          _FolderPageController.checkEdit.value = !_FolderPageController.checkEdit.value;
                                          setState(() {
                                            favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
                                          });
                                        },
                                        icon: Icon(Icons.edit, size: 20, color: Colors.grey)
                                    )
                                ),
                                SizedBox(width: 10),
                                _FolderPageController.checkEdit.value
                                    ? _FolderPageController.checkShare.value
                                    ? SizedBox()  // 의미 없음
                                    : GestureDetector(
                                  onTap: () {
                                    _FolderPageController.editShare.value = !_FolderPageController.editShare.value;
                                    _FolderPageController.checkEdit.value = !_FolderPageController.checkEdit.value;
                                    setState(() {
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
                                    : _FolderPageController.checkShare.value
                                    ? GestureDetector(
                                  onTap: () {
                                    _FolderPageController.editShare.value = !_FolderPageController.editShare.value;
                                    _FolderPageController.checkShare.value = !_FolderPageController.checkShare.value;
                                    setState(() {
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
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: (){
                                          if (_FolderPageController.openRegion.value == true) {
                                            _FolderPageController.openRegion.value = false;
                                          }
                                          _FolderPageController.editShare.value = !_FolderPageController.editShare.value;
                                          _FolderPageController.checkShare.value = !_FolderPageController.checkShare.value;
                                          setState(() {
                                            favoriteFolderRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
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
                  if (_FolderPageController.openRegion.value == true) ... [
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ' 지역',
                                    style: TextStyle(color: Color(0xff787878), fontSize: 13, fontWeight: FontWeight.bold),
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
                                  ], // 강동/송파
                                  for (int i = 2; i < 3; i++) ...[
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
                                  for (int i = 4; i < 5; i++) ...[
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
                                  for (int i = 6; i < 7; i++) ...[
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
                          FavoriteModel favoriteFolder = box.values.toList().cast<FavoriteModel>()[selectedFolderIndex];
                          favoriteRestaurantList = favoriteFolder.favoriteFolderRestaurantList;
                          // favoriteRestaurantList 만들기
                          if (regionSelected.contains(true)) {
                            if (DropdownSelected == '이름순') {
                              List<int> regionSelectedIndex = []; // regionSelected 중 true인 index들
                              for (int i=0; i<regionSelected.length; i++) {
                                if (regionSelected[i] == true) {
                                  regionSelectedIndex.add(i);
                                }
                              }
                              List<String> regionSelectedList = []; // regionSelected 중 true인 구들
                              for (int i in regionSelectedIndex) {
                                regionSelectedList.addAll(regionList[i].split('/'));
                              }
                              for (int i=0; i<regionSelectedList.length; i++) {
                                regionSelectedList[i] = regionSelectedList[i] + '구';
                              }
                              for (int i=0 ; i<favoriteRestaurantList.length; i++) {
                                if (!regionSelectedList.contains(favoriteRestaurantList[i].jibun_address.split(' ')[1])) {
                                  favoriteRestaurantList.remove(favoriteRestaurantList[i]);
                                }
                              }
                              favoriteRestaurantList.sort((a, b){
                                return a.store_name.compareTo(b.store_name);
                              });
                            }
                            else {
                              List<int> regionSelectedIndex = []; // regionSelected 중 true인 index들
                              for (int i=0; i<regionSelected.length; i++) {
                                if (regionSelected[i] == true) {
                                  regionSelectedIndex.add(i);
                                }
                              }
                              List<String> regionSelectedList = []; // regionSelected 중 true인 구들
                              for (int i in regionSelectedIndex) {
                                regionSelectedList.addAll(regionList[i].split('/'));
                              }
                              for (int i=0; i<regionSelectedList.length; i++) {
                                regionSelectedList[i] = regionSelectedList[i] + '구';
                              }
                              for (int i=0; i<favoriteRestaurantList.length; i++) {
                                if (!regionSelectedList.contains(favoriteRestaurantList[i].jibun_address.split(' ')[1])) {
                                  favoriteRestaurantList.remove(favoriteRestaurantList[i]);
                                }
                              }
                            }
                          }
                          else {
                            if (DropdownSelected == '이름순') {
                              favoriteRestaurantList.sort((a, b){
                                return a.store_name.compareTo(b.store_name);
                              });
                            }
                          }
                          return ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(3),
                            itemCount: favoriteRestaurantList.length,
                            itemBuilder: (BuildContext context, int index){
                              RestaurantModel favoriteRestaurant = favoriteRestaurantList[index];
                              return ExpandTapWidget(
                                  onTap: () async {
                                    if (_FolderPageController.editShare.value == false) {
                                      uid_Network uid_network = await uid_Network(favoriteRestaurant.uid);
                                      var uid_store = await uid_network.getJsonData();
                                      final Position currentPosition = await Geolocator.getCurrentPosition();
                                      DetailNaverMapPageRestaurant detailRestaurant = await DetailNaverMapPageRestaurant(
                                        uid: uid_store['uid'] as String, // 음식점 고유 번호
                                        store_name: uid_store['store_name'] as String, // 음식점 이름
                                        jibun_address: uid_store['jibun_address'] as String, // 음식점 주소
                                        position: LocationClass(latitude: uid_store['latitude'] as double, longitude: uid_store['longitude'] as double),
                                        call: uid_store['call'] as String, // 음식점 전화번호
                                        category: uid_store['category'] as List<String>, // 음식점의 표기되는 카테고리(회의 때 얘기한 소분류 없으면 중분류)
                                        main_category: uid_store['main_category'] as String, // 음식점 마커 이미지
                                        open: uid_store['open'] as String,
                                        opening_hour: uid_store['opening_hour'] as Map<String, String>, // 음식점 영업 시간
                                        opening_breaktime: uid_store['opening_breaktime'] as Map<String, String>,
                                        opening_lastorder: uid_store['opening_lastorder'] as Map<String, String>,
                                        theme: uid_store['theme'] as List<String>, // 음식점 분위기
                                        service: uid_store['service'] as List<String>, // 음식점 서비스
                                        menu: uid_store['menu']  as Map<String, String>, // 음식점 메뉴
                                        store_image: uid_store['store_image'] as List<String>, // 음식점 외부 이미지
                                        distance: get_distance(LatLng(uid_store['latitude'] as double, uid_store['longitude'] as double), LatLng(currentPosition.latitude, currentPosition.longitude)), // 음식점의 현 위치와의 거리
                                        naver_star: uid_store['naver_star'] as double, // 음식점 네이버 평점
                                        naver_cnt: uid_store['naver_cnt'] as int, // 음식점 네이버 리뷰 개수
                                        naver_review_url:uid_store['naver_review_url'] as String,
                                        google_star: uid_store['google_star'] as double, // 음식점 구글 평점
                                        google_cnt: uid_store['google_cnt'] as int, // 음식점 구글 리뷰 개수
                                        google_review_url: uid_store['google_review_url'] as String,
                                        kakao_star: uid_store['kakao_star'] as double, // 음식점 카카오 평점
                                        kakao_cnt: uid_store['kakao_cnt'] as int, // 음식점 카카오 리뷰 개수
                                        kakao_review_url: uid_store['kakao_review_url'] as String,
                                      );

                                      _NaverMapPageController.selectedDetailRestaurant.value = detailRestaurant;
                                      Get.to(() => DetailPage());
                                    }
                                  },
                                  tapPadding: EdgeInsets.all(25),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10, right: _FolderPageController.editShare.value ? 17: 25, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _FolderPageController.editShare.value
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
                                                                Row(
                                                                  children: [
                                                                    for (int i = 0; i < favoriteRestaurant.category.length; i++)
                                                                      if (i == 0)
                                                                        Text(
                                                                          '  ${favoriteRestaurant.category[i]}',
                                                                          style: TextStyle(color: Color(0xff838383), fontSize: 10),
                                                                        )
                                                                      else
                                                                        Text(
                                                                          ',${favoriteRestaurant.category[i]}',
                                                                          style: TextStyle(color: Color(0xff838383), fontSize: 10),
                                                                        )
                                                                  ],
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
                                                          '${favoriteRestaurant.jibun_address.split(' ').getRange(0,3).join(' ')}',
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
                                                            Row(
                                                              children: [
                                                                for (int i = 0; i < favoriteRestaurant.category.length; i++)
                                                                  if (i == 0)
                                                                    Text(
                                                                      '  ${favoriteRestaurant.category[i]}',
                                                                      style: TextStyle(color: Color(0xff838383), fontSize: 10),
                                                                    )
                                                                  else
                                                                    Text(
                                                                      ',${favoriteRestaurant.category[i]}',
                                                                      style: TextStyle(color: Color(0xff838383), fontSize: 10),
                                                                    )
                                                              ],
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
                                                      '${favoriteRestaurant.jibun_address.split(' ').getRange(0,3).join(' ')}',
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
                                        if (favoriteRestaurant.store_image.length != 0)
                                          Container(
                                            width: 120,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(favoriteRestaurant.store_image[0]),
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
                      if (_FolderPageController.checkEdit.value == true) ... [
                        Positioned(
                          left: (width - 300)/2,
                          bottom: 25,
                          child: Container(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                for (int i=favoriteFolderRestaurantIsChecked.length-1; i>=0; i--) {
                                  if (favoriteFolderRestaurantIsChecked[i] == true) {
                                    for (int k=0 ; k<favoriteFolder.favoriteFolderRestaurantList.length ; k++) {
                                      if (favoriteRestaurantList[i].uid == favoriteFolder.favoriteFolderRestaurantList[k].uid) {
                                        _FavoritePageController.favoriteRestaurantUids.removeWhere((e) => e == favoriteRestaurantList[i].uid);

                                        favoriteFolder.favoriteFolderRestaurantList.removeAt(k);
                                        favoriteFolder.save();
                                      }
                                    }
                                  }
                                }

                                setState(() {
                                  favoriteFolderRestaurantAllChecked = false;
                                });
                                _FolderPageController.editShare.value = false;
                                _FolderPageController.checkEdit.value = false;
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
                      else if (_FolderPageController.checkShare.value == true) ... [
                        Positioned(
                          left: (width - 300)/2,
                          bottom: 25,
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
          );
     })
    );
  }
}
