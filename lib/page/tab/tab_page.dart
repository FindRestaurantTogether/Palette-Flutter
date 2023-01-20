// option + command + l
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/favorite/favorite_page.dart';
import 'package:myapp/page/map/map_page.dart';
import 'package:myapp/page/my/my_page.dart';
import 'package:myapp/page/tab/tab_page_controller.dart';
import 'package:myapp/page/group/group_page.dart';
import 'package:myapp/page/onboarding/onboarding.dart';

// 바텀네비게이션바 기능 추가
class TabPage extends StatelessWidget {
  TabPage({Key? key}) : super(key: key);
  final _TabPageController = Get.put(TabPageController());

  @override
  Widget build(BuildContext context) {
    return GetX<TabPageController>(
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
              bottomNavigationBar: BottomNavigationBar(
                  // showSelectedLabels: false,
                  // showUnselectedLabels: false,
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
                      icon: Icon(Icons.home_outlined),
                    ),
                    BottomNavigationBarItem(
                      label: '즐겨찾기',
                      icon: Icon(Icons.bookmark_border),
                    ),
                    // BottomNavigationBarItem(
                    //   label: '그룹',
                    //   icon: Icon(Icons.add_alarm),
                    // ),
                    BottomNavigationBarItem(
                      label: '마이페이지',
                      icon: Icon(Icons.person_outline),
                    ),
                  ]),
            ));
  }
}
