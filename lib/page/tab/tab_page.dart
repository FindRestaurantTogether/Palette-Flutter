// option + command + l
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/page/favorite/favorite_page.dart';
import 'package:myapp/page/map/map_page.dart';
import 'package:myapp/page/map/map_page_controller.dart';
import 'package:myapp/page/my/my_page.dart';
import 'package:myapp/page/tab/tab_page_controller.dart';
import 'package:myapp/page/group/group_page.dart';
import 'package:myapp/page/onboarding/onboarding.dart';

// 바텀네비게이션바 기능 추가
class TabPage extends StatefulWidget {
  TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  final _TabPageController = Get.put(TabPageController());
  final _MapPageController = Get.put(MapPageController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_MapPageController.bottomSheet.value == true) {
          _MapPageController.bottomSheet.value = !_MapPageController.bottomSheet.value;
          Get.back();
        } else {
          await _onBackPressed(context);
        }
        return false;
      },
      child: GetX<TabPageController>(
          builder: (_) => Scaffold(
                body: IndexedStack(
                  index: _TabPageController.CurrentTab.value,
                  children: [
                    MapPage(),
                    FavoritePage(),
                    // GroupPage(),
                    MyPage(),
                  ],
                ),
                bottomNavigationBar: SizedBox(
                  height: 55,
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.white,
                        selectedItemColor: Color(0xfff42957),
                        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(fontSize: 10),
                        unselectedItemColor: Colors.grey,
                        onTap: _TabPageController.ChangeTab,
                        currentIndex: _TabPageController.CurrentTab.value,
                        items: [
                          BottomNavigationBarItem(
                            label: '홈',
                            icon: ImageIcon(
                              AssetImage("assets/bottomnavigation_image/home.png"),
                              size: 23,
                            ),
                          ),
                          BottomNavigationBarItem(
                            label: '즐겨찾기',
                            icon: ImageIcon(
                              AssetImage("assets/bottomnavigation_image/favorite.png"),
                              size: 23,
                            ),
                          ),
                          // BottomNavigationBarItem(
                          //   label: '그룹',
                          //   icon: Icon(Icons.add_alarm),
                          // ),
                          BottomNavigationBarItem(
                            label: '마이페이지',
                            icon: ImageIcon(
                              AssetImage("assets/bottomnavigation_image/mypage.png"),
                              size: 23,
                            ),
                          ),
                        ]),
                  ),
                ),
              )),
    );
  }

  // 뒤로가기 두번 클릭시 나가기
  Future<void> _onBackPressed(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
                width: 300,
                height: 190,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(Icons.close, size: 26)
                          )
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '앱을 종료하시겠습니까?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),
                        ),
                      ),
                    ), // 앱을 종료하시겠습니까?
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Container(
                          width: 125,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '아니요',
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
                            onPressed: () => SystemNavigator.pop(),
                            child: Text(
                                '네'
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
  }
}
