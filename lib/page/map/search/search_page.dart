import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/navermap/utils.dart';

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

  bool searchByMyLocation = false;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  width: width,
                  height: height * 0.06,
                  padding: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  // padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            // color: Colors.red,
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                Get.back();
                              },
                              icon: Image.asset('assets/button_image/back_button.png', width: 10, height: 16, fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            // color: Colors.orange,
                            width: width * 0.87 - 120,
                            child: TextFormField(
                              textInputAction: TextInputAction.go,
                              onFieldSubmitted: (value) async{
                                setState(() async {
                                  if(_items.length >=10){
                                    _items.removeAt(0);
                                  }
                                  _items.add(value);

                                  // 여기가 검색 클릭하는 곳인가??
                                  // 근데 이거보다 naverpage에 보내서 한번에 처리하는게 좋을것 같은데!!!!
                                  List filter = read_all();
                                  Network network = Network(filter, value);
                                  var store = await network.getJsonData();
                                  print(store);
                                });
                              },
                              controller: _TextEditingController,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '장소, 주소, 음식 검색',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xffb9b9b9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        // color: Colors.yellow,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            _TextEditingController.clear();
                          },
                          icon: Image.asset(
                              'assets/button_image/close_button.png',
                              width: 12,
                              height: 13,
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                    ],
                  )
              ), // 검색창
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ExpandTapWidget(
                    onTap: () {
                      setState(() {
                        searchByMyLocation = true;
                      });
                    },
                    tapPadding: EdgeInsets.all(50),
                    child: Container(
                      width: width * 0.5,
                      padding: EdgeInsets.all(10),
                      decoration: searchByMyLocation? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                      child: Center(
                        child: Text(
                          '내 위치 중심',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: searchByMyLocation ? FontWeight.bold : null,
                            color: searchByMyLocation ? Color(0xfff42957) : Color(0xffa0a0a0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ExpandTapWidget(
                    onTap: () {
                      setState(() {
                        searchByMyLocation = false;
                      });
                    },
                    tapPadding: EdgeInsets.all(50),
                    child: Container(
                      width: width * 0.5,
                      padding: EdgeInsets.all(10),
                      decoration: !searchByMyLocation? BoxDecoration(border: Border(bottom: BorderSide(width: 4, color: Color(0xfff42957)))) : null,
                      child: Center(
                        child: Text(
                          "지도 중심",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: !searchByMyLocation ? FontWeight.bold : null,
                            color: !searchByMyLocation ? Color(0xfff42957) : Color(0xffa0a0a0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // 내 위치 중심 / 지도 중심
              Expanded(
                child: ListView (
                  padding: EdgeInsets.zero,
                  children: [
                    for(int i=_items.length-1; i>=0; i--) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              width: width,
                              padding: EdgeInsets.only(left: 30,right: 20),
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
      ),
    );
  }
}