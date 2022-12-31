import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Compare(),
    );
  }
}

class Compare extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        title: Center(
                          child: Text(
                            '타로야',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  Text('새 폴더 생성')
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black12,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                itemCount: folderName.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                                color: Color(0xfffff6f8),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.bookmark, color: Color(0xfff42957), size: 13),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            _FavoriteFolderPageController.folderName[index],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                      Checkbox(
                                        value: isChecked[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked[index] = value!;
                                          });
                                        },
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: Color(0xfff42957),
                                      )
                                    ],
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider();
                                },
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('확인'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ) // 확인박스
                          ],
                        ),
                      );
                    }
                );
              },
              child: Container(
                width: 200,
                height: 100,
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text(''),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: StadiumBorder()
                    )
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}