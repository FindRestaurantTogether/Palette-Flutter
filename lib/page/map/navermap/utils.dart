import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart' as naver;
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;
import 'dart:math';


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
    // 위도경도 바뀌는 코드!!!!!!!!!!!!!!!!
    double rightUpLat;
    double rightUpLon;
    double leftDownLat;
    double leftDownLon;

    double max_lat = 37.7151;
    double max_lon = 127.2693;
    double min_lat = 37.4132;
    double min_lon = 126.7340;
    double lat_one_size = filter[0].latitude - filter[2].latitude;
    double lon_one_size = filter[0].longitude - filter[2].longitude;

    // for (int size = 1; size <= 8; size++) {
    //   rightUpLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)) +
    //       lat_one_size * size, max_lat);
    //   rightUpLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)) +
    //       lon_one_size * size, max_lon);
    //   leftDownLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)) -
    //       lat_one_size * size, min_lat);
    //   leftDownLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)) -
    //       lon_one_size * size, min_lon);
    //   String url2 = 'http://34.64.166.110/api/testsearch?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}';


    // List<dynamic> category = filter[3];
    // if(category.length>0){
    //   url2 = url2 + 'category=${category[0]}';
    //   for(int i = 1;i<category.length;i++){
    //     url2 = url2 + '&${category[i]}';
    //   }
    // }
    // if(text != ''){
    //   url2 = url2 + '&text=${text}';
    // }

    //   print(url2);
    //   http.Response response = await http.get(Uri.parse(url2));
    //   if (response.statusCode == 200) {
    //     //String jsonData = response.body;
    //     var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
    //     store = parsingData;
    //     print("길이 ${store.length}");
    //     if (store.length == 30) {
    //       break;
    //     }
    //   }
    // }

    rightUpLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)), max_lat);
    rightUpLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)),max_lon);
    leftDownLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)),min_lat);
    leftDownLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)),min_lon);
    String url2 = 'http://34.64.166.110/api/testsearch?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}';

    http.Response response = await http.get(Uri.parse(url2));
    if (response.statusCode == 200) {
      //String jsonData = response.body;
      var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
      store = parsingData;
    }

    for (int i=0;i<store.length;i++){
      one_dict = change_data(store[i]).cast<String, dynamic>();
      open_Network open_network = open_Network(one_dict['id']);
      var isOpen = await open_network.getJsonData();
      one_dict['open'] = isOpen;
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
    String url = 'http://34.64.166.110/api/isopeing?store_id=${uid}';
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
    String url = 'http://34.64.166.110/api/idsearch?store_id=${uid}';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
      var store = parsingData;
      store_dict = change_data(store).cast<String, dynamic>();
      open_Network open_network = open_Network(uid);
      var isOpen = await open_network.getJsonData();
      store_dict['open'] = isOpen;
      return store_dict;
    }
  }
}



Map change_data(store_i) {
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

  Map<String,int> menu = Map();
  Map<String,String> opening_hour = Map();
  Map<String,String> opening_breaktime = Map();
  Map<String,String> opening_lastorder = Map();
  Map<String,dynamic> one_dict = Map();
  one_dict['uid'] = store_i['id'];
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

  one_dict['main_category'] = 'assets/marker_image/${name[store_i['source']["main_category"]]}_${one_dict['naver_star'].toStringAsFixed(1)}.png';
  one_dict['category'] = store_i['source']["category"].split('-');

  // 시간
  try{
    for(int j=0;j<store_i['source']['opening_hour'].length;j++){
      opening_hour.addAll(store_i['source']['opening_hour'][j]);
    }
    one_dict['opening_hour'] = opening_hour;
  }
  catch(e){}

  try{
    for(int j=0;j<store_i['source']['opening_breaktime'].length;j++){
      opening_breaktime.addAll(store_i['source']['opening_breaktime'][j]);
    }
    one_dict['opening_breaktime'] = opening_breaktime;
  }
  catch(e){}

  try{
    for(int j=0;j<store_i['source']['opening_lastorder'].length;j++){
      opening_lastorder.addAll(store_i['source']['opening_lastorder'][j]);
    }
    one_dict['opening_lastorder'] = opening_lastorder;
  }
  catch(e){}


  one_dict['theme'] = store_i['source']["theme"].split('-');
  one_dict['service'] = store_i['source']["service"].split('-');

  // 메뉴
  try{
    for(int j=0;j<store_i['source']['menu'].length;j++){
      Map<String,int> one_menu = {};
      one_menu[store_i['source']['menu'][j].split(':')[0]] = int.parse(store_i['source']['menu'][j].split(':')[1]);
      menu.addAll(one_menu);
    }
    one_dict['menu'] = menu;
  }
  catch(e){}


  try {
    one_dict["latitude"] = double.parse(store_i['source']['location']["lat"]);
    one_dict["longitude"] = double.parse(store_i['source']['location']["lon"]);
  }
  catch(e) {}

  one_dict["store_image"] = store_i["outer_image"];

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
  filter.add(naver.rightUpPosition);
  filter.add(naver.leftDownPosition);
  // filter.add(naver.centerPosition);
  filter.add(naver.rightUpPosition);


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
  List<String> service = ["주차", "24시 영업", "포장", "예약", "애완동물 출입가능", "코스", "뷔페", "배달", "무한리필", "오마카세", "미슐랭", "콜키지", "룸"];
  for(int i=0;i<_FilterPageController.OuterServiceSelected.length;i++){
    if(_FilterPageController.OuterServiceSelected[i]==true){
      category.add(service[i]);
    }
  }
  // 데이트, 가성비, 조용한, 친절한, 인스타, 깨끗한, 고급, 이색적인, 혼밥, 단체, 다이어트, 뷰가 좋은, 방송 맛집 선택 여부
  List<String> mood = ["데이트", "가성비", "조용한", "친절한", "인스타", "깨끗한", "고급", "이색적인", "혼밥", "단체", "다이어트", "뷰가 좋은", "방송 맛집"];
  for(int i=0;i<_FilterPageController.OuterMoodSelected.length;i++){
    if(_FilterPageController.OuterMoodSelected[i]==true){
      category.add(mood[i]);
    }
  }
  filter.add(category);

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