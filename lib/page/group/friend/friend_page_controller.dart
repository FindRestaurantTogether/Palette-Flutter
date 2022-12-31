import 'package:get/get.dart';
import 'package:myapp/page/group/friend/add_friend_page_model.dart';

class FriendPageController extends GetxController {

  var friends = <friendModel>[];
  RxList<friendModel> selectedFriends = <friendModel>[].obs;
  var waitForAcceptanceFriends = <friendModel>[];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    // await Future.delayed(Duration(seconds: 2));
    var friendData = [
      friendModel(image: 'assets/login_image/food.png', name: '김학현', selected: false),
      friendModel(image: 'assets/login_image/food.png', name: '유환규', selected: false),
      friendModel(image: 'assets/login_image/food.png', name: '김현중', selected: false),
      friendModel(image: 'assets/login_image/food.png', name: '고영재', selected: false),
      friendModel(image: 'assets/login_image/food.png', name: '방채영', selected: false),
    ];
    friends.assignAll(friendData);
  }

  bool isSelectedFriendsPart = true;
  bool get sFP => isSelectedFriendsPart;

  void isSelectedFriendsPartChangeState() {
    isSelectedFriendsPart = !isSelectedFriendsPart;
    update();
  }

}