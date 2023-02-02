import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/page/my/my_page.dart';
import 'package:myapp/page/my/my_page_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final _MyPageController = Get.put(MyPageController());
  final _TextEditingController = TextEditingController();

  User? loggedUser;
  String? loggedUserUid = '';
  String? loggedUserImageUrl = '';
  String? loggedUserName = '';
  String? loggedUserEmail = '';
  File? _pickedImage;
  String? url;
  bool imageUploadLoading = false;
  void getLoggedUserData() async {
    try {
      setState(() {
        imageUploadLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedUser = user;
      }
      loggedUserUid = loggedUser?.uid;

      final loggedUserDoc =  await FirebaseFirestore.instance.collection('users').doc(loggedUserUid).get();
      setState(() {
        loggedUserImageUrl = loggedUserDoc.get('imageUrl');
        loggedUserName = loggedUserDoc.get('name');
        loggedUserEmail = loggedUserDoc.get('id');
        imageUploadLoading = false;
      });
    } catch(e) {
      print(e);
    }
  } // 현재 유저 정보 조회 및 데이터 불러오기
  void currentUserLogOut() async {
    await FirebaseAuth.instance.signOut();
    _MyPageController.isLoginChangeState();
    Get.back();
  } // 로그아웃
  Future<void> deleteCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUid = currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).delete();

    final ref = FirebaseStorage.instance.ref().child('usersImages').child(loggedUserEmail! + '.jpg');
    await ref.delete();

    await currentUser?.delete();

    _MyPageController.isLoginChangeState();
    Get.back();
  } // 유저 삭제
  Future<void> updateCurrentUserName(String name) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUid = currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
      'name': name,
    });
  } // 이름 변경
  Future<void> resetCurrentUserPassword(String email) async{
    await FirebaseAuth.instance.setLanguageCode("kr");
    await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
  } // 비밀번호 변경
  Future<void> pickImageFromCameraAndUpdateCurrentUserImage() async{
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);

    setState(() {
      imageUploadLoading = true;
    });

    final ref = FirebaseStorage.instance.ref().child('usersImages').child(loggedUserEmail! + '.jpg');
    await ref.putFile(_pickedImage!);
    url = await ref.getDownloadURL();

    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUid = currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
      'imageUrl': url,
    });

    setState(() {
      loggedUserImageUrl = url;
      imageUploadLoading = false;
    });
  } // 카메라로 사진 변경
  void pickImageFromGalleryAndUpdateCurrentUserImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);

    setState(() {
      imageUploadLoading = true;
    });

    final ref = FirebaseStorage.instance.ref().child('usersImages').child(loggedUserEmail! + '.jpg');
    await ref.putFile(_pickedImage!);
    url = await ref.getDownloadURL();

    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUid = currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
      'imageUrl': url,
    });

    setState(() {
      loggedUserImageUrl = url;
      imageUploadLoading = false;
    });
  } // 갤러리로 사진 변경

  @override
  void initState() {
    super.initState();
    getLoggedUserData();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.off(() => MyPage());
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
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Row(
                        children: [
                          SizedBox(width: 30),
                          Container(
                            width: 27,
                            height: 45,
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                Get.off(() => MyPage());
                              },
                              icon: Image.asset('assets/button_image/back_button.png'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ), // 뒤로가기 버튼
                Container(
                  width: width,
                  height: 260,
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Color(0xfff42957),
                              child: imageUploadLoading
                                  ? CircleAvatar(
                                    radius: 53,
                                    backgroundColor: Colors.white,
                                    child: CircularProgressIndicator(color: Color(0xfff42957))
                                  )
                                  : CircleAvatar(
                                    radius: 53,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(loggedUserImageUrl!),
                                  )
                            ),
                            Positioned(
                                bottom: -5,
                                right: -25,
                                child: RawMaterialButton(
                                    fillColor: Color(0xfff42957),
                                    child: Icon(Icons.photo_camera, size: 18, color: Colors.white),
                                    shape: CircleBorder(),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30),
                                            ),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 210,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 30),
                                                    Text(
                                                      '프로필 사진 설정',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 25),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: pickImageFromCameraAndUpdateCurrentUserImage,
                                                          child: Container(
                                                            child: Column(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 35,
                                                                  backgroundColor: Colors.black,
                                                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 32),
                                                                ),
                                                                SizedBox(height: 10),
                                                                Text(
                                                                    '사진 찰영'
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: pickImageFromGalleryAndUpdateCurrentUserImage,
                                                          child: Container(
                                                            child: Column(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 35,
                                                                  backgroundColor: Colors.black,
                                                                  child: Icon(Icons.photo, color: Colors.white, size: 32),
                                                                ),
                                                                SizedBox(height: 10),
                                                                Text(
                                                                    '사진 선택'
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
                                )
                            ),
                          ],
                        ),
                      ), // 사진
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                loggedUserName!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                loggedUserEmail!,
                                style: TextStyle(
                                    color: Colors.black54
                                ),
                              )
                            ],
                          ),
                        ),
                      ), // 이름 & 아이디
                    ],
                  ),
                ),
              ],
            ), // top bar
            Container(
              width: width,
              height: 6,
              color: Colors.black12,
            ), // 회색선
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
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
                                                '이름 변경',
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
                                        child: TextField(
                                          controller: _TextEditingController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              hintText: '새 이름을 입력해주세요.',
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
                                      Container(
                                        width: 300,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_TextEditingController.text == '') {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('최소 1자 이상 입력해주세요.'),
                                                    backgroundColor: Color(0xfff42957),
                                                  )
                                              );
                                            } else {
                                              setState(() {
                                                loggedUserName = _TextEditingController.text;
                                              });
                                              updateCurrentUserName(_TextEditingController.text);
                                              Navigator.pop(context);
                                            }
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
                                      )
                                    ],
                                  )
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이름 변경',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff464646)
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                width: 18,
                                height: 18,
                                child: Image.asset('assets/button_image/front_button.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ), // 이름 변경
                  Divider(height: 1),
                  GestureDetector(
                    onTap: () {
                      print(1);
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 15, bottom: 15, left: 36, right: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '비밀번호 변경',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff464646)
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                width: 18,
                                height: 18,
                                child: Image.asset('assets/button_image/front_button.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ), // 비밀번호 변경
                  Divider(height: 1),
                  GestureDetector(
                    onTap: currentUserLogOut,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 36, right: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '로그아웃',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff464646)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), // 로그아웃
                  Divider(height: 1),
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
                                  height: 180,
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
                                                '회원 탈퇴',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Container(
                                            width: 125,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
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
                                              onPressed: () {
                                                deleteCurrentUser();
                                                Navigator.pop(context);
                                              },
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
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 36, right: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '회원 탈퇴',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffc6c6c6)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), // 회원 탈퇴
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}