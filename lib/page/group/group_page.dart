import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myapp/page/group/friend/add_friend_page_model.dart';
import 'package:myapp/page/group/add_group_page.dart';
import 'package:myapp/page/group/friend/edit_friend_page.dart';
import 'package:myapp/page/group/friend/friend_page_controller.dart';
import 'package:myapp/page/group/group_page_controller.dart';
import 'package:myapp/page/group/edit_group_page.dart';
import 'package:myapp/page/group/notification/notification_page.dart';

final List<String> DropdownList = ['최신순'];

class GroupPage extends StatefulWidget {
  GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  final _GroupPageController = Get.put(GroupPageController());
  final _FriendPageController = Get.put(FriendPageController());

  bool isGroup = true;

  String? DropdownSelected = DropdownList.first;

  List<String> inviteAvatar = [
    'assets/login_image/food.png',
    'assets/login_image/food.png',
    'assets/login_image/food.png',
  ];

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: height * 0.08),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGroup = true;
                          });
                        },
                        child: Container(
                          width: Get.width * 0.4,
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              '나의 그룹',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: isGroup ? Colors.black : Colors.grey.withOpacity(.60),
                              ),
                            ),
                          ),
                        ),
                      ), // 나의 그룹
                      Container(
                        width: 1,
                        height: 25,
                        color: Colors.grey,
                      ), // 새로선
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGroup = false;
                          });
                        },
                        child: Container(
                          width: 90,
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              "초대",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: !isGroup ? Colors.black : Colors.grey.withOpacity(.60),
                              ),
                            ),
                          ),
                        ),
                      ), // 초대
                      SizedBox(width: 70),
                      GestureDetector(
                          onTap: (){
                            Get.to(() => NotificationPage());
                          },
                          child: Icon(Icons.notifications)
                      ) // 알림
                    ],
                  ), // 상단 바
                  SizedBox(height: 3),
                  Container(
                    width: width,
                    height: 4,
                    color: Colors.black12,
                  ), // 회색 바
                  if (isGroup) ... [ // 나의 그룹
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white, shape: StadiumBorder(), elevation: 5),
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
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black26,
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
                    ), // 필터 버튼
                    SizedBox(height: 20),
                    Obx(() {
                      return Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _GroupPageController.groups.length,
                            itemBuilder: (BuildContext context, int index) {
                              return groupListView(
                                  _GroupPageController.groups[index].groupName,
                                  _GroupPageController.groups[index].groupCheckCalender,
                                  _GroupPageController.groups[index].groupDate,
                                  _GroupPageController.groups[index].groupCheckAlarm,
                                  _GroupPageController.groups[index].groupFriendsList,
                                  index
                              );
                            }
                        ),
                      );
                    }),
                  ] else ... [ // 초대
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        itemCount: inviteAvatar.length,
                        itemBuilder: (context, index){
                          return Container(
                            height: height * 0.14,
                            padding: EdgeInsets.only(left: 25, right: 25, top: height * 0.018),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 19,
                                                backgroundImage: AssetImage(inviteAvatar[index]),
                                              ),
                                              SizedBox(width: 15),
                                              Container(
                                                width: width * 0.56,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '지민',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                    Text(
                                                      '님이 ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                    Text(
                                                      '익선동 탐방',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                    Text(
                                                      '에 ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                    Text(
                                                      '초대하였습니다.',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          CircleAvatar(
                                            radius: 8.5,
                                            backgroundColor: Colors.pinkAccent,
                                            child: Icon(Icons.close, size: 10, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 53),
                                              Container(
                                                width: width * 0.26,
                                                height: height * 0.034,
                                                child: ElevatedButton(
                                                  onPressed: (){},
                                                  child: Text(
                                                    '수락',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                                                      elevation: MaterialStateProperty.all<double>(0)
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.01),
                                              Container(
                                                width: width * 0.26,
                                                height: height * 0.034,
                                                child: ElevatedButton(
                                                  onPressed: (){},
                                                  child: Text(
                                                    '거절',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
                                                      elevation: MaterialStateProperty.all<double>(0)
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: height * 0.034,
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              '10/20',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  child: Divider(
                                    color: Colors.black12,
                                    thickness: 1,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ]
                ],
              ),
              Positioned(
                right: 20,
                bottom: 30,
                child: Container(
                  width: 46,
                  height: 46,
                  child: FloatingActionButton(
                    heroTag: null,
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        _FriendPageController.selectedFriends.clear();
                      });
                      showMaterialModalBottomSheet(
                          isDismissible: true,
                          barrierColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return AddGroupPage();
                          }
                      );
                    },
                  ),
                ), // floating button -> add group bottomsheet
              ) // + button,
            ],
          ),
        ),
    );
  }

  Widget groupListView(String groupName, bool groupCheckCalender, String groupDate, bool groupCheckAlarm, List<friendModel> groupFriendsList, int index) {
    return Column(
      children: [
        Container(
          width: Get.width * 0.9,
          height: 125,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.red.shade50,
          ),
          child: Column(
            children: [
              Container(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      groupName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21
                      ),
                    ), // 그룹 이름
                    Row(
                      children: [
                        groupCheckCalender
                            ? Text(
                          groupDate,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14
                          ),
                        )
                            : Text(''), // 약속 날짜
                        SizedBox(width: 10),
                        GestureDetector(
                            onTap: (){
                              showMaterialModalBottomSheet(
                                  isDismissible: true,
                                  barrierColor: Colors.black54,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditGroupPage(index: index);
                                  }
                              );
                            },
                            child: Icon(Icons.edit, size: 21)
                        ), // edit group bottomsheet
                      ],
                    ),
                  ],
                ),
              ), // 익선동 탐방 & edit icon
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 180,
                        child: Row(
                          children: [
                            SizedBox(width: 7),
                            if (groupFriendsList.isNotEmpty) ... [
                              for(int i = 0 ; i < groupFriendsList.length; i++ )
                                Align(
                                  widthFactor: 0.5,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 9,
                                      backgroundImage: AssetImage(groupFriendsList[i].image),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 10),
                            ],
                            Text(
                              '${groupFriendsList.length}인',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13
                              ),
                            ), // 4인
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Material(
                                        color: Colors.transparent,
                                        child: EditFriendPage()
                                    );
                                  },
                                );
                              },
                              child: PhysicalModel(
                                color: Colors.grey,
                                elevation: 1,
                                shape: BoxShape.circle,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 10,
                                  child: Icon(Icons.add, color: Colors.black, size: 10),
                                ),
                              ),
                            ), // + 버튼
                          ],
                        ),
                      ),  // 아바타있는 2번째 줄
                      SizedBox(height: 7),
                      Container(
                        width: 180,
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              ' 3',
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                            SizedBox(width: 15),
                            Row(
                              children: [
                                Text(
                                  '리스트 보러 가기',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 14),
                              ],
                            ) // 리스트 보러가기 버튼
                          ],
                        ),
                      ) // 3번째 줄
                    ],
                  ), // 좌측 부분들
                  Container(
                    width: 76,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: (){},
                      child: Row(
                        children: [
                          Icon(Icons.map, color: Colors.black, size: 25),
                          SizedBox(width: 7),
                          Icon(Icons.arrow_forward_ios, color: Colors.black, size: 19),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.white
                      ),
                    ),
                  ), // 지도 버튼
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}



