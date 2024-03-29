import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_controller.dart';
import 'package:myapp/page/favorite/folder/select_folder_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_abstract_model.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:myapp/page/share/share_template.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_share.dart';

class BottomsheetPage extends StatefulWidget {

  BottomsheetPage({Key? key}) : super(key: key);

  @override
  State<BottomsheetPage> createState() => _BottomsheetPageState();
}

class _BottomsheetPageState extends State<BottomsheetPage> {

  final _NaverMapPageController = Get.put(NaverMapPageController());
  final _FavoritePageController = Get.put(FavoritePageController());

  List<bool> ToggleSelected  = [false, false, false];

  @override
  void dispose() {
    // _FavoritePageController.dispose();
    Hive.box('favorite').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        padding: EdgeInsets.only(top: 22, bottom: 22, left: 28, right: 28),
        width: width,
        height: 225,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Obx(() {
          return _NaverMapPageController.selectedDetailRestaurant.value.uid == ''
              ? Center(child: CircularProgressIndicator(color: Color(0xfff42957)))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 36,
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${_NaverMapPageController.selectedDetailRestaurant.value.store_name}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ), // 타로야
                        SizedBox(
                          width: 3,
                        ),
                        if (_NaverMapPageController.selectedDetailRestaurant.value.open == 'open')
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
                        else if (_NaverMapPageController.selectedDetailRestaurant.value.open == 'closed')
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
                        else if (_NaverMapPageController.selectedDetailRestaurant.value.open == 'breaktime')
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
                          else if (_NaverMapPageController.selectedDetailRestaurant.value.open == 'None')
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
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              for (int i = 0; i < _NaverMapPageController.selectedDetailRestaurant.value.category.length; i++)
                                if (i == _NaverMapPageController.selectedDetailRestaurant.value.category.length - 1)
                                  Text(
                                    '${_NaverMapPageController.selectedDetailRestaurant.value.category[i]}',
                                    style: TextStyle(color: Colors.grey, fontSize: 14),
                                  )
                                else
                                  Text(
                                    '${_NaverMapPageController.selectedDetailRestaurant.value.category[i]}, ',
                                    style: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                              Text(
                                '  |  ${_NaverMapPageController.selectedDetailRestaurant.value.distance}km',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ), // 이자카야 | 1.5km
                      ],
                    ),
                  ), // 음식점 이름 및 분류
                  SizedBox(
                      width: 19.5,
                      height: 24,
                      child: _FavoritePageController.favoriteRestaurantUids.contains(_NaverMapPageController.selectedDetailRestaurant.value.uid)
                          ? IconButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: (){
                          _FavoritePageController.favoriteRestaurantUids.remove(_NaverMapPageController.selectedDetailRestaurant.value.uid);

                          Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');
                          List<FavoriteModel> favoriteFolders = favoriteBox.values.toList().cast<FavoriteModel>();
                          for (int i=0 ; i<favoriteFolders.length ; i++) {
                            for (int j=0 ; j<favoriteFolders[i].favoriteFolderRestaurantList.length ; j++) {
                              if (favoriteFolders[i].favoriteFolderRestaurantList[j].uid == _NaverMapPageController.selectedDetailRestaurant.value.uid) {
                                favoriteFolders[i].favoriteFolderRestaurantList.removeAt(j);
                                favoriteFolders[i].save();
                              }
                            }
                          }
                        },
                        icon: Image.asset('assets/button_image/favorite_button.png'),
                      )
                          : IconButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () {
                          setState(() {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return SelectFolderPage(selectedDetailRestaurant: _NaverMapPageController.selectedDetailRestaurant.value);
                                }
                            );
                          });
                        },
                        icon: Image.asset('assets/button_image/unfavorite_button.png'),
                      )
                  ) // 즐겨찾기
                ],
              ), // 음식점 이름 & 즐겨찾기
              SizedBox(height: 13),
              Container(
                height: 20,
                child: Row(
                    children: [
                      for (int i = 0; i < _NaverMapPageController.selectedDetailRestaurant.value.theme.length; i++)
                        Text(
                          '#${_NaverMapPageController.selectedDetailRestaurant.value.theme[i]} ',
                          style: TextStyle(fontSize: 13, color: Color(0xff57dde0)),
                        )
                    ]
                ),
              ), // 분위기
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xfff42957),
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${_NaverMapPageController.selectedDetailRestaurant.value.naver_star}',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '|',
                    style: TextStyle(fontSize: 17, color: Colors.black26),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${_NaverMapPageController.selectedDetailRestaurant.value.naver_cnt}건',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  )
                ],
              ), // 별점
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Color(0xfff42957),
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Row(
                            children: [
                              for (int i = 0; i < _NaverMapPageController.selectedDetailRestaurant.value.service.length; i++)
                                if (i == _NaverMapPageController.selectedDetailRestaurant.value.service.length - 1)
                                  Text(
                                    '${_NaverMapPageController.selectedDetailRestaurant.value.service[i]}',
                                    style: TextStyle(fontSize: 13, color: Colors.black87),
                                  )
                                else
                                  Text(
                                    '${_NaverMapPageController.selectedDetailRestaurant.value.service[i]}, ',
                                    style: TextStyle(fontSize: 13, color: Colors.black87),
                                  )
                            ]
                        ),
                      ],
                    ),
                  ),
                ],
              ), // 서비스
              SizedBox(height: 18),
              Container(
                height: 35,
                child: ToggleButtons(
                  fillColor: Colors.white,
                  highlightColor: Colors.transparent,
                  onPressed: (int index) async {
                    setState(() {
                      for (int i = 0; i < ToggleSelected.length; i++) {
                        ToggleSelected[i] = i == index;
                      }
                    });
                    if (ToggleSelected[0]) {
                      launch("tel://" + _NaverMapPageController.selectedDetailRestaurant.value.call);
                    } else if (ToggleSelected[1]) {
                      final LocationTemplate defaultFeed = LocationTemplate(
                        address: _NaverMapPageController.selectedDetailRestaurant.value.jibun_address,
                        content: Content(
                          title: _NaverMapPageController.selectedDetailRestaurant.value.store_name,
                          description: _NaverMapPageController.selectedDetailRestaurant.value.category.join(', ').replaceAll("[", "").replaceAll("]", ""),
                          imageUrl: Uri.parse(_NaverMapPageController.selectedDetailRestaurant.value.store_image[0]),
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
                    } else if (ToggleSelected[2]) {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 220,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Text(
                                      '길찾기 앱을 선택해주세요',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            KakaoMapUtils.OpenKakaoMap(_NaverMapPageController.selectedDetailRestaurant.value.jibun_address + ' ' + _NaverMapPageController.selectedDetailRestaurant.value.store_name);
                                          },
                                          child: Container(
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage('assets/direction_image/kakao_map.png'),
                                                  radius: 40,
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    '카카오맵'
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            GoogleMapUtils.OpenGoogleMap(_NaverMapPageController.selectedDetailRestaurant.value.jibun_address + ' ' + _NaverMapPageController.selectedDetailRestaurant.value.store_name);
                                          },
                                          child: Container(
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage('assets/direction_image/google_map.png'),
                                                  radius: 40,
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    '구글 지도'
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            NaverMapUtils.OpenNaverMap(_NaverMapPageController.selectedDetailRestaurant.value.jibun_address + ' ' + _NaverMapPageController.selectedDetailRestaurant.value.store_name);
                                          },
                                          child: Container(
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage('assets/direction_image/naver_map.png'),
                                                  radius: 40,
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    '네이버 지도'
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                  },
                  isSelected: ToggleSelected,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  children: [
                    Container(
                        width: (width - 57) * 0.33,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15,
                              height: 15,
                              child: Image.asset('assets/button_image/call_button.png'),
                            ),
                          ],
                        )),
                    Container(
                        width: (width - 57) * 0.33,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15,
                              height: 15,
                              child: Image.asset('assets/button_image/share_button.png'),
                            ),
                          ],
                        )),
                    Container(
                      width: (width - 57) * 0.33,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: Image.asset('assets/button_image/navigation_button.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ) // toggle button
            ],
          );
        })
    );
  }
}

class GoogleMapUtils {
  GoogleMapUtils._();

  static Future<void> OpenGoogleMap(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
class KakaoMapUtils {
  KakaoMapUtils._();

  static Future<void> OpenKakaoMap(String address) async {
    String kakaoUrl = 'daummaps://search?&q=$address';
    if (await canLaunch(kakaoUrl)) {
      await launch(kakaoUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
class NaverMapUtils {
  NaverMapUtils._();

  static Future<void> OpenNaverMap(String address) async {
    String naverUrl = 'nmap://search?query=$address&appname=com.example.myapp';
    if (await canLaunch(naverUrl)) {
      await launch(naverUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}