import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/group/friend/add_friend_page.dart';
import 'package:myapp/page/group/friend/friend_page_controller.dart';
import 'package:myapp/page/group/group_page_controller.dart';
import 'package:intl/intl.dart';
import 'package:myapp/page/group/group_page_model.dart';

class AddGroupPage extends StatefulWidget {

  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {

  final _GroupPageController = Get.put(GroupPageController());
  final _FriendPageController = Get.put(FriendPageController());
  final _TextEditingController = TextEditingController();

  bool checkCalender = false;
  bool checkAlarm = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 460,
        padding: EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0,10),
                        blurRadius: 10,
                        spreadRadius: 0
                    )
                  ]
              ),
              child: TextFormField(
                controller: _TextEditingController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '그룹 이름을 정해주세요!',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black38,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ), // 택스트폼
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '   함께할 친구',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ), // 함께할 친구
            SizedBox(height: 5),
            Obx(() {
              return Expanded(
                  child: _FriendPageController.selectedFriends.isEmpty
                      ? Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                                color: Colors.transparent,
                                child: AddFriendPage()
                            );
                          },
                        );
                      },
                      child: Icon(Icons.add, color: Colors.black, size: 20),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: Colors.white
                      ),
                    ),
                  )
                      : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(3),
                    itemCount: _FriendPageController.selectedFriends.length,
                    itemBuilder: (context, index){
                      return selectedFriendListView(_FriendPageController.selectedFriends[index].image);
                    },
                  )
              );
            }), // 선택된 친구들
            Row(
              children: [
                Checkbox(
                  value: checkCalender,
                  onChanged: (bool? value) {
                    setState(() {
                      checkCalender = value!;
                    });
                  },
                  shape: CircleBorder(),
                  checkColor: Colors.white,
                  activeColor: Colors.blue,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: checkCalender
                      ? Text(
                        '날짜',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      )
                      : Text(
                        '날짜',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black12
                        ),
                      ),
                ),
              ],
            ), // 날짜 선택
            SizedBox(height: 5),
            Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () => _GroupPageController.chooseDate(),
                    child: Container(
                        width: 200,
                        height: 20,
                        child: checkCalender
                            ? Text(
                          DateFormat('    yyyy년 MM월 dd일').format(_GroupPageController.selectedDate.value).toString(),
                          style: TextStyle(fontSize: 19),
                        )
                            : IgnorePointer(
                              child: Text(
                                DateFormat('    yyyy년 MM월 dd일').format(_GroupPageController.selectedDate.value).toString(),
                                style: TextStyle(fontSize: 19, color: Colors.black12),
                              ),
                            )
                    )
                )
            ), // 날짜
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: checkAlarm,
                  onChanged: (bool? value) {
                    setState(() {
                      checkAlarm = value!;
                    });
                  },
                  shape: CircleBorder(),
                  checkColor: Colors.white,
                  activeColor: Colors.blue,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: checkAlarm
                      ? Text(
                        '알림 여부',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      )
                      : Text(
                        '알림 여부',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black12,
                            fontSize: 20
                        ),
                      ),
                ),
              ],
            ), // 알림 여부
            SizedBox(height: 30),
            Container(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _GroupPageController.groups.add(
                        groupModel(
                            groupName: _TextEditingController.text,
                            groupCheckCalender: checkCalender,
                            groupDate: DateFormat('yyyy년 MM월 dd일').format(_GroupPageController.selectedDate.value).toString(),
                            groupCheckAlarm: checkAlarm,
                            groupFriendsList: _FriendPageController.selectedFriends
                        )
                    );
                  _GroupPageController.selectedDate.value = DateTime.now();
                  Navigator.pop(context);
                },
                child: Text('확인'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ) // 확인박스
          ],
        ),
    );
  }
  Widget selectedFriendListView(String image) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Material(
                color: Colors.transparent,
                child: AddFriendPage()
            );
          },
        );
      },
      child: Row(
        children: [
          SizedBox(width: 25),
          Align(
            widthFactor: 0.2,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 21,
                backgroundImage: AssetImage(image),
              ),
            ),
          )
        ],
      ),
    );
  }
}

