import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/page/my/my_page_controller.dart';
import 'package:get/get.dart';
import 'package:myapp/page/my/signin/forgetpassword_page.dart';
import 'package:myapp/page/my/signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _MyPageController = Get.put(MyPageController());
  final _IdTextEditingController = TextEditingController();
  final _PasswordTextEditingController = TextEditingController();
  final _GlobalKey = GlobalKey<FormState>();

  String id = '';
  String password = '';

  void _tryValidation() {
    final isValid = _GlobalKey.currentState!.validate();
    if (isValid) {
      _GlobalKey.currentState!.save();
    }
  }

  User? loggedUser;
  bool signUpLoading = false;
  void signInButton() async {
    _tryValidation();
    setState(() {
      signUpLoading = true;
    });
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: id,
          password: password
      );
      if (user.user != null) {
        loggedUser = user.user;
        _MyPageController.loggedUserUid.value = loggedUser!.uid;
        final loggedUserDoc =  await FirebaseFirestore.instance.collection('users').doc(_MyPageController.loggedUserUid.value).get();
        setState(() {
          _MyPageController.loggedUserImageUrl.value = loggedUserDoc.get('imageUrl');
          _MyPageController.loggedUserName.value = loggedUserDoc.get('name');
          _MyPageController.loggedUserEmail.value = loggedUserDoc.get('id');
          _MyPageController.isLogin.value = !_MyPageController.isLogin.value;
        });
        Get.back();
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('해당 아이디가 존재하지 않습니다.'),
              backgroundColor: Color(0xfff42957),
            )
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('비밀번호를 잘못 입력하셨습니다.'),
              backgroundColor: Color(0xfff42957),
            )
        );
      }
    } finally {
      setState(() {
        signUpLoading = false;
      });
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
                SizedBox(height: height * 0.14),
                Text(
                  '로그인하기',
                  style: TextStyle(
                      color: Color(0xff464646),
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                ), // 로그인하기
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
                                    hintText: '******',
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
                ), // 아이디 & 비밀번호
                SizedBox(height: height * 0.03),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignupPage());
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff787878)
                          ),
                        ),
                      ),
                      Text(
                        '   |   ',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xffb9b9b9)
                        ),
                      ),
                      // Text(
                      //   '아이디 찾기',
                      //   style: TextStyle(
                      //       fontSize: 13,
                      //       color: Color(0xff787878)
                      //   ),
                      // ),
                      // Text(
                      //     '|',
                      //   style: TextStyle(
                      //       fontSize: 13,
                      //       color: Color(0xffb9b9b9)
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return ForgetPasswordPage();
                            },
                          );
                        },
                        child: Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff787878)
                          ),
                        ),
                      ),
                    ],
                  ),
                ), // 회원가입 & 아이디 찾기 & 비밀번호 찾기
                SizedBox(height: 50),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                        width: 100,
                        child: Image(image: AssetImage('assets/login_image/easy_login.png'))
                    ),
                  ],
                ), // 말풍선
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/login_image/kakao.png', height: 50, width: 50),
                    Image.asset('assets/login_image/naver.png', height: 50, width: 50),
                    Image.asset('assets/login_image/facebook.png', height: 50, width: 50),
                    Image.asset('assets/login_image/apple.png', height: 50, width: 50),
                  ],
                ), // 간편로그인들
                SizedBox(height: 60),
                signUpLoading
                    ? Center(
                    child: CircularProgressIndicator(color: Color(0xfff42957))
                )
                    : Container(
                  width: width - 60,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signInButton,
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