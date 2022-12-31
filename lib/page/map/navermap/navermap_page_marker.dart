import 'package:flutter/cupertino.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class CustomMarker extends Marker {

  NaverMapPageModel restaurant;

  CustomMarker({
    required this.restaurant,
    required String markerId,
    required LocationClass position,
    required AnchorPoint anchor,
  }) : super(width: 50, height: 80, markerId: markerId, position: position, anchor: anchor);

  factory CustomMarker.fromRestaurant(NaverMapPageModel restaurant) =>
      CustomMarker(restaurant: restaurant, markerId: restaurant.markerId, anchor: restaurant.anchor, position: restaurant.position);

  Future<void> createImage(BuildContext context) async {
    this.icon =  await OverlayImage.fromAssetImage(assetName: this.restaurant.markerImage, context: context);
  }

  void Function(Marker marker, Map<String, int> iconSize) setOnMarkerTab(void Function(Marker marker, Map<String, int> iconSize) callBack){
    return callBack;
  }
}