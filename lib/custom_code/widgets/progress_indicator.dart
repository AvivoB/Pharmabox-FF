import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';

class ProgressIndicatorPharmabox extends StatelessWidget {
  const ProgressIndicatorPharmabox({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Arrière-plan blanc
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PharmaboxLogo(width: 100),
            SizedBox(width: 10, height: 20),
            CircularProgressIndicator(color: blueColor),
          ],
        ),
      ),
    );
  }
}
