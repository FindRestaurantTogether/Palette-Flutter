import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:myapp/page/favorite/favorite_model.dart';
import 'package:myapp/page/favorite/favorite_page_controller.dart';
import 'package:myapp/page/loading/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/page/map/search/recentsearch_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );

  await Hive.initFlutter();
  Hive.registerAdapter(RecentSearchModelAdapter());
  Hive.registerAdapter(FavoriteModelAdapter());
  Hive.registerAdapter(RestaurantModelAdapter());
  await Hive.openBox<RecentSearchModel>('recentsearch');
  await Hive.openBox<FavoriteModel>('favorite');

  Box<RecentSearchModel> recentSearchBox =  Hive.box<RecentSearchModel>('recentsearch');
  recentSearchBox.clear();
  Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');
  favoriteBox.clear();


  final _FavoritePageController = Get.put(FavoritePageController());
  // Box<FavoriteModel> favoriteBox =  Hive.box<FavoriteModel>('favorite');
  List<FavoriteModel> favoriteFolders = favoriteBox.values.toList().cast<FavoriteModel>();
  for (int i=0; i<favoriteFolders.length; i++) {
    for (int j=0 ; j<favoriteFolders[i].favoriteFolderRestaurantList.length; j++) {
      _FavoritePageController.favoriteRestaurantUids.add(favoriteFolders[i].favoriteFolderRestaurantList[j].uid);
    }
  }


  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'f967051526ddc92370564aba68e7ba65',
    javaScriptAppKey: 'bbaa604b07ac838b689d7529d40425de',
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SUIT-otf',
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: RemoveScrollGlow(),
            child: child!,
          );
        },
        home: LoadingPage()
    );
  }
}

// 맨 아래 또는 맨 위로 갈 때 glow 생기는거 없애기
class RemoveScrollGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}