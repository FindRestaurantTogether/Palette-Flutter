import 'package:flutter/material.dart';

class SecondSliderPage extends StatelessWidget {
  const SecondSliderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(image: AssetImage('assets/list_image/cute2.gif'), fit: BoxFit.fill),
    );
  }
}
