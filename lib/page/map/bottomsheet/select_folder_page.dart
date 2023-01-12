import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/favorite/favorite_page_folder_controller.dart';
import 'package:myapp/page/favorite/favorite_page_list_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';

class SelectFolderPage extends StatefulWidget {

  final NaverMapPageModel selectedRestaurant;

  SelectFolderPage({Key? key, required this.selectedRestaurant}) : super(key: key);

  @override
  State<SelectFolderPage> createState() => _SelectFolderPageState(selectedRestaurant: selectedRestaurant);
}

class _SelectFolderPageState extends State<SelectFolderPage> {

  final NaverMapPageModel selectedRestaurant;
  _SelectFolderPageState({required this.selectedRestaurant});

  final _FavoriteFolderPageController = Get.put(FavoriteFolderPageController());
  final _FavoriteListPageController = Get.put(FavoriteListPageController());
  final _NaverMapPageController = Get.put(NaverMapPageController());

  List<bool> folderIsChecked = List<bool>.filled(Get.put(FavoriteFolderPageController()).folderName.length, false);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final int selectedIndex = _NaverMapPageController.restaurants.indexWhere((NaverMapPageModel restaurant) => restaurant.markerId == selectedRestaurant.markerId);

    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.4,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white
              ),
              child: Column(
                children: [
                  Text(
                    '${selectedRestaurant.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Container(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           return Material(
                  //             color: Colors.transparent,
                  //             child: Center(
                  //               child: Container(
                  //                   width: 300,
                  //                   height: 235,
                  //                   padding: EdgeInsets.all(20),
                  //                   decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       borderRadius: BorderRadius.circular(30)
                  //                   ),
                  //                   child: Column(
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           GestureDetector(
                  //                             onTap: (){
                  //                               Navigator.pop(context);
                  //                               _TextEditingController.clear();
                  //                             },
                  //                             child: Container(
                  //                                 height: 50,
                  //                                 child: Align(
                  //                                     alignment: Alignment.topLeft,
                  //                                     child: Icon(Icons.close, size: 26)
                  //                                 )
                  //                             ),
                  //                           ),
                  //                           SizedBox(
                  //                             width: 75,
                  //                           ),
                  //                           Container(
                  //                             height: 50,
                  //                             child: Align(
                  //                               alignment: Alignment.center,
                  //                               child: Text(
                  //                                 '새 폴더',
                  //                                 style: TextStyle(
                  //                                     fontWeight: FontWeight.bold,
                  //                                     fontSize: 20
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       Padding(
                  //                         padding: EdgeInsets.only(left: 4, right: 4),
                  //                         child: TextField(
                  //                           controller: _TextEditingController,
                  //                           maxLength: 20,
                  //                           decoration: InputDecoration(
                  //                               hintText: '폴더명을 입력해주세요.',
                  //                               suffixIcon: IconButton(
                  //                                   onPressed: () {
                  //                                     _TextEditingController.clear();
                  //                                   },
                  //                                   icon: Padding(
                  //                                     padding: EdgeInsets.only(left: 15),
                  //                                     child: Icon(Icons.clear, size: 18),
                  //                                   )
                  //                               )
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: 15),
                  //                       Container(
                  //                         width: 300,
                  //                         height: 50,
                  //                         child: ElevatedButton(
                  //                           onPressed: () {
                  //                             _FavoriteFolderPageController.addFolder(_TextEditingController.text);
                  //                             Navigator.pop(context);
                  //                           },
                  //                           child: Text(
                  //                             '확인',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold
                  //                             ),
                  //                           ),
                  //                           style: ElevatedButton.styleFrom(
                  //                             primary: Color(0xfff42957),
                  //                             shape: RoundedRectangleBorder(
                  //                               borderRadius: BorderRadius.circular(10),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ) //
                  //                     ],
                  //                   )
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.add),
                  //         Text('새 폴더 생성')
                  //       ],
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Colors.black12,
                  //       elevation: 0,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 5),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _FavoriteFolderPageController.folderName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Color(0xfffff6f8),
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(Icons.bookmark, color: Color(0xfff42957), size: 20),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    _FavoriteFolderPageController.folderName[index],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    _FavoriteFolderPageController.folderRestaurant[index].length.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xfff42957),
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                color: Colors.white,
                                child: Container(
                                  width: 30,
                                  child: Checkbox(
                                    value: folderIsChecked[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        for (var i=0 ; i<folderIsChecked.length; i++) {
                                          folderIsChecked[i] = false;
                                        }
                                        folderIsChecked[index] = !folderIsChecked[index];
                                      });
                                    },
                                    shape: CircleBorder(),
                                    checkColor: Colors.white,
                                    activeColor: Color(0xfff42957),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(height: 1);
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        for(var i = 0; i < folderIsChecked.length; i++) {
                          if (folderIsChecked[i] == true) {
                            _FavoriteFolderPageController.folderRestaurant[i].add(selectedRestaurant);
                          }
                        }
                        if (folderIsChecked.contains(true)) {
                          setState(() {
                            _NaverMapPageController.restaurants[selectedIndex].favorite.toggle();
                          });
                        }
                        _FavoriteListPageController.listRestaurant.add(selectedRestaurant);
                        print(_FavoriteListPageController.listRestaurant.length);
                        _FavoriteListPageController.listRestaurantIsChecked.add(false);
                        Get.back();
                      },
                      child: Text(
                        '폴더에 저장',
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
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
