import 'package:flutter/material.dart';

class FourthSliderPage extends StatelessWidget {
  const FourthSliderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(image: AssetImage('assets/list_image/cute4.gif'), fit: BoxFit.fill),
    );
  }
}
