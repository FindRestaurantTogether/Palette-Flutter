import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/group/friend/friend_page_controller.dart';

class EditFriendPage extends StatefulWidget {
  const EditFriendPage({Key? key}) : super(key: key);

  @override
  State<EditFriendPage> createState() => _EditFriendPageState();
}

class _EditFriendPageState extends State<EditFriendPage> {

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
                  height: 149,
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
                  child: GetBuilder<FriendPageController>(
                    builder: (_FriendPageController) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              _FriendPageController.isSelectedFriendsPart
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _FriendPageController.isSelectedFriendsPartChangeState();
                                        });
                                      },
                                      child: Row(
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
                                      ),
                                  )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _FriendPageController.isSelectedFriendsPartChangeState();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            ' 선택 인원',
                                            style: TextStyle(
                                                fontSize: 15
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${_FriendPageController.selectedFriends.length}',
                                            style: TextStyle(
                                                fontSize: 13,
                                            ),
                                          )
                                        ],
                                      ),
                                  ),
                              SizedBox(width: 10),
                              Container(
                                width: 1,
                                height: 15,
                                color: Colors.grey,
                              ), // 새로선
                              SizedBox(width: 10),
                              _FriendPageController.isSelectedFriendsPart
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _FriendPageController.isSelectedFriendsPartChangeState();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                            Text(
                                              '초대 수락 대기',
                                              style: TextStyle(
                                                  fontSize: 15
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${_FriendPageController.waitForAcceptanceFriends.length}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                              ),
                                            )
                                        ],
                                      ),
                                  )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _FriendPageController.isSelectedFriendsPartChangeState();
                                        });
                                      },
                                      child: Row(
                                          children: [
                                            Text(
                                              '초대 수락 대기',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${_FriendPageController.waitForAcceptanceFriends.length}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                      ),
                                  ),
                            ],
                          ), // 선택인원과 숫자
                          _FriendPageController.isSelectedFriendsPart
                              ? Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.all(3),
                                  itemCount: _FriendPageController.selectedFriends.length,
                                  itemBuilder: (context, index){
                                    return Row(
                                      children: [
                                        Column(
                                            children: [
                                              SizedBox(height: 12),
                                              ClipOval(
                                                child: Container(
                                                  width: 45,
                                                  height: 45,
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: AssetImage(_FriendPageController.selectedFriends[index].image),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${_FriendPageController.selectedFriends[index].name}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13
                                                ),
                                              )
                                            ]
                                        ),
                                        SizedBox(width: 10)
                                      ],
                                    );
                                  },
                                ),
                              )
                              : Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.all(3),
                              itemCount: _FriendPageController.waitForAcceptanceFriends.length,
                              itemBuilder: (context, index){
                                return Row(
                                  children: [
                                    Column(
                                        children: [
                                          SizedBox(height: 12),
                                          ClipOval(
                                            child: Container(
                                              width: 45,
                                              height: 45,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundImage: AssetImage(_FriendPageController.waitForAcceptanceFriends[index].image),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${_FriendPageController.waitForAcceptanceFriends[index].name}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13
                                            ),
                                          )
                                        ]
                                    ),
                                    SizedBox(width: 10)
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
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
                        ),
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
                  padding: EdgeInsets.all(3),
                  itemCount: _FriendPageController.friends.length,
                  itemBuilder: (context, index){
                    return friendListView(
                        _FriendPageController.friends[index].image,
                        _FriendPageController.friends[index].name,
                        index
                    );
                  },
                ),
              ),
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

  Widget friendListView(String image, String name, int index) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(image),
                ),
                SizedBox(width: 15),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54
                  ),
                )
              ],
            ), // 아바타 & 이름
            SizedBox(width: 95),
            Container(
              width: 68,
              height: 28,
              child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1, color: Colors.blueAccent),
                      backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
                      shape: StadiumBorder()
                  ),
                  child: Text(
                    '초대완료',
                    style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                  )
              ),
            )
          ],
        ),
      ],
    );
  }
}
