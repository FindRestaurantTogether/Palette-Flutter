import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:myapp/page/detail/detail_page.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_controller.dart';
import 'package:myapp/page/favorite/folder/folder_page.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:myapp/page/map/navermap/utils.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

final List<String> favoriteDropdownList = ['최신순', '이름순'];
// final List<String> DropdownList2 = ['최신순', '이름순'];

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  bool isList = true;

  String? DropdownSelected = favoriteDropdownList.first;
  // String? DropdownSelected2 = DropdownList2.first;

  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _FavoritePageController = Get.put(FavoritePageController());
  final _TextEditingController = TextEditingController();

  List<String> regionList = ["강남/서초", "강동/송파", "동작/관악/금천", "마포/은평/서대문", "성동/광진/중랑/동대문", "성북/강북/도봉/노원", "영등포/구로/강서/양천", "용산/종로/중구"];
  List<bool> regionSelected = [false, false, false, false, false, false, false, false];

  bool favoriteRestaurantAllChecked = false;
  late List<bool> favoriteRestaurantIsChecked;

  // @override
  // void dispose() {
  //   _FavoritePageController.dispose();
  //   Hive.box('favorite').close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');

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
              height: 15,
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
              Column(
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FavoritePageController.checkEdit.value
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
                                    value: favoriteRestaurantAllChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        favoriteRestaurantAllChecked = !favoriteRestaurantAllChecked;
                                        if (favoriteRestaurantAllChecked == true){
                                          favoriteRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, true);
                                        } else if (favoriteRestaurantAllChecked == false) {
                                          favoriteRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
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
                          : _FavoritePageController.checkShare.value ? SizedBox() : Row(
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
                                  _FavoritePageController.openRegion.value = !_FavoritePageController.openRegion.value;
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
                                    return favoriteDropdownList.map((String value) {
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
                                  items: favoriteDropdownList
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
                                color: _FavoritePageController.editShare.value? Color(0xfff42957) : Colors.transparent,
                                shape: StadiumBorder()
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _FavoritePageController.checkShare.value
                                    ? _FavoritePageController.checkEdit.value
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
                                    : _FavoritePageController.checkEdit.value
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
                                        onPressed: (){
                                          if (_FavoritePageController.openRegion.value == true) {
                                            _FavoritePageController.openRegion.value = false;
                                          }
                                          _FavoritePageController.editShare.value = !_FavoritePageController.editShare.value;
                                          _FavoritePageController.checkEdit.value = !_FavoritePageController.checkEdit.value;
                                          setState(() {
                                            favoriteRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
                                          });
                                          print(favoriteRestaurantIsChecked.length);
                                          print(favoriteRestaurantList.length);
                                          for (int i=0 ; i<favoriteRestaurantList.length ; i++)
                                              print(favoriteRestaurantList[i].store_name);
                                        },
                                        icon: Icon(Icons.edit, size: 20, color: Colors.grey)
                                    )
                                ),
                                SizedBox(width: 10),
                                _FavoritePageController.checkEdit.value
                                    ? _FavoritePageController.checkShare.value
                                    ? SizedBox()  // 의미 없음
                                    : GestureDetector(
                                  onTap: () {
                                    _FavoritePageController.editShare.value = !_FavoritePageController.editShare.value;
                                    _FavoritePageController.checkEdit.value = !_FavoritePageController.checkEdit.value;
                                    setState(() {
                                      favoriteRestaurantAllChecked = false;
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
                                    : _FavoritePageController.checkShare.value
                                    ? GestureDetector(
                                  onTap: () {
                                    _FavoritePageController.editShare.value = !_FavoritePageController.editShare.value;
                                    _FavoritePageController.checkShare.value = !_FavoritePageController.checkShare.value;
                                    setState(() {
                                      favoriteRestaurantAllChecked = false;
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
                                          if (_FavoritePageController.openRegion.value == true) {
                                            _FavoritePageController.openRegion.value = false;
                                          }
                                          _FavoritePageController.editShare.value = !_FavoritePageController.editShare.value;
                                          _FavoritePageController.checkShare.value = !_FavoritePageController.checkShare.value;
                                          setState(() {
                                            favoriteRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
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
                  if (_FavoritePageController.openRegion.value == true) ... [
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
                          List<FavoriteModel> favoriteFolders = box.values.toList().cast<FavoriteModel>();
                          for (int i=0 ; i<favoriteFolders.length; i++){
                              FavoriteModel favoriteFolder = favoriteFolders[i];
                              for (int j=0 ; j<favoriteFolder.favoriteFolderRestaurantList.length ; j++) {
                                if (!favoriteRestaurantList.contains(favoriteFolder.favoriteFolderRestaurantList[j])) {
                                  favoriteRestaurantList.add(favoriteFolder.favoriteFolderRestaurantList[j]);
                                }
                              }
                          }
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
                            itemBuilder: (context, index){
                              RestaurantModel favoriteRestaurant = favoriteRestaurantList[index];
                              return ExpandTapWidget(
                                  onTap: () async {
                                    if (_FavoritePageController.editShare.value == false) {
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
                                    padding: EdgeInsets.only(left: 10, right: _FavoritePageController.editShare.value ? 17: 25, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (_FavoritePageController.checkEdit.value)
                                          Row(
                                          children: [
                                            Container(
                                              height: 95,
                                              width: 35,
                                              padding: EdgeInsets.only(top: 1, left: 4),
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Checkbox(
                                                  value: favoriteRestaurantIsChecked[index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      favoriteRestaurantIsChecked[index] = !favoriteRestaurantIsChecked[index]!;
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
                                                          else if (favoriteRestaurant.open == 'closed')
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
                                                            else if (favoriteRestaurant.open == 'None')
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
                                                          '${favoriteRestaurant.naver_star}',
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
                                            )
                                          ],
                                        )
                                        else if (_FavoritePageController.checkShare.value)
                                          Row(
                                            children: [
                                              Container(
                                                height: 95,
                                                width: 35,
                                                padding: EdgeInsets.only(top: 1, left: 4),
                                                child: Align(
                                                  alignment: Alignment.topCenter,
                                                  child: Checkbox(
                                                    value: favoriteRestaurantIsChecked[index],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        favoriteRestaurantIsChecked = List<bool>.filled(favoriteRestaurantList.length, false);
                                                        favoriteRestaurantIsChecked[index] = true;
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
                                                            else if (favoriteRestaurant.open == 'closed')
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
                                                              else if (favoriteRestaurant.open == 'None')
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
                                                            '${favoriteRestaurant.naver_star}',
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
                                              )
                                            ],
                                          )
                                        else
                                          Container(
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
                                                        else if (favoriteRestaurant.open == 'None')
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
                                                      size: 15,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      '${favoriteRestaurant.naver_star}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      '(${favoriteRestaurant.naver_cnt}건)',
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
                                                      '${favoriteRestaurant.jibun_address.split(' ').getRange(0,3).join(' ')}',
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
                        }
                    ),
                    if (_FavoritePageController.checkEdit.value == true) ... [
                      Positioned(
                        left: (width - 300)/2,
                        bottom: 25,
                        child: Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              List<FavoriteModel> favoriteFolders = favoriteBox.values.toList().cast<FavoriteModel>();
                              for (int i=favoriteRestaurantIsChecked.length-1; i>=0; i--) {
                                if (favoriteRestaurantIsChecked[i] == true) {
                                  for (int j=0 ; j<favoriteFolders.length; j++) {
                                    FavoriteModel favoriteFolder = favoriteFolders[j];
                                    for (int k=0 ; k<favoriteFolder.favoriteFolderRestaurantList.length ; k++) {
                                      if (favoriteRestaurantList[i].uid == favoriteFolder.favoriteFolderRestaurantList[k].uid) {
                                        _FavoritePageController.favoriteRestaurantUids.removeWhere((e) => e == favoriteRestaurantList[i].uid);

                                        favoriteFolder.favoriteFolderRestaurantList.removeAt(k);
                                        favoriteFolder.save();
                                      }
                                    }
                                  }
                                }
                              }
                              // favoriteRestaurantIsChecked & favoriteRestaurantList index 매치하니까 favoriteFolder.favoriteFolderRestaurantList에서 매칭되는거 지우기

                              setState(() {
                                favoriteRestaurantAllChecked = false;
                              });
                              _FavoritePageController.editShare.value = false;
                              _FavoritePageController.checkEdit.value = false;
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
                    else if (_FavoritePageController.checkShare.value == true) ... [
                      Positioned(
                        left: (width - 300)/2,
                        bottom: 25,
                        child: Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              List<FavoriteModel> favoriteFolders = favoriteBox.values.toList().cast<FavoriteModel>();
                              for (int i=favoriteRestaurantIsChecked.length-1; i>=0; i--) {
                                if (favoriteRestaurantIsChecked[i] == true) {
                                  final LocationTemplate defaultFeed = LocationTemplate(
                                    address: favoriteRestaurantList[i].jibun_address,
                                    content: Content(
                                      title: favoriteRestaurantList[i].store_name,
                                      description: favoriteRestaurantList[i].category.join(', ').replaceAll("[", "").replaceAll("]", ""),
                                      imageUrl: Uri.parse(favoriteRestaurantList[i].store_image[0]),
                                      link: Link(
                                        webUrl: Uri.parse('https://developers.kakao.com'),
                                        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
                                      ),
                                    ),
                                  );
                                  bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
                                  if (isKakaoTalkSharingAvailable) {
                                    try {
                                      Uri uri = await ShareClient.instance.shareDefault(template: defaultFeed);
                                      await ShareClient.instance.launchKakaoTalk(uri);
                                      print('카카오톡 공유 완료');
                                    } catch (error) {
                                      print('카카오톡 공유 실패 $error');
                                    }
                                  } else {
                                    try {
                                      Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: defaultFeed);
                                      await launchBrowserTab(shareUrl, popupOpen: true);
                                    } catch (error) {
                                      print('카카오톡 공유 실패 $error');
                                    }
                                  }
                                }
                              }

                              _FavoritePageController.editShare.value = false;
                              _FavoritePageController.checkShare.value = false;
                            },
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
              ) // Favorite == true인 음식점들 나열
            ] else ... [ // 폴더
              SizedBox(height: 10),
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
                                                                                    enabledBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Color(0xfff42957)),
                                                                                    ),
                                                                                    focusedBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Color(0xfff42957)),
                                                                                    ),
                                                                                    hintText: favoriteFolder.favoriteFolderName,
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
                                                                                      favoriteFolder.delete();
                                                                                      Navigator.pop(context);
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
                                                child: TextFormField(
                                                  controller: _TextEditingController,
                                                  maxLength: 20,
                                                  decoration: InputDecoration(
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Color(0xfff42957)),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Color(0xfff42957)),
                                                      ),
                                                      hintText: '폴더명을 입력해주세요.',
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            _TextEditingController.clear();
                                                          },
                                                          icon: Padding(
                                                            padding: EdgeInsets.only(left: 15),
                                                            child: Icon(Icons.clear, size: 18, color: Color(0xfff42957)),
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
                                                    favoriteBox.add(
                                                        FavoriteModel(
                                                            favoriteFolderName: _TextEditingController.text,
                                                            favoriteFolderRestaurantList: []
                                                        )
                                                    );
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
        );
      })
    );
  }
}