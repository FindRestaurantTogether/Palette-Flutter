import 'package:flutter/material.dart';

class ThirdSliderPage extends StatelessWidget {
  const ThirdSliderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(image: AssetImage('assets/list_image/cute3.gif'), fit: BoxFit.fill),
    );
  }
}
