import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {

  ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _HotPlacePageState();
}

class _HotPlacePageState extends State<ForgetPasswordPage> {

  final _TextEditingController = TextEditingController();
  final _GlobalKey = GlobalKey<FormState>();

  String id = '';
  bool sendEmailLoading = false;

  // @override
  // void dispose() {
  //   _TextEditingController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () async{
          Get.back();
          return false;
        }, // 뒤로가기 버튼
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: width * 0.85,
                height: 270,
                padding: EdgeInsets.only(top: 12, bottom: 25, left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white
                ),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Material(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    Get.back();
                                  }, // 적용된 필터 백에 전달
                                  icon: Image.asset('assets/button_image/close_button.png'),
                                ),
                              ), // 나가기
                            ],
                          ),
                        ),
                      ), // 뒤로가기 버튼
                      Text(
                        '비밀번호 찾기',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black
                        ),
                      ), // 비밀번호 찾기
                      SizedBox(height: 20),
                      Text(
                        textAlign: TextAlign.center,
                        '비밀번호 초기화를 위해 아이디(이메일)을 입력해주세요.\n비밀번호를 초기화할 수 있는 메일이 전송됩니다.',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 10,
                          color: Color(0xfff42957),
                          fontWeight: FontWeight.w600
                        ),
                      ), // 비밀번호 찾기 안내
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Form(
                          key: _GlobalKey,
                          child: Container(
                            height: 45,
                            child: TextFormField(
                              key: ValueKey(1),
                              controller: _TextEditingController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty || !(value.contains('@'))) {
                                  return '아이디를 다시 입력해주세요.';
                                }
                                return null;
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
                                    _TextEditingController.clear();
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
                        ),
                      ), // 아이디 입력란
                      SizedBox(height: 25),
                      sendEmailLoading
                          ? CircularProgressIndicator(color: Color(0xfff42957))
                          : Container(
                        width: width * 0.85 - 32,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: resetPassword,
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
            )
          ],
        )
    );
  }

  Future resetPassword() async {
    final isValid = _GlobalKey.currentState!.validate();
    if (isValid) {
      _GlobalKey.currentState!.save();
      try {
        setState(() {
          sendEmailLoading = true;
        });
        print(_TextEditingController.text);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _TextEditingController.text);
        setState(() {
          sendEmailLoading = false;
        });
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('비밀번호 초기화 이메일을 발송하였습니다.'),
              backgroundColor: Color(0xfff42957),
            )
        );
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }
}
