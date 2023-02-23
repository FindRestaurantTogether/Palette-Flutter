import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _NameTextEditingController = TextEditingController();
  final _IdTextEditingController = TextEditingController();
  final _PasswordTextEditingController = TextEditingController();
  final _PasswordConfirmTextEditingController = TextEditingController();
  final _GlobalKey = GlobalKey<FormState>();

  String name = '';
  String id = '';
  String password = '';

  void _tryValidation() {
    final isValid = _GlobalKey.currentState!.validate();
    if (isValid) {
      _GlobalKey.currentState!.save();
    }
  }

  File? _pickedImage;
  void pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }
  void pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  String? url;
  bool signUpLoading = false;
  void signUpButton() async {
    _tryValidation();
    if (_pickedImage != null) {
      try {
        setState(() {
          signUpLoading = true;
        });
        final ref = FirebaseStorage.instance.ref().child('usersImages').child(id + '.jpg');
        await ref.putFile(_pickedImage!);
        url = await ref.getDownloadURL();
        final createdUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: id,
            password: password
        );
        final currentUser = FirebaseAuth.instance.currentUser;
        final currentUserUid = currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(currentUserUid).set({
          'uid': currentUserUid,
          'name': name,
          'id': id,
          'imageUrl': url,
        });
        if (createdUser.user != null) {
          await ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('회원가입이 완료되었습니다.'),
                backgroundColor: Color(0xfff42957),
              )
          );
          Get.back();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                Text('제공된 비밀번호가 너무 약합니다.'),
                backgroundColor: Color(0xfff42957),
              )
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                Text('해당 이메일에 대한 계정이 이미 존재합니다.'),
                backgroundColor: Color(0xfff42957),
              )
          );
        }
      } finally {
        setState(() {
          signUpLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 사진을 업로드해주세요.'),
            backgroundColor: Color(0xfff42957),
          )
      );
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  '회원가입하기',
                  style: TextStyle(
                      color: Color(0xff464646),
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                ), // 회원가입하기
                SizedBox(height: 50),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xfff42957),
                        child: CircleAvatar(
                          radius: 53,
                          backgroundColor: Colors.white,
                          backgroundImage: _pickedImage == null
                              ? null
                              : FileImage(_pickedImage!),
                          child: _pickedImage == null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(300),
                                child: Image.asset('assets/logo_image/logo_image.png')
                              )
                              : null,
                        ),
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
                                                  onTap: pickImageFromCamera,
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
                                                  onTap: pickImageFromGallery,
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
                SizedBox(height: 40),
                Container(
                  child: Form(
                      key: _GlobalKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이름',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfff42957)
                                ),
                              ),
                              SizedBox(height: 1),
                              Container(
                                height: 45,
                                child: TextFormField(
                                  key: ValueKey(1),
                                  controller: _NameTextEditingController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '이름을 다시 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    name = value!;
                                  },
                                  onChanged: (value) {
                                    name = value;
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 10, height: 0.5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _NameTextEditingController.clear();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIconConstraints: BoxConstraints(maxHeight: 20),
                                    hintText: 'palette',
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // 이름
                          SizedBox(height: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '아이디',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfff42957)
                                ),
                              ),
                              SizedBox(height: 1),
                              Container(
                                height: 45,
                                child: TextFormField(
                                  key: ValueKey(1),
                                  controller: _IdTextEditingController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty || !(value.contains('@'))) {
                                      return '아이디를 다시 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    id = value!;
                                  },
                                  onChanged: (value) {
                                    id = value;
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 10, height: 0.5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _IdTextEditingController.clear();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIconConstraints: BoxConstraints(maxHeight: 20),
                                    hintText: 'palette@naver.com',
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // 아이디
                          SizedBox(height: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '비밀번호',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfff42957)
                                ),
                              ),
                              SizedBox(height: 1),
                              Container(
                                height: 45,
                                child: TextFormField(
                                  key: ValueKey(2),
                                  controller: _PasswordTextEditingController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '비밀번호를 다시 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 10, height: 0.5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _PasswordTextEditingController.clear();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIconConstraints: BoxConstraints(maxHeight: 20),
                                    hintText: '최소 7자 이상 입력해주세요',
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // 비밀번호
                          SizedBox(height: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '비밀번호 확인',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xfff42957)
                                ),
                              ),
                              SizedBox(height: 1),
                              Container(
                                height: 45,
                                child: TextFormField(
                                  key: ValueKey(3),
                                  controller: _PasswordConfirmTextEditingController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty || _PasswordTextEditingController.text != _PasswordConfirmTextEditingController.text) {
                                      return '비밀번호가 일치하지 않습니다.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    password = value!;
                                  },
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 10, height: 0.5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _PasswordTextEditingController.clear();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Color(0xfff42957),
                                      ),
                                    ),
                                    suffixIconConstraints: BoxConstraints(maxHeight: 20),
                                    hintText: '위의 비밀번호와 일치하게 입력해주세요.',
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // 비밀번호 확인
                        ],
                      )
                  ),
                ), // 이름 & 아이디 & 비밀번호 & 비밀번호 확인
                SizedBox(height: 60),
                signUpLoading
                  ? Center(
                    child: CircularProgressIndicator(color: Color(0xfff42957))
                )
                  : Container(
                  width: width - 60,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signUpButton,
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
                ), // 확인박스
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

