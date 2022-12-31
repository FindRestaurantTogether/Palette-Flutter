import 'package:flutter/material.dart';

class FirstSliderPage extends StatelessWidget {
  const FirstSliderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(image: AssetImage('assets/list_image/cute1.gif'), fit: BoxFit.fill),
    );
  }
}
