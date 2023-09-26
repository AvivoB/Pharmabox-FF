import 'package:flutter/material.dart';

class PharmaboxLogo extends StatelessWidget {
  final double width;

  PharmaboxLogo({Key? key, this.width = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          'assets/icons/logo-pharma-box.png',
          width: width,
        ),
      ),
    );
  }
}
