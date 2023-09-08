import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';

class ProgressIndicatorPharmabox extends StatelessWidget {
  const ProgressIndicatorPharmabox({Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/icons/logo-pharma-box.png', width: 100, height: 100),
        SizedBox(width: 10, height: 20),
        CircularProgressIndicator(color: blueColor),
      ],
    ));
  }
}
