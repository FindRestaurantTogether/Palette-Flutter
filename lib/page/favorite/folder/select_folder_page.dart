import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
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

  final _TextEditingController = TextEditingController();

  List<bool> favoriteFolderIsChecked = List<bool>.filled(50, false);

  @override
  void dispose() {
    // _TextEditingController.dispose();
    Hive.box('favorite').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: width * 0.8,
            height: 400,
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white
            ),
            child: Column(
              children: [
                Text(
                  '${selectedRestaurant.store_name}',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                  width: 300,
                                  height: 235,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.pop(context);
                                              _TextEditingController.clear();
                                            },
                                            child: Container(
                                                height: 50,
                                                child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Icon(Icons.close, size: 26)
                                                )
                                            ),
                                          ),
                                          SizedBox(
                                            width: 75,
                                          ),
                                          Container(
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '새 폴더',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4, right: 4),
                                        child: TextFormField(
                                          autofocus: true,
                                          controller: _TextEditingController,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xfff42957)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xfff42957)),
                                              ),
                                              hintText: '폴더명을 입력해주세요.',
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    _TextEditingController.clear();
                                                  },
                                                  icon: Padding(
                                                    padding: EdgeInsets.only(left: 15),
                                                    child: Icon(Icons.clear, size: 18, color: Color(0xfff42957)),
                                                  )
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Container(
                                        width: 300,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            favoriteBox.add(
                                                FavoriteModel(
                                                    favoriteFolderName: _TextEditingController.text,
                                                    favoriteFolderRestaurantList: []
                                                )
                                            );

                                            Navigator.pop(context);
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
                                      ) //
                                    ],
                                  )
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text('새 폴더 생성')
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.withOpacity(0.5),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                ValueListenableBuilder(
                  valueListenable: Hive.box<FavoriteModel>('favorite').listenable(),
                  builder: (BuildContext context, Box<FavoriteModel> box, _) {
                    List<FavoriteModel> favoriteFolders = box.values.toList().cast<FavoriteModel>();
                    return Expanded(
                      child: ListView.separated(
                        itemCount: favoriteFolders.length,
                        itemBuilder: (BuildContext context, int index) {
                          FavoriteModel favoriteFolder = favoriteFolders[index];
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
                                      favoriteFolder.favoriteFolderName,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      favoriteFolder.favoriteFolderRestaurantList.length.toString(),
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
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
                                      value: favoriteFolderIsChecked[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          favoriteFolderIsChecked[index] = !favoriteFolderIsChecked[index];
                                          for (var i=0 ; i<favoriteFolderIsChecked.length; i++)
                                            if (i != index)
                                                favoriteFolderIsChecked[i] = false;
                                        });
                                      },
                                      shape: CircleBorder(),
                                      checkColor: Colors.white,
                                      activeColor: Color(0xfff42957),
                                    )
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
                    );
                  },
                ),
                SizedBox(height: 5),
                Container(
                  width: width * 0.8 - 20,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      int selectedIndex = favoriteFolderIsChecked.indexWhere((e) => e == true);
                      FavoriteModel? selectedFavoriteFolder = favoriteBox.getAt(selectedIndex);
                      selectedFavoriteFolder!.favoriteFolderRestaurantList.add(
                        RestaurantModel(
                            uid: selectedRestaurant.uid,
                            store_name: selectedRestaurant.store_name,
                            jibun_address: selectedRestaurant.jibun_address,
                            latitude: selectedRestaurant.position.latitude,
                            longitude: selectedRestaurant.position.longitude,
                            call: selectedRestaurant.call,
                            category: selectedRestaurant.category,
                            main_category: selectedRestaurant.main_category,
                            open: selectedRestaurant.open,
                            opening_hour: selectedRestaurant.opening_hour,
                            opening_breaktime: selectedRestaurant.opening_breaktime,
                            opening_lastorder: selectedRestaurant.opening_lastorder,
                            theme: selectedRestaurant.theme,
                            service: selectedRestaurant.service,
                            menu: selectedRestaurant.menu,
                            store_image: selectedRestaurant.store_image,
                            naver_star: selectedRestaurant.naver_star,
                            naver_cnt: selectedRestaurant.naver_cnt,
                            naver_review_url: selectedRestaurant.naver_review_url,
                            google_star: selectedRestaurant.google_star,
                            google_cnt: selectedRestaurant.google_cnt,
                            google_review_url: selectedRestaurant.google_review_url,
                            kakao_star: selectedRestaurant.kakao_star,
                            kakao_cnt: selectedRestaurant.kakao_cnt,
                            kakao_review_url: selectedRestaurant.kakao_review_url
                        )
                      );
                      selectedFavoriteFolder.save();

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
  }
}
