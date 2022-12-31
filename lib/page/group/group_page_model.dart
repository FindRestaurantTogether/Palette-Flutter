import 'package:myapp/page/group/friend/add_friend_page_model.dart';

class groupModel {
  String groupName;
  bool groupCheckCalender;
  String groupDate;
  bool groupCheckAlarm;
  List<friendModel> groupFriendsList;

  groupModel({required this.groupName, required this.groupCheckCalender, required this.groupDate, required this.groupCheckAlarm, required this.groupFriendsList});
}