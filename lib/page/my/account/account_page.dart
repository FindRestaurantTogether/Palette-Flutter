import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/page/my/my_page_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  File? imageFile;
  UploadTask? uploadTask;

  final _MyPageController = Get.put(MyPageController());

  Future uploadImageFile() async{
    final path = 'image/${loggedUser!.email!}';
    final file = File(imageFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  final _Authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _Authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: width,
            height: 250,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                SizedBox(height: 40),
                Container(
                  width: width,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 40,
                          child: Container(
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black54,
                                )
                            ),
                          )
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                    child: imageFile == null
                                        ? ClipOval(
                                      child: Container(
                                        width: 105,
                                        height: 105,
                                        color: Colors.black26,
                                      ),
                                    )
                                        : ClipOval(
                                      child: Container(
                                        width: 105,
                                        height: 105,
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: buildEditIcon(Colors.black, context)
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('user/AK8G6sshjzRzH51dkssq/profile') // 경로 설정
                                .snapshots(), // stream 반환
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                              return Text(
                                '${snapshot.data!.docs}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              );

                            },
                          ),
                          SizedBox(height: 6),
                          Text(
                            loggedUser!.email!,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ), // top bar
          Container(
            width: width,
            height: 6,
            color: Colors.black12,
          ), // 회색선
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                Container(
                    width: width * 0.85,
                    height: height * 0.075,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black12,
                                width: 1
                            )
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '이메일',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 18)
                      ],
                    )
                ),
                Container(
                    width: width * 0.85,
                    height: height * 0.075,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black12,
                                width: 1
                            )
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '전화번호',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 18)
                      ],
                    )
                ),
                Container(
                    width: width * 0.85,
                    height: height * 0.075,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black12,
                                width: 1
                            )
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '비밀번호 변경',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 18)
                      ],
                    )
                ),
                GestureDetector(
                  onTap: () {
                    _Authentication.signOut();
                    _MyPageController.isLoginChangeState();
                    Get.back();
                  },
                  child: Container(
                      width: width * 0.85,
                      height: height * 0.075,
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '로그아웃',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ), // list view
        ],
      ),
    );
  }

  Widget buildEditIcon(Color color, BuildContext context) => GestureDetector(
    onTap: (){
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
                          onTap: () {
                            _getFromCamera();
                            Navigator.pop(context);
                          },
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
                          onTap: () {
                            _getFromGallery();
                            Navigator.pop(context);
                          },
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
    },
    child: buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
        color: color,
        all: 8,
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) => ClipOval(
    child: Container(
      padding: EdgeInsets.all(all),
      color: color,
      child: child,
    ),
  );

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        uploadImageFile();
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        uploadImageFile();
      });
    }
  }
}