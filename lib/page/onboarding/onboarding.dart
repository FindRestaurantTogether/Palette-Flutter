import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myapp/page/tab/tab_page.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel( // 첫 페이지
            title:'Welcome to my app',
            body: 'This is the first page',
            image: CircleAvatar(
              backgroundImage: AssetImage('assets/onboarding_image/first_onboarding.png'),
              backgroundColor: Colors.white,
              radius: 100,
            ),
            decoration: getPageDecoration()
        ),
        PageViewModel( // 두번째 페이지
            title:'Welcome to my app',
            body: 'This is the second page',
            image: CircleAvatar(
              backgroundImage: AssetImage('assets/onboarding_image/second_onboarding.png'),
              backgroundColor: Colors.white,
              radius: 100,
            ),
            decoration: getPageDecoration()
        ),
        PageViewModel( // 마지막 페이지
            title:'Welcome to my app',
            body: 'This is the third page',
            image: CircleAvatar(
              backgroundImage: AssetImage('assets/onboarding_image/third_onboarding.png'),
              backgroundColor: Colors.white,
              radius: 100,
            ),
            decoration: getPageDecoration()
        ),
        PageViewModel( // 마지막 페이지
            title:'Welcome to my app',
            body: 'This is the last page',
            image: CircleAvatar(
              backgroundImage: AssetImage('assets/onboarding_image/fourth_onboarding.png'),
              backgroundColor: Colors.white,
              radius: 100,
            ),
            decoration: getPageDecoration()
        ),
      ],
      done: const Text('done'), // 마지막 페이지까지 봤을 때 무엇을 할 지정
      onDone: (){ // 버튼을 터치하면 무엇을 할지
        Get.off(TabPage());
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true, // 한번에 마지막 페이지로 넘길 수 있는 skip button 생성
      skip: const Text('skip'),
      dotsDecorator: DotsDecorator( // 페이지를 나타내는 점 디자인
          color: Colors.blue,
          size: const Size(10, 10), // 가로,세로 모두 10
          activeSize: const Size(22,10), // 점이 활성화되었을 때
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)
          ),
          activeColor: Colors.blue
      ),
      curve: Curves.easeIn, // 페이지 바꿀 때 애니메이션 추가
    );
  }
  // PageDecoration 위젯에 대한 메소드 생성해서 여러 페이지에 한 번에 적용
  PageDecoration getPageDecoration(){
    return const PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        bodyTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.white
        ),
        imagePadding: EdgeInsets.only(top:40),
        pageColor: Colors.white // 배경색
    );
  }
}