import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_model.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class CustomMarker extends Marker {

  NaverMapPageModel restaurant;

  CustomMarker({
    required this.restaurant,
    required LocationClass position,
  }) : super(
      width: 51,
      height: 69,
      markerId: restaurant.uid,
      position: position,
      anchor: AnchorPoint(0.15,0.85),
      captionText: restaurant.name,
      captionTextSize: 10,
      captionColor: Color(0xfff42957),
      captionHaloColor: Colors.white,
      captionOffset: 0,
      captionPerspectiveEnabled: true,
  );

  factory CustomMarker.fromRestaurant(NaverMapPageModel restaurant) =>
      CustomMarker(
        restaurant: restaurant,
        position: restaurant.position,
      );

  Future<void> createImage(BuildContext context) async {
    this.icon =  await OverlayImage.fromAssetImage(assetName: this.restaurant.markerImage, context: context);
  }

  void Function(Marker marker, Map<String, int> iconSize) setOnMarkerTab(void Function(Marker marker, Map<String, int> iconSize) callBack){
    return callBack;
  }
}