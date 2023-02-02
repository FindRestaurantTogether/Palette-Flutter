import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/hotplace/hotplace_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart' as naver;
import 'package:http/http.dart' as http;
import 'package:naver_map_plugin/naver_map_plugin.dart';

class Network{
  // var top_right;
  // var bottom_left;
  // Network(this.top_right, this.bottom_left);

  final String url = 'http://34.64.35.77/api/search/map';
  Map<String,dynamic> store_dict = Map();
  Map<String,dynamic> menu = Map();
  Map<String,dynamic> hour = Map();
  Map<String,dynamic> name = {
    '해산물(게)': 'food_korean_seafood_crab',
    '해산물(문어)': 'food_korean_seafood_octopus',
    '해산물(생선)': 'food_korean_seafood_fish',
    '해산물(조개)': 'food_korean_seafood_seashell',
    '분식': 'food_korean_snack',
    '고기(구이)': 'food_korean_meat',
    '전': 'food_korean_jeon',
    '곱/대/막창': 'food_korean_giblets',
    '백반/죽/찌개': 'food_korean_meal',
    '국밥': 'food_korean_gukbap',
    '전골/탕/찜': 'food_korean_stew',
    '냉면/국수': 'food_korean_noodles',
    '기타(한식)': 'food_korean_etc',
    '피자': 'food_western_pizza',
    '샌드위치': 'food_western_sandwich',
    '햄버거': 'food_western_hamburger',
    '파스타': 'food_western_pasta',
    '스테이크': 'food_western_steak',
    '기타(양식)': 'food_western_etc',
    '마라/훠궈': 'food_chinese_hotpot',
    '딤섬': 'food_chinese_dimsum',
    '중국집': 'food_chinese_restaurant',
    '양꼬치': 'food_chinese_lambskewers',
    '기타(중식)': 'food_chinese_etc',
    '초밥/회': 'food_japanese_sushi',
    '돈까스': 'food_japanese_porkcutlet',
    '라멘': 'food_japanese_ramen',
    '우동/메밀': 'food_japanese_udon',
    '덮밥': 'food_japanese_dnburi',
    '기타(일식)': 'food_japanese_etc',
    '아시안': 'food_asian',
    '멕시칸': 'food_mexican',
    '기타': 'food_etc',
    '프랜차이즈': 'cafe_franchise',
    '개인': 'cafe_private',
    '주점': 'alcohol_pub',
    '호프': 'alcohol_hof',
    '이자카야': 'alcohol_izakaya',
    '와인': 'alcohol_wine',
    '칵테일,양주': 'alcohol_cocktail'
  };

  Future<dynamic> getJsonData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //String jsonData = response.body;
      var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
      var store = parsingData;
      for(int i=1;i<=store.length;i++){
        try {
          store["store$i"]["road_address"] = "서울 " + store["store$i"]["road_address"];
        }
        catch(e) {}
        try {
          store["store$i"]["call"] = store["store$i"]["call"].replaceAll(RegExp('[^0-9\\s]'), "");
        }
        catch(e) {}
        try {
          store["store$i"]['kakao_star'] = double.parse(store["store$i"]['kakao_star']);
          store["store$i"]['kakao_cnt'] = int.parse(store["store$i"]['kakao_cnt']);
        }
        catch(e) {}
        try {
          store["store$i"]['naver_star'] = double.parse(store["store$i"]['naver_star']);
          store["store$i"]['naver_cnt'] = int.parse(store["store$i"]['naver_cnt']);
        }
        catch(e) {}
        try {
          store["store$i"]['google_star'] = double.parse(store["store$i"]['google_star']);
          store["store$i"]['google_cnt'] = int.parse(store["store$i"]['google_cnt']);
        }
        catch(e) {}
        try{
          for(int j=0;j<store["store$i"]['opening_hour'].length;j++){
            hour.addAll(store["store$i"]['opening_hour'][j]);
          }
          store["store$i"]['opening_hour'] = hour;
        }
        catch(e){}
        try{
          for(int j=0;j<store["store$i"]['menu'].length;j++){
            menu.addAll(store["store$i"]['menu'][j]);
          }
          store["store$i"]['menu'] = menu;
        }
        catch(e){}
        try {
          store["store$i"]['main_category'] = name[store["store$i"]['main_category']];
        }
        catch(e) {}
        store_dict["$i"] = store["store$i"];
      }
      return store_dict;
    }
  }
}