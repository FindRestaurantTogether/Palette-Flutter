import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:myapp/page/detail/menu/menu_page.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_controller.dart';
import 'package:myapp/page/favorite/folder/select_folder_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  final _FavoritePageController = Get.put(FavoritePageController());

  final DetailNaverMapPageRestaurant selectedDetailRestaurant = Get.arguments;

  List<bool> ToggleSelected  = [false, false, false];

  bool moreOpenInformation = false;

  @override
  void dispose() {
    // _FavoritePageController.dispose();
    Hive.box('favorite').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final menuName = selectedDetailRestaurant.menu.keys.toList();
    final menuPrice = selectedDetailRestaurant.menu.values.toList();

    final openDay = selectedDetailRestaurant.opening_hour.keys.toList();
    final openHour = selectedDetailRestaurant.opening_hour.values.toList();

    final breaktimeDay = selectedDetailRestaurant.opening_breaktime.keys.toList();
    final breaktimeHour = selectedDetailRestaurant.opening_breaktime.values.toList();

    final lastorderDay = selectedDetailRestaurant.opening_lastorder.keys.toList();
    final lastorderHour = selectedDetailRestaurant.opening_lastorder.values.toList();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              if (selectedDetailRestaurant.store_image.length != 0)
                Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    height: height * 0.32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(selectedDetailRestaurant.store_image[0]),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
              ), // 배경화면
              Column(
                children: [
                  SizedBox(height: height * 0.17), // 빈 공간
                  Center(
                    child: Container(
                      width: width * 0.87,
                      padding: EdgeInsets.only(top: 22, bottom: 30, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 27,
                                      height: 34,
                                      child: IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Image.asset('assets/button_image/back_button.png'),
                                      ),
                                    ), // 뒤로가기 버튼
                                    Row(
                                      children: [
                                        Obx(() {
                                          return SizedBox(
                                              width: 19.5,
                                              height: 24,
                                              child: _FavoritePageController.favoriteRestaurantUids.contains(selectedDetailRestaurant.uid)
                                                  ? IconButton(
                                                padding: EdgeInsets.all(0.0),
                                                onPressed: (){
                                                  _FavoritePageController.favoriteRestaurantUids.remove(selectedDetailRestaurant.uid);

                                                  Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');
                                                  List<FavoriteModel> favoriteFolders = favoriteBox.values.toList().cast<FavoriteModel>();
                                                  for (int i=0 ; i<favoriteFolders.length ; i++) {
                                                    for (int j=0 ; j<favoriteFolders[i].favoriteFolderRestaurantList.length ; j++) {
                                                      if (favoriteFolders[i].favoriteFolderRestaurantList[j].uid == selectedDetailRestaurant.uid) {
                                                        favoriteFolders[i].favoriteFolderRestaurantList.removeAt(j);
                                                      }
                                                    }
                                                  }
                                                },
                                                icon: Image.asset('assets/button_image/favorite_button.png'),
                                              )
                                                  : IconButton(
                                                padding: EdgeInsets.all(0.0),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return SelectFolderPage(selectedDetailRestaurant: selectedDetailRestaurant);
                                                      }
                                                  );
                                                },
                                                icon: Image.asset('assets/button_image/unfavorite_button.png'),
                                              )
                                          );
                                        }),
                                        SizedBox(width: 6)
                                      ],
                                    ) // 즐겨찾기 버튼
                                  ],
                                ), // 뒤로가기 버튼, 즐겨찾기 버튼
                                Container(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          '   ${selectedDetailRestaurant.store_name}',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ), // 음식점 이름
                                      SizedBox(
                                        width: 3,
                                      ),
                                      if (selectedDetailRestaurant.open == 'open')
                                        Container(
                                          height: 32,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff57dde0),
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        )
                                      else if (selectedDetailRestaurant.open == 'close')
                                        Container(
                                          height: 32,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff42957),
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        )
                                      else if (selectedDetailRestaurant.open == 'breaktime')
                                        Container(
                                            height: 32,
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                          )
                                      else if (selectedDetailRestaurant.open == 'null')
                                        Container(
                                              height: 32,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ), // 음식점 이름
                              ],
                            )
                          ), // 뒤로가기 버튼, 음식점 이름, 즐겨찾기 버튼
                          SizedBox(height: 5), // 빈 공간
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xfff42957),
                                  size: 16,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  ' ${selectedDetailRestaurant.naver_star}(${selectedDetailRestaurant.naver_cnt})',
                                  style:
                                  TextStyle(fontSize: 15),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '|',
                                  style: TextStyle(fontSize: 15, color: Colors.black87),
                                ),
                                SizedBox(width: 6),
                                for (int i = 0; i < selectedDetailRestaurant.category.length; i++)
                                  if (i == 0)
                                    Text(
                                      '${selectedDetailRestaurant.category[i]}',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  else
                                    Text(
                                      ',${selectedDetailRestaurant.category[i]}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                SizedBox(width: 3),
                              ],
                            ),
                          ), // 별점, 중분류
                          SizedBox(height: 14), // 빈 공간
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < selectedDetailRestaurant.theme.length; i++)
                                  Text(
                                    '#${selectedDetailRestaurant.theme[i]} ',
                                    style: TextStyle(fontSize: 12, color: Color(0xff57dde0)),
                                  )
                              ]
                          ), // #분위기
                          SizedBox(height: 12), // 빈 공간
                          Container(
                            width: width * 0.67,
                            padding: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black45,
                                    width: 1,
                                  ),
                                )
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: Color(0xff57dde0),
                                        size: 16,
                                      ),
                                      SizedBox(width: 6), // 빈 공간
                                      if (selectedDetailRestaurant.open == 'open') ... [
                                        Text(
                                          '영업중',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            // color: selectedRestaurant.open ? Color(0xff57dde0) : Color(0xfff42957),
                                          ),
                                        ) // 영업시간
                                      ]
                                      else if (selectedDetailRestaurant.open == 'close') ... [
                                        Text(
                                          '영업종료',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            // color: selectedRestaurant.open ? Color(0xff57dde0) : Color(0xfff42957),
                                          ),
                                        ),
                                      ]
                                      else if (selectedDetailRestaurant.open == 'breaktime') ... [
                                          Text(
                                            '브레이크타임',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              // color: selectedRestaurant.open ? Color(0xff57dde0) : Color(0xfff42957),
                                            ),
                                          ),
                                      ]
                                      else if (selectedDetailRestaurant.open == 'null') ... [
                                          Text(
                                            '정보없음',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              // color: selectedRestaurant.open ? Color(0xff57dde0) : Color(0xfff42957),
                                            ),
                                          ),
                                      ],
                                      SizedBox(width: 0), // 빈 공간
                                      Container(
                                        width: 20,
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              moreOpenInformation = !moreOpenInformation;
                                            });
                                          },
                                          icon: moreOpenInformation ? Icon(Icons.keyboard_arrow_up, size: 16) : Icon(Icons.keyboard_arrow_down, size: 16),
                                        ),
                                      ), // 더 보기 버튼
                                    ],
                                  ),
                                ),
                                if (selectedDetailRestaurant.open != 'null')// 영업시간
                                  moreOpenInformation
                                      ? Container(
                                          width: width * 0.67,
                                          padding: EdgeInsets.only(left: 22),
                                          child:  Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (openDay.length != 0)
                                                Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Text(
                                                      '영업시간',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                  SizedBox(height: 3),
                                                  for (var i=0; i<openDay.length ; i++) ... [
                                                    Text(
                                                      '${openDay[i]} : ${openHour[i]}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ],
                                              ), // 영업시간
                                              if (breaktimeDay.length != 0)
                                                Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Text(
                                                      '브레이크타임',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                  SizedBox(height: 3),
                                                  for (var i=0; i<breaktimeDay.length ; i++) ... [
                                                    Text(
                                                      '${breaktimeDay[i]} : ${breaktimeHour[i]}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ],
                                              ), // 브레이크타임
                                              if (lastorderDay.length != 0)
                                                Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Text(
                                                      '라스트오더',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                  SizedBox(height: 3),
                                                  for (var i=0; i<lastorderDay.length ; i++) ... [
                                                    Text(
                                                      '${lastorderDay[i]} : ${lastorderHour[i]}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ]
                                                ],
                                              ), // 라스트 오더
                                            ],
                                          ),
                                      )
                                      : SizedBox(),
                                SizedBox(height: 6),
                                Container(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Color(0xff57dde0),
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          '${selectedDetailRestaurant.jibun_address}',
                                          style: TextStyle(fontSize: 12)
                                      ),
                                    ],
                                  ),
                                ), // 주소
                                SizedBox(height: 6),
                                Container(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: Color(0xff57dde0),
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Row(
                                          children: [
                                            for (int i = 0; i < selectedDetailRestaurant.service.length; i++)
                                              if (i == selectedDetailRestaurant.service.length - 1)
                                                Text(
                                                  '${selectedDetailRestaurant.service[i]}',
                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                )
                                              else
                                                Text(
                                                  '${selectedDetailRestaurant.service[i]}, ',
                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                )
                                          ]
                                      ),
                                    ],
                                  ),
                                ), // 서비스
                                SizedBox(height: 15),
                                Center(
                                  child: Container(
                                    height: 30,
                                    child: ToggleButtons(
                                      children: [
                                        Container(
                                            width: width * 0.655 / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child: Image.asset('assets/button_image/call_button.png'),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                            width: width * 0.655 / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child: Image.asset('assets/button_image/share_button.png'),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          width: width * 0.655 / 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 12,
                                                height: 12,
                                                child: Image.asset('assets/button_image/navigation_button.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      highlightColor: Colors.transparent,
                                      fillColor: Colors.white,
                                      onPressed: (int index) {
                                        setState(() async {
                                          for (int i = 0; i < ToggleSelected.length; i++) {
                                            ToggleSelected[i] = i == index;
                                          }

                                          if (ToggleSelected[0]) {
                                            launch("tel://" + selectedDetailRestaurant.call);
                                          } else if (ToggleSelected[1]) {
                                            final FeedTemplate defaultFeed = FeedTemplate(
                                              content: Content(
                                                title: '${selectedDetailRestaurant.store_name}',
                                                description: '#케익 #딸기 #삼평동 #카페 #분위기 #소개팅',
                                                imageUrl: Uri.parse(
                                                    'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
                                                link: Link(
                                                    webUrl: Uri.parse('https://developers.kakao.com'),
                                                    mobileWebUrl: Uri.parse('https://developers.kakao.com')),
                                              ),
                                              itemContent: ItemContent(
                                                profileText: 'Kakao',
                                                profileImageUrl: Uri.parse(
                                                    'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
                                                titleImageUrl: Uri.parse(
                                                    'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
                                                titleImageText: 'Cheese cake',
                                                titleImageCategory: 'cake',
                                                items: [
                                                  ItemInfo(item: 'cake1', itemOp: '1000원'),
                                                  ItemInfo(item: 'cake2', itemOp: '2000원'),
                                                  ItemInfo(item: 'cake3', itemOp: '3000원'),
                                                  ItemInfo(item: 'cake4', itemOp: '4000원'),
                                                  ItemInfo(item: 'cake5', itemOp: '5000원')
                                                ],
                                                sum: 'total',
                                                sumOp: '15000원',
                                              ),
                                              social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
                                              buttons: [
                                                Button(
                                                  title: '웹으로 보기',
                                                  link: Link(
                                                    webUrl: Uri.parse('https: //developers.kakao.com'),
                                                    mobileWebUrl: Uri.parse('https: //developers.kakao.com'),
                                                  ),
                                                ),
                                                Button(
                                                  title: '앱으로보기',
                                                  link: Link(
                                                    androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
                                                    iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
                                                  ),
                                                ),
                                              ],
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
                                                                  KakaoMapUtils.OpenKakaoMap(selectedDetailRestaurant.jibun_address + ' ' + selectedDetailRestaurant.store_name);
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
                                                                  GoogleMapUtils.OpenGoogleMap(selectedDetailRestaurant.jibun_address + ' ' + selectedDetailRestaurant.store_name);
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
                                                                  NaverMapUtils.OpenNaverMap(selectedDetailRestaurant.jibun_address + ' ' + selectedDetailRestaurant.store_name);
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
                                        });
                                      },
                                      isSelected: ToggleSelected,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ), // 토글버튼
                              ],
                            ),
                          ) // 영업시간, 주소, 서비스, 토글버튼
                        ],
                      ),
                    ),
                  ), // 위에 큰 박스
                  SizedBox(height: 30), // 빈 공간
                  Container(
                    width: width * 0.87,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '메뉴',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => MenuPage(), arguments: selectedDetailRestaurant);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '전체보기',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 14,
                                  )
                                ],
                              ),
                            )
                          ],
                        ), // 메뉴 & 전체보기
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: selectedDetailRestaurant.menu.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Text(
                                            '${menuName[index]}',
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            ' ${menuPrice[index]}원',
                                            style: TextStyle(fontSize: 15, color: Color(0xfff42957), fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (index != selectedDetailRestaurant.menu.length - 1)
                                    VerticalDivider(width: 30, color: Colors.black45)
                                ],
                              );
                            },
                          ),
                        ), // 메뉴들
                      ],
                    ),
                  ), // 메뉴
                  Divider(indent: 35, endIndent: 35, color: Colors.black45), // 회색선
                  SizedBox(height: 25), // 빈 공간
                  Container(
                    width: width * 0.87,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '평점 및 리뷰',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ), // 평점 및 리뷰
                        SizedBox(height: 20),
                        Column(
                          children: [
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final naverReviewUrl = Uri.parse('https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll');
                                  if (await canLaunchUrl(naverReviewUrl)) {
                                    await launchUrl(naverReviewUrl);
                                  } else {
                                    throw 'Could not open the naverReviewUrl.';
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10
                                        ),
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Image.asset('assets/button_image/naver_button.png'),
                                        ),
                                        SizedBox(
                                            width: 20
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '네이버 리뷰',
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ), // 아이콘, 네이버 리뷰
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff42957),
                                              size: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              selectedDetailRestaurant.naver_star.toString(),
                                              style: TextStyle(fontSize: 13, color: Color(0xfff42957)),
                                            ),
                                          ],
                                        ), // 별점
                                        SizedBox(
                                            width: 15
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${selectedDetailRestaurant.naver_cnt.toString()}건',
                                              style: TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                              size: 14,
                                            )
                                          ]
                                        ), // 리뷰 개수
                                        SizedBox(width: 7)
                                      ],
                                    ) // 별점, 리뷰 개수
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ), // 네이버 리뷰
                            SizedBox(height: 12),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final googleReviewUrl = Uri.parse('https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko');
                                  if (await canLaunchUrl(googleReviewUrl)) {
                                  await launchUrl(googleReviewUrl);
                                  } else {
                                  throw 'Could not open the googleReviewUrl.';
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 10
                                        ),
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Image.asset('assets/button_image/google_button.png'),
                                        ),
                                        SizedBox(
                                            width: 20
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '구글 리뷰',
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ), // 아이콘, 구글 리뷰
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff42957),
                                              size: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              selectedDetailRestaurant.google_star.toString(),
                                              style: TextStyle(fontSize: 13, color: Color(0xfff42957)),
                                            ),
                                          ],
                                        ), // 별점
                                        SizedBox(
                                            width: 15
                                        ),
                                        Row(
                                            children: [
                                              Text(
                                                '${selectedDetailRestaurant.google_cnt.toString()}건',
                                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.grey,
                                                size: 14,
                                              )
                                            ]
                                        ), // 리뷰 개수
                                        SizedBox(width: 7)
                                      ],
                                    ) // 별점, 리뷰 개수
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ), // 구글 리뷰
                            SizedBox(height: 12),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final kakaoReviewUrl = Uri.parse('https://place.map.kakao.com/m/11101743#comment');
                                  if (await canLaunchUrl(kakaoReviewUrl)) {
                                  await launchUrl(kakaoReviewUrl);
                                  } else {
                                  throw 'Could not open the kakaoReviewUrl.';
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 10
                                        ),
                                        SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: Image.asset('assets/button_image/kakao_button.png'),
                                        ),
                                        SizedBox(
                                            width: 20
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '카카오 리뷰',
                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ), // 아이콘, 카카오 리뷰
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xfff42957),
                                              size: 15,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              selectedDetailRestaurant.kakao_star.toString(),
                                              style: TextStyle(fontSize: 13, color: Color(0xfff42957)),
                                            ),
                                          ],
                                        ), // 별점
                                        SizedBox(
                                            width: 15
                                        ),
                                        Row(
                                            children: [
                                              Text(
                                                '${selectedDetailRestaurant.kakao_cnt.toString()}건',
                                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.grey,
                                                size: 14,
                                              )
                                            ]
                                        ), // 리뷰 개수
                                        SizedBox(width: 7)
                                      ],
                                    ) // 별점, 리뷰 개수
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ), // 카카오 리뷰
                            SizedBox(height: 20),
                          ],
                        )
                      ],
                    ),
                  ), // 평점 및 리뷰
                ],
              ), // 나머지
            ],
          ),
        )
      )
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