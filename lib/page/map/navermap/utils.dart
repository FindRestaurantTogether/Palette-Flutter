import 'dart:convert';
import 'package:get/get.dart';
import 'package:myapp/page/map/filter/filter_page_controller.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart' as naver;
import 'package:http/http.dart' as http;

class Network{
  var filter;
  var text;
  // var bottom_left;
  Network(this.filter, this.text);

  String url = 'http://34.64.35.77/api/search/map';

  Map<String,dynamic> store_dict = Map();
  Map<String,dynamic> menu = Map();
  Map<String,dynamic> hour = Map();
  Map<String,dynamic> name = {'해산물(게)': 'Food_Korean_Seafood_Crab',
    '해산물(문어)': 'Food_Korean_Seafood_Octopus',
    '해산물(생선)': 'Food_Korean_Seafood_Fish',
    '해산물(조개)': 'Food_Korean_Seafood_Seashell',
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

  Future<dynamic> getJsonData() async {
    // ?top-right-lat=37.5779&top-right-lon=127.0388&bottom-left-lat=37.4899&bottom-left-lon=126.9617
    // &category=Food-Chinese-Etc&category=Food-Western-Etc&text=감자나라
    String url2 = 'http://34.64.35.77/api/search/map?top-right-lat=${filter[0].latitude}&top-right-lon=${filter[0].longitude}&bottom-left-lat=${filter[1].latitude}&bottom-left-lon=${filter[1].longitude}';
    List<dynamic> category = filter[2];
    if(category.length>0){
      url2 = url2 + 'category=${category[0]}';
      for(int i = 1;i<category.length;i++){
        url2 = url2 + '&${category[i]}';
      }
    }
    if(text != ''){
      url2 = url2 + '&text=${text}';
    }
    print(url2);

    http.Response response = await http.get(Uri.parse(url));
    return response;
    // if (response.statusCode == 200) {
    //   //String jsonData = response.body;
    //   var parsingData = jsonDecode(utf8.decode(response.bodyBytes));
    //   var store = parsingData;
    //   print(store); ///////////////////////////////
    //   return store;
      // for(int i=1;i<=store.length;i++){
      //   try {
      //     store["store$i"]["road_address"] = "서울 " + store["store$i"]["road_address"];
      //   }
      //   catch(e) {}
      //   try {
      //     store["store$i"]["latitude"] = double.parse(store["store$i"]["latitude"]);
      //   }
      //   catch(e) {}
      //   try {
      //     store["store$i"]["longitude"] = double.parse(store["store$i"]["longitude"]);
      //   }
      //   catch(e) {}
      //   try {
      //     store["store$i"]["call"] = store["store$i"]["call"].replaceAll(RegExp('[^0-9\\s]'), "");
      //   }
      //   catch(e) {}
      //   try {
      //     store["store$i"]['kakao_star'] = double.parse(store["store$i"]['kakao_star']);
      //     store["store$i"]['kakao_cnt'] = int.parse(store["store$i"]['kakao_cnt']);
      //   }
      //   catch(e) {}
      //   try {
      //     store["store$i"]['naver_star'] = double.parse(store["store$i"]['naver_star']);
      //     store["store$i"]['naver_cnt'] = int.parse(store["store$i"]['naver_cnt']);
      //   }
      //   catch(e) {}
      //   try {
      //     store["store$i"]['google_star'] = double.parse(store["store$i"]['google_star']);
      //     store["store$i"]['google_cnt'] = int.parse(store["store$i"]['google_cnt']);
      //   }
      //   catch(e) {}
      //   try{
      //     for(int j=0;j<store["store$i"]['opening_hour'].length;j++){
      //       hour.addAll(store["store$i"]['opening_hour'][j]);
      //     }
      //     store["store$i"]['opening_hour'] = hour;
      //   }
      //   catch(e){}
      //   try{
      //     for(int j=0;j<store["store$i"]['menu'].length;j++){
      //       menu.addAll(store["store$i"]['menu'][j]);
      //     }
      //     store["store$i"]['menu'] = menu;
      //   }
      //   catch(e){}
      //   try {
      //     store["store$i"]['main_category'] = name[store["store$i"]['main_category']];
      //   }
      //   catch(e) {}
      //   store_dict["$i"] = store["store$i"];
      // }
      // return store_dict;
    // }
  }
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