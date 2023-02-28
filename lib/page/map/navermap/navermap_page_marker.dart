import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page/map/navermap/navermap_page.dart';
import 'package:myapp/page/map/navermap/navermap_page_abstract_model.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class CustomMarker extends Marker {

  AbstractNaverMapPageModel abstractRestaurant;

  CustomMarker({
    required this.abstractRestaurant,
    required LocationClass position,
  }) : super(
      width: 50,
      height: 82,
      markerId: abstractRestaurant.uid,
      position: position,
      anchor: AnchorPoint(0.15,0.7),
  );

  factory CustomMarker.fromRestaurant(AbstractNaverMapPageModel abstractRestaurant) =>
      CustomMarker(
        abstractRestaurant: abstractRestaurant,
        position: abstractRestaurant.position,
      );

  Future<void> createImage(BuildContext context) async {
    this.icon =  await OverlayImage.fromAssetImage(assetName: this.abstractRestaurant.main_category, context: context);
  }

  void Function(Marker marker, Map<String, int> iconSize) setOnMarkerTab(void Function(Marker marker, Map<String, int> iconSize) callBack){
    return callBack;
  }
}