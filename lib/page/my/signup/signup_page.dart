import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/page/my/my_page_controller.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _NameTextEditingController = TextEditingController();
  final _IdTextEditingController = TextEditingController();
  final _PasswordTextEditingController = TextEditingController();
  final _GlobalKey = GlobalKey<FormState>();
  final _Authentication = FirebaseAuth.instance;

  String name = '';
  String id = '';
  String password = '';

  void _tryValidation() {
    final isValid = _GlobalKey.currentState!.validate();
    if (isValid) {
      _GlobalKey.currentState!.save();
    }
  }

  void authPersistence() async{
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  } // 회원가입, 로그인시 사용자 영속

  @override
  void dispose() {
    _NameTextEditingController.dispose();
    _IdTextEditingController.dispose();
    _PasswordTextEditingController.dispose();
    super.dispose();
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
                SizedBox(height: height * 0.14),
                Text(
                  '회원가입하기',
                  style: TextStyle(
                      color: Color(0xff464646),
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                ), // 회원가입하기
                SizedBox(height: height * 0.08),
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
                          SizedBox(height: height * 0.04),
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
                                    hintText: 'abc@naver.com',
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // 아이디
                          SizedBox(height: height * 0.04),
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
                                    hintText: '영문, 숫자, 특수문자 조합',
                                    hintStyle: TextStyle(
                                        color: Color(0xffb9b9b9),
                                        fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // 비밀번호
                        ],
                      )
                  ),
                ), // 이름 & 아이디 & 비밀번호
                SizedBox(height: height * 0.23),
                Container(
                  width: width - 60,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      _tryValidation();
                      try {
                        final user = await _Authentication
                            .createUserWithEmailAndPassword(
                            email: id,
                            password: password
                        );
                        await FirebaseFirestore.instance.collection('user') // cloud firestore user에
                            .doc(user.user!.uid)
                            .set({
                              'name': name,
                              'email': id
                            }
                        ); // map 형태로 앞에 받은 user 정보 저장
                        if (user.user != null) {
                          Get.back();
                        }
                      } on FirebaseAuthException catch(e) {
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
                      }
                      authPersistence();
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
                ) // 확인박스
              ],
            ),
          ),
        ),
      ),
    );
  }
}

