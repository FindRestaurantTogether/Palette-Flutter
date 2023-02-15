import 'package:hive/hive.dart';
part 'recentsearch_model.g.dart';

@HiveType(typeId: 0)
class RecentSearchModel extends HiveObject {
  @HiveField(0)
  final String recentSearchWord;

  RecentSearchModel({
    required this.recentSearchWord
  });
}