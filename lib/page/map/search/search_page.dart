import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {

  List _items;
  SearchPage(this._items);

  @override
  State<SearchPage> createState() => _SearchPageState(_items);
}

class _SearchPageState extends State<SearchPage> {
  final _TextEditingController = TextEditingController(); // 택스트폼 컨트롤러
  bool RecentSearch = true; // 최근 검색 focus?

  List _items;
  _SearchPageState(this._items);

  @override
  void dispose() {
    _TextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ), // 앱바 없애기
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height * 0.075), // 공간 조금 만드는 박스
            Container(
                width: width * 0.87,
                height: height * 0.06,
                child: Center(
                  child: Container(
                    width: width * 0.85,
                    child: TextFormField(
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (value) async{
                        setState(() {
                          if(_items.length >=10){
                            _items.removeAt(0);
                          }
                          _items.add(value);
                        });
                      },
                      controller: _TextEditingController,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: (){
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black54,
                            size: 18,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            _TextEditingController.clear();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 25,
                          ),
                        ),
                        hintText: '장소, 주소, 음식 검색',
                        hintStyle: TextStyle(
                          fontSize: 18.5,
                          color: Color(0xffb9b9b9),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ) // 택스트 필드
            ), // 택스트 필드
            SizedBox(height: 12),
            Container(
              width: width,
              height: 6,
              color: Colors.black12,
            ), // 회색 바
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: 30,right: 20),
                children: [
                  for(int i=_items.length-1; i>=0; i--) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: Icon(Icons.search,color: Colors.black,size: 20),
                                      decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black12),
                                    ),
                                    SizedBox(width: 16),
                                    Text('${_items[i]}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _items.removeAt(i);
                                      });
                                    },
                                    icon: Icon(Icons.clear,color: Colors.black38,size: 20))
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey[300],
                    )

                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}