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

  // var bottom_left;
  Network(this.filter, this.text);

  // String url = 'http://34.64.166.110/api/testsearch?top_right_lat=37.4986&top_right_lon=127.0202&bottom_left_lat=37.4132&bottom_left_lon=126.734';

  Future<dynamic> getJsonData() async {
    // ?top-right-lat=37.5779&top-right-lon=127.0388&bottom-left-lat=37.4899&bottom-left-lon=126.9617
    // &category=Food-Chinese-Etc&category=Food-Western-Etc&text=감자나라

    var store;

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

    for (int size = 1; size <= 8; size++) {
      rightUpLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)) +
          lat_one_size * size, max_lat);
      rightUpLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)) +
          lon_one_size * size, max_lon);
      leftDownLat = min(double.parse(filter[0].latitude.toStringAsFixed(4)) -
          lat_one_size * size, min_lat);
      leftDownLon = min(double.parse(filter[0].longitude.toStringAsFixed(4)) -
          lon_one_size * size, min_lon);
      String url2 = 'http://34.64.166.110/api/testsearch?top_right_lat=${rightUpLat}&top_right_lon=${rightUpLon}&bottom_left_lat=${leftDownLat}&bottom_left_lon=${leftDownLon}';

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

      print(url2);
      http.Response response = await http.get(Uri.parse(url2));
      if (response.statusCode == 200) {
        //String jsonData = response.body;
        var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
        store = parsingData;
        print("길이 ${store.length}");
        if (store.length == 30) {
          break;
        }
      }
    }
    Map store_dict = change_data(store);
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
    String url = 'http://34.64.166.110/api/idsearch?store_id=${uid}';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
      var store = parsingData;
      Map store_dict = change_data(store);
      return store_dict;
    }
  }
}



Map change_data(store){
  Map<String,dynamic> store_dict = Map();
  Map<String,dynamic> name = {'해산물(게)': 'Food_Korean_Seafood_Crab',
    '해산물(문어)': 'Food_Korean_Seafood_Octopus',
    '해산물(생선)': 'Food_Korean_Seafood_Fish',
    '해산물(조개)': 'Food_Korean_Seafood_Seashell',
    '한식' : 'Food_Korean',
    '양식' : 'Food_Western',
    '중식' : 'Food_Chinese',
    '일식' : 'Food_Japanese',
    '분식': 'Food_Korean_Snack',
    '고기': 'Food_Korean_Meat',
    '전': 'Food_Korean_Jeon',
    '곱/대/막창': 'Food_Korean_Giblets',
    '백반/죽/찌개': 'Food_Korean_Meal',
    '국밥': 'Food_Korean_Gukbap',
    '전골/탕/찜': 'Food_Korean_Stew',
    '냉면/국수': 'Food_Korean_Noodles',
    '기타(한식)': 'Food_Korean_Etc',
    '피자': 'Food_Western_Pizza',
    '샌드위치': 'Food_Western_Sandwich',
    '햄버거': 'Food_Western_Hamburger',
    '파스타': 'Food_Western_Pasta',
    '스테이크': 'Food_Western_Steak',
    '기타(양식)': 'Food_Western_Etc',
    '마라/훠궈': 'Food_Chinese_Hotpot',
    '딤섬': 'Food_Chinese_Dimsum',
    '중국집': 'Food_Chinese_Restaurant',
    '양꼬치': 'Food_Chinese_Lambskewers',
    '기타(중식)': 'Food_Chinese_Etc',
    '초밥/회': 'Food_Japanese_Sushi',
    '돈까스': 'Food_Japanese_Porkcutlet',
    '라멘': 'Food_Japanese_Ramen',
    '우동/메밀': 'Food_Japanese_Udon',
    '덮밥': 'Food_Japanese_Dnburi',
    '기타(일식)': 'Food_Japanese_Etc',
    '아시안': 'Food_Asian',
    '멕시칸': 'Food_Mexican',
    '기타': 'Food_ETC',
    '프랜차이즈': 'Cafe_Franchise',
    '개인': 'Cafe_Private',
    '주점': 'Alcohol_Pub',
    '호프': 'Alcohol_Hof',
    '이자카야': 'Alcohol_Izakaya',
    '와인': 'Alcohol_Wine',
    '칵테일,양주': 'Alcohol_Cocktail'};

  for(int i=0;i<store.length;i++){
    Map<String,dynamic> menu = Map();
    Map<String,dynamic> opening_hour = Map();
    Map<String,dynamic> opening_breaktime = Map();
    Map<String,dynamic> opening_lastorder = Map();
    Map<String,dynamic> one_dict = Map();
    one_dict['uid'] = store[i]['id'];
    one_dict['name'] = store[i]['source']['name'];
    one_dict["road_address"] = "서울 " + store[i]['source']["road_address"];
    one_dict["jibun_address"] = "서울 " + store[i]['source']["jibun_address"];

    try {
      one_dict["call"] = store[i]['source']["call"].replaceAll(RegExp('[^0-9\\s]'), "");
    }
    catch(e) {}

    one_dict['main_category'] = name[store[i]['source']["main_category"]];
    one_dict['category'] = store[i]['source']["category"].split('-');

    // 시간
    try{
      for(int j=0;j<store[i]['source']['opening_hour'].length;j++){
        opening_hour.addAll(store[i]['source']['opening_hour'][j]);
      }
      one_dict['opening_hour'] = opening_hour;
    }
    catch(e){}
    try{
      for(int j=0;j<store[i]['source']['opening_breaktime'].length;j++){
        opening_breaktime.addAll(store[i]['source']['opening_breaktime'][j]);
      }
      one_dict['opening_breaktime'] = opening_breaktime;
    }
    catch(e){}
    try{
      for(int j=0;j<store[i]['source']['opening_lastorder'].length;j++){
        opening_lastorder.addAll(store[i]['source']['opening_lastorder'][j]);
      }
      one_dict['opening_lastorder'] = opening_lastorder;
    }
    catch(e){}


    one_dict['theme'] = store[i]['source']["theme"].split('-');
    one_dict['service'] = store[i]['source']["service"].split('-');

    // 메뉴
    try{
      for(int j=0;j<store[i]['source']['menu'].length;j++){
        Map<String,String> one_menu = {};
        one_menu[store[i]['source']['menu'][j].split(':')[0]] = store[i]['source']['menu'][j].split(':')[1];
        menu.addAll(one_menu);
      }
      one_dict['menu'] = menu;
    }
    catch(e){}


    try {
      one_dict["latitude"] = double.parse(store[i]['source']['location']["lat"]);
      one_dict["longitude"] = double.parse(store[i]['source']['location']["lon"]);
    }
    catch(e) {}
    List site_info = ['kakao_star','kakao_cnt','naver_star','naver_cnt','google_star','google_cnt'];
    for(int j=0;j<site_info.length;j = j+2){
      one_dict[site_info[j]] = double.parse(store[i]['source'][site_info[j]]);
      one_dict[site_info[j+1]] = int.parse(store[i]['source'][site_info[j+1]]);
    }

    // url
    one_dict['kakao_review_url'] = 'https://place.map.kakao.com/m/11101743#comment';
    one_dict['google_review_url'] = 'https://www.google.co.kr/maps/place/%EC%95%85%EC%96%B4%EB%96%A1%EB%B3%B6%EC%9D%B4/data=!4m16!1m7!3m6!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!2z7JWF7Ja065ah67O27J20!8m2!3d37.5606004!4d127.0410712!16s%2Fg%2F11bwf81cmq!3m7!1s0x357ca4a7947b9d09:0xec0032b0df2fe422!8m2!3d37.5606004!4d127.0410712!9m1!1b1!16s%2Fg%2F11bwf81cmq?hl=ko';
    one_dict['naver_review_url'] = 'https://m.place.naver.com/restaurant/1988367250/review/visitor?entry=pll';

    store_dict["$i"] = one_dict;
  }
  return store_dict;
}






//   // try{
//   //   for(int j=0;j<store[i]['source']['opening_breaktime'].length;j++){
//   //     opening_breaktime.addAll(store[i]['source']['opening_breaktime'][j]);
//   //   }
//   //   store[i]['source']['opening_breaktime'] = opening_breaktime;
//   // }
//   // catch(e){}
//   // try{
//   //   for(int j=0;j<store[i]['source']['opening_lastorder'].length;j++){
//   //     opening_lastorder.addAll(store[i]['source']['opening_lastorder'][j]);
//   //   }
//   //   store[i]['source']['opening_lastorder'] = opening_lastorder;
//   // }
//   // catch(e){}

//   // try {
//   //   store["store$i"]['main_category'] = name[store["store$i"]['main_category']];
//   // }
//   // catch(e) {}
//
//






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