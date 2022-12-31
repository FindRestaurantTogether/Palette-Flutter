import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  List NotificationImages = [
    'assets/login_image/food.png',
    'assets/login_image/food.png',
  ];

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
      body: Column(
        children: [
          SizedBox(height: height * 0.08),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 20),
                  Container(
                    width: 36,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black54,
                            size: 20
                        )
                    ),
                  ),
                  Text(
                    '알림',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '전체 삭제',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 25),
                ],
              )
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: NotificationImages.length,
              itemBuilder: (context, index){
                return Container(
                  height: height * 0.14,
                  // color: Colors.pink.withOpacity(0.6),
                  padding: EdgeInsets.only(left: 25, right: 25, top: height * 0.018),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 19,
                                      backgroundImage: AssetImage(NotificationImages[index]),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      width: width * 0.56,
                                      child: Row(
                                        children: [
                                          Text(
                                            '지민',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54
                                            ),
                                          ),
                                          Text(
                                            '님이 ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54
                                            ),
                                          ),
                                          Text(
                                            '익선동 탐방',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54
                                            ),
                                          ),
                                          Text(
                                            '에 ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54
                                            ),
                                          ),
                                          Text(
                                            '핀을 ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54
                                            ),
                                          ),
                                          Text(
                                            '추가하...',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 8.5,
                                  backgroundColor: Colors.pinkAccent,
                                  child: Icon(Icons.close, size: 10, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 53),
                                    Container(
                                      width: width * 0.53,
                                      height: height * 0.034,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '     장소 보러가기   ',
                                              style: TextStyle(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 12
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent, size: 13)
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    side: BorderSide(color: Colors.pinkAccent)
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.034,
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    '10/20',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                      Container(
                        height: 1,
                        child: Divider(
                          color: Colors.black12,
                          thickness: 1,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}



