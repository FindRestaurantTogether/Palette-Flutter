import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.yellow,
              // fontSize: 50,
            )),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Screenshot Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(
                'Capture An Invisible Widget',
              ),
              onPressed: () {
                var container = Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // 가게 이름 텍스트 테두리
                    Positioned(
                        bottom: -15,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('가게 이름',
                              style: TextStyle(
                                fontSize: 20,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
                                  ..color = CupertinoColors.white,
                              )),
                        )),
                    // 가게 이름 텍스트 안쪽
                    Positioned(
                        bottom: -15,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('가게 이름',
                              style: TextStyle(
                                color: Color(0xfff42957),
                                fontSize: 20,
                              )),
                        )),
                    // 평점
                    Positioned(
                        bottom: -45,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xfff42957),
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text('★ 3.14',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 20,
                              )),
                        ))
                  ],
                );

                screenshotController.captureFromWidget(
                    InheritedTheme.captureAll(context, Material(child: container)),
                    delay: Duration(seconds: 1)).then((capturedImage) async {
                    final directory = (await getApplicationDocumentsDirectory ()).path;
                    print(1);
                    print(directory.toString());
                    print(2);
                    File('C:/Users/82105/Desktop/kimhakhyun_folder/palette/assets/screenshot_image').writeAsBytes(capturedImage);
                    // final File newImage = await image.copy('$directory/image1.png');
                  }
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}