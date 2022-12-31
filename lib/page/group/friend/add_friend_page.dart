import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/group/friend/add_friend_page_model.dart';
import 'package:myapp/page/group/friend/friend_page_controller.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {

  final _FriendPageController = Get.put(FriendPageController());

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Container(
                width: 300,
                height: 500,
                padding: EdgeInsets.only(top: 20, bottom: 20, right: 15, left: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  children: [
                    Container(
                        height: 150,
                        padding: EdgeInsets.only(left: 20, right: 20, top: 22, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5, // soften the shadow
                                spreadRadius: 5, //extend the shadow
                                offset: Offset(
                                  5.0, // Move to right 5  horizontally
                                  5.0, // Move to bottom 5 Vertically
                                ),
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  ' 선택 인원',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${_FriendPageController.selectedFriends.length}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ), // 선택인원과 숫자
                            Expanded(
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(3),
                                    itemCount: _FriendPageController.selectedFriends.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return selectedFriendListView(
                                          _FriendPageController.selectedFriends[index].image,
                                          _FriendPageController.selectedFriends[index].name,
                                          _FriendPageController.selectedFriends[index].selected,
                                          index
                                      );
                                    }
                                )
                            )
                          ],
                        )
                    ), // top box
                    SizedBox(height: 20),
                    Container(
                      width: 271,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '   친구',
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                              Text(
                                ' ${_FriendPageController.friends.length}',
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              )
                            ],
                          ), // 친구 & 수
                          SizedBox(width: 5),
                          Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.grey.withOpacity(0.1),
                            child: Container(
                              width: 190,
                              height: 30,
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ), // search
                        ],
                      ),
                    ), // 친구 수 & search
                    Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _FriendPageController.friends.length,
                            itemBuilder: (BuildContext context, int index) {
                              return friendListView(
                                  _FriendPageController.friends[index].image,
                                  _FriendPageController.friends[index].name,
                                  _FriendPageController.friends[index].selected,
                                  index
                              );
                            }
                        )
                    ), // 친구 목록
                    SizedBox(height: 10),
                    Container(
                      width: 260,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            '확인'
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ) // 확인박스
                  ],
                )
            ),
    );
  }

  Widget friendListView(String image, String name, bool selected, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(image),
      ),
      title: Text(
        name,
        style: TextStyle(
            fontSize: 15,
            color: Colors.black54
        ),
      ),
      trailing: selected
          ? Icon(
            Icons.check_circle,
            color: Colors.blue,
          )
          : Icon(
            Icons.circle_outlined,
            color: Colors.grey,
          ),
      onTap: () {
        setState(() {
          _FriendPageController.friends[index].selected = !_FriendPageController.friends[index].selected;
          if (_FriendPageController.friends[index].selected == true) {
            _FriendPageController.selectedFriends.add(friendModel(image: image, name: name, selected: true));
          } else if (_FriendPageController.friends[index].selected == false) {
            _FriendPageController.selectedFriends.removeWhere((e) => e.name == _FriendPageController.friends[index].name);
          }
        });
      },
    );
  }
  Widget selectedFriendListView(String image, String name, bool selected, int index) {
    return Row(
      children: [
        Column(
            children: [
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _FriendPageController.friends[_FriendPageController.friends.indexWhere((e) => e.name == name)].selected = !_FriendPageController.friends[_FriendPageController.friends.indexWhere((e) => e.name == name)].selected;
                    _FriendPageController.selectedFriends.removeWhere((e) => e.name == name);
                  });
                },
                child: Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 45,
                        height: 45,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(image),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.close, size: 10, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ]
        ),
        SizedBox(width: 10)
      ],
    );
  }
}