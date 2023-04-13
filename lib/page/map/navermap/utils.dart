import 'dart:convert';
import 'package:get/get.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart' as naver;
import 'package:http/http.dart' as http;
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:math';

import 'navermap_page.dart';


class Network {
  var filter;
  var text;
  var current_place;

  Map<int,dynamic> store_dict = Map();

  // var bottom_left;
  Network(this.filter, this.text);

  Future<dynamic> getJsonData() async {
    var store;
    Map<String, dynamic>? one_dict;

    String url2 = '';
    // 위도경도 바뀌는 코드!!!!!!!!!!!!!!!!
    double rightUpLat = rightUpPosition.latitude;
    double rightUpLon = rightUpPosition.longitude;
    double leftDownLat = leftDownPosition.latitude;
    double leftDownLon = leftDownPosition.longitude;

    double max_lat = 37.7151;
    double max_lon = 127.2693;
    double min_lat = 37.4132;
    double min_lon = 126.7340;


    rightUpLat = min(rightUpLat, max_lat);
    rightUpLon = min(rightUpLon,max_lon);
    leftDownLat = min(leftDownLat,min_lat);
    leftDownLon = min(leftDownLon,min_lon);


    // 필터 클릭, 이지도 재검색 클릭
    if(text == '') {
      String cat_url = '';
      List<dynamic> category = filter[0];
      if (category.length > 0) {
        cat_url = cat_url + '&category=${category[0]}';
        for (int i = 1; i < category.length; i++) {
          cat_url = cat_url + '-${category[i]}';
        }
      }

      // 카테고리 추가!!
      // 서비스
      if (filter[1].length > 0) {
        cat_url = cat_url + '&service=${filter[1][0]}';
        for (int i = 1; i < filter[1].length; i++) {
          cat_url = cat_url + '-${filter[1][i]}';
        }
      }

      // 테마
      if (filter[2].length > 0) {
        cat_url = cat_url + '&theme=${filter[2][0]}';
        for (int i = 1; i < filter[2].length; i++) {
          cat_url = cat_url + '-${filter[2][i]}';
        }
      }

      url2 = 'http://34.64.102.13/api/search?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}' + cat_url;
      http.Response response = await http.get(Uri.parse(url2));
      if (response.statusCode == 200) {
        var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
        store = parsingData;
      }

      // // 개수에 따라 줌 늘리기
      // for (int num = 0; num < 4; num++) {
      //
      //   rightUpLat = min(rightUpPosition.latitude, max_lat);
      //   rightUpLon = min(rightUpPosition.longitude,max_lon);
      //   leftDownLat = max(leftDownPosition.latitude,min_lat);
      //   leftDownLon = max(leftDownPosition.longitude,min_lon);
      //
      //   url2 = 'http://34.64.166.110/api/search?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}' + cat_url;
      //
      //   print('url!!!!!!!!!!!!11111=======');
      //   print(url2);
      //   http.Response response = await http.get(Uri.parse(url2));
      //   if (response.statusCode == 200) {
      //     var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
      //     store = parsingData;
      //     print('store 길이 : ${store.length}');
      //     if(store.length<10){
      //       zoomout();
      //     }
      //     else{
      //       break;
      //     }
      //   }
      // }
    }



    // text
    if(text != '') {
      url2 = 'http://34.64.102.13/api/search?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}';
      url2 = url2 + '&text=${text}';
      http.Response response = await http.get(Uri.parse(url2));
      if (response.statusCode == 200) {
        var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
        store = parsingData;
      }
    }

    for (int i=0;i<store.length;i++){
      one_dict = change_data(store[i], 'network').cast<String, dynamic>();
      store_dict[i] = one_dict;
    }
    return store_dict;
  }
}

// rightUpLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)), max_lat);
// rightUpLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)),max_lon);
// leftDownLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)),min_lat);
// leftDownLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)),min_lon);
// String url2 = 'http://34.64.166.110/api/testsearch?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}';
//
// http.Response response = await http.get(Uri.parse(url2));
//
// if (response.statusCode == 200) {
//   //String jsonData = response.body;


class open_Network {
  var uid;
  open_Network(this.uid);

  Future<dynamic> getJsonData() async {
    String url = 'http://34.64.102.13/api/is-opening?store_id=${uid}';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}


class uid_Network {
  var uid;
  uid_Network(this.uid);

  Future<dynamic> getJsonData() async {
    Map<String, dynamic>? store_dict;
    String url = 'http://34.64.102.13/api/info-from-id?store_id=${uid}';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
      var store = parsingData;
      store_dict = change_data(store, 'uid').cast<String, dynamic>();
      open_Network open_network = open_Network(uid);
      var isOpen = await open_network.getJsonData();
      store_dict['open'] = isOpen;
      return store_dict;
    }
  }
}

Map change_time(hour){
  Map<String,String> get_time = {};
  List week = ['월','화','수','목','금','토','일'];
  for(int i=0;i<hour.length;i++){
    if(hour[i][week[i]] == 'None'){
      get_time[week[i]] = '정보없음';
    }
    else{
      get_time[week[i]] = hour[i][week[i]];
    }
  }
  return get_time;
}


Map change_data(store_i, how) {
  Map<String,dynamic> name = {
    '해산물(게)': 'food_korean_seafood_crab',
    '해산물(문어)': 'food_korean_seafood_octopus',
    '해산물(생선)': 'food_korean_seafood_fish',
    '해산물(조개)': 'food_korean_seafood_seashell',
    '한식' : 'food_korean',
    '양식' : 'food_western',
    '중식' : 'food_chinese',
    '일식' : 'food_japanese',
    '분식': 'food_korean_snack',
    '고기': 'food_korean_meat',
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

  Map<String,String> menu = {};
  Map<String,String> opening_hour = {};
  // Map<String,String> opening_breaktime = {};
  // Map<String,String> opening_lastorder = {};
  Map<String,dynamic> one_dict = {};
  List<String> store_img = new List.empty(growable: true);

  one_dict['uid'] = store_i['id'];
  try {
    one_dict["latitude"] = double.parse(store_i['source']['location']["lat"]);
    one_dict["longitude"] = double.parse(store_i['source']['location']["lon"]);
  }
  catch(e) {}

  one_dict['main_category'] = 'assets/marker_image/${name[store_i['source']["main_category"]]}_${double.parse(store_i['source']['naver_star']).toStringAsFixed(1)}.png';

  one_dict['naver_star'] = double.parse(store_i['source']['naver_star']);

  if(how == 'network'){
    return one_dict;
  }

  one_dict['store_name'] = store_i['source']['name'];
  one_dict["road_address"] = "서울 " + store_i['source']["road_address"];
  one_dict["jibun_address"] = "서울 " + store_i['source']["jibun_address"];

  try {
    one_dict["call"] = store_i['source']["call"].replaceAll(RegExp('[^0-9\\s]'), "");
  }
  catch(e) {}

  List site_info = ['kakao_star','kakao_cnt','naver_star','naver_cnt','google_star','google_cnt'];
  for(int j=0;j<site_info.length;j = j+2){
    one_dict[site_info[j]] = double.parse(store_i['source'][site_info[j]]);
    one_dict[site_info[j+1]] = int.parse(store_i['source'][site_info[j+1]]);
  }

  try {
    one_dict['category'] = store_i['source']["category"].split('-');
  }
  catch(e){}

  // 시간
  try{
    one_dict['opening_hour'] = change_time(store_i['source']['opening_hour']);
  }
  catch(e){
    one_dict['opening_hour'] = {};
  }

  try{
    one_dict['opening_breaktime'] = change_time(store_i['source']['opening_breaktime']);
  }
  catch(e){}

  try{
    one_dict['opening_lastorder'] = change_time(store_i['source']['opening_lastorder']);
  }
  catch(e){}


  one_dict['theme'] = store_i['source']["theme"].split('-');
  one_dict['service'] = store_i['source']["service"].split('-');

  // 메뉴
  try{
    for(int j=0;j<store_i['source']['menu'].length;j++){
      Map<String,String> one_menu = {};
      one_menu[store_i['source']['menu'][j].split(':')[0]] = store_i['source']['menu'][j].split(':')[1];
      menu.addAll(one_menu);
    }
    one_dict['menu'] = menu;
  }
  catch(e){
    Map<String,String> menu = {};
    one_dict['menu'] = menu;
  }


  try {
    one_dict["latitude"] = double.parse(store_i['source']['location']["lat"]);
    one_dict["longitude"] = double.parse(store_i['source']['location']["lon"]);
  }
  catch(e) {}

  // one_dict["store_image"] = store_i['source']["outer_image"];
  for(int j=0;j<store_i['source']["outer_image"].length;j++){
    store_img.add(store_i['source']["outer_image"][j]);
  }
  one_dict["store_image"] = store_img;

  // url
  one_dict['kakao_review_url'] = 'https://place.map.kakao.com/m/11101743#comment';
  one_dict['google_review_url'] = 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko';
  one_dict['naver_review_url'] = 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll';

  // open_Network open_network = open_Network(store_i['id']);
  // var isOpen = await open_network.getJsonData();
  // one_dict['open'] = isOpen;
  return one_dict;
}







List read_all(){
  final _FilterPageController = Get.put(FilterPageController());
  var filter = new List.empty(growable: true);
  var category = new List.empty(growable: true);
  var service = new List.empty(growable: true);
  var theme = new List.empty(growable: true);

  Map<String,dynamic> name = {'해산물(게)': 'Food-Korean-Seafood-Crab',
    '해산물(문어)': 'Food-Korean-Seafood-Octopus',
    '해산물(생선)': 'Food-Korean-Seafood-Fish',
    '해산물(조개)': 'Food-Korean-Seafood-Seashell',
    '분식': 'Food-Korean-Snack',
    '고기': 'Food-Korean-Meat',
    '고기(구이)': 'Food-Korean-Meat',
    '전': 'Food-Korean-Jeon',
    '곱/대/막창': 'Food-Korean-Giblets',
    '백반/죽/찌개': 'Food-Korean-Meal',
    '국밥': 'Food-Korean-Gukbap',
    '전골/탕/찜': 'Food-Korean-Stew',
    '냉면/국수': 'Food-Korean-Noodles',
    '기타(한식)': 'Food-Korean-Etc',
    '피자': 'Food-Western-Pizza',
    '샌드위치': 'Food-Western-Sandwich',
    '햄버거': 'Food-Western-Hamburger',
    '파스타': 'Food-Western-Pasta',
    '스테이크': 'Food-Western-Steak',
    '기타(양식)': 'Food-Western-Etc',
    '마라/훠궈': 'Food-Chinese-Hotpot',
    '딤섬': 'Food-Chinese-Dimsum',
    '중국집': 'Food-Chinese-Restaurant',
    '양꼬치': 'Food-Chinese-Lambskewers',
    '기타(중식)': 'Food-Chinese-Etc',
    '초밥/회': 'Food-Japanese-Sushi',
    '돈까스': 'Food-Japanese-Porkcutlet',
    '라멘': 'Food-Japanese-Ramen',
    '우동/메밀': 'Food-Japanese-Udon',
    '덮밥': 'Food-Japanese-Dnburi',
    '기타(일식)': 'Food-Japanese-Etc',
    '아시안': 'Food-Asian',
    '멕시칸': 'Food-Mexican',
    '기타': 'Food-ETC',
    '프랜차이즈': 'Cafe-Franchise',
    '개인': 'Cafe-Private',
    '주점': 'Alcohol-Pub',
    '호프': 'Alcohol-Hof',
    '이자카야': 'Alcohol-Izakaya',
    '와인': 'Alcohol-Wine',
    '칵테일,양주': 'Alcohol-Cocktail'};
  // print('위치정보');
  // print(naver.centerPosition);
  // print(naver.rightUpPosition);
  // print(naver.leftDownPosition);
  // filter.add(naver.rightUpPosition);
  // filter.add(naver.leftDownPosition);
  // // filter.add(naver.centerPosition);
  // filter.add(naver.rightUpPosition);


  // print('필터 정보');
  // 한식, 양식, 중식, 일식, 베트남, 멕시칸, 기타 선택 여부
  List<String> food = ["한식", "양식", "중식", "일식", "베트남", "멕시칸", "기타"];
  for(int i=0;i<_FilterPageController.OuterFoodSelected.length;i++){
    if(_FilterPageController.OuterFoodSelected[i]==true){
      category.add(food[i]);
    }
  }
  // 프랜차이즈, 개인 선택 여부
  List<String> cafe = ["프랜차이즈", "개인"];
  for(int i=0;i<_FilterPageController.OuterCafeSelected.length;i++){
    if(_FilterPageController.OuterCafeSelected[i]==true){
      category.add(cafe[i]);
    }
  }
  // 주점, 호프, 와인, 이자카야, 칵테일/양주 선택 여부
  List<String> alchol = ["주점", "호프", "와인", "이자카야", "칵테일/양주"];
  for(int i=0;i<_FilterPageController.OuterAlcoholSelected.length;i++){
    if(_FilterPageController.OuterAlcoholSelected[i]==true){
      category.add(alchol[i]);
    }
  }
  // 주차, 24시 영업, 포장, 예약, 애완동물 출입가능, 코스, 뷔페, 배달, 무한리필, 오마카세, 미슐랭, 콜키지, 룸 선택 여부
  List<String> service_name = ["주차", "24시 영업", "포장", "예약", "애완동물 출입가능", "코스", "뷔페", "배달", "무한리필", "오마카세", "미슐랭", "콜키지", "룸"];
  for(int i=0;i<_FilterPageController.OuterServiceSelected.length;i++){
    if(_FilterPageController.OuterServiceSelected[i]==true){
      service.add(service_name[i]);
    }
  }
  // 데이트, 가성비, 조용한, 친절한, 인스타, 깨끗한, 고급, 이색적인, 혼밥, 단체, 다이어트, 뷰가 좋은, 방송 맛집 선택 여부
  List<String> mood = ["데이트", "가성비", "조용한", "친절한", "인스타", "깨끗한", "고급", "이색적인", "혼밥", "단체", "다이어트", "뷰가 좋은", "방송 맛집"];
  for(int i=0;i<_FilterPageController.OuterMoodSelected.length;i++){
    if(_FilterPageController.OuterMoodSelected[i]==true){
      theme.add(mood[i]);
    }
  }
  filter.add(category);
  filter.add(service);
  filter.add(theme);

  print("================================================================");
  print(filter);
  return filter;
}


double get_distance(position, myPosition) {
  // final Position myPosition = await Geolocator.getCurrentPosition();

  var p = 0.017453292519943295;
  var c = cos;
  var lat1 = position.latitude;
  var lon1 = position.longitude;
  var lat2 = myPosition.latitude;
  var lon2 = myPosition.longitude;
  var a = 0.5 - c((lat2 - lat1) * p)/2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
  return double.parse((12742 * asin(sqrt(a))).toStringAsFixed(1));
}


Future<void> zoomout() async {
  print('이전');
  print(rightUpPosition);
  print(leftDownPosition);
  final naverMapController = await naverMapCompleter.future;
  naverMapController.moveCamera(CameraUpdate.zoomOut());
  print('이후');
  print(rightUpPosition);
  print(leftDownPosition);
}