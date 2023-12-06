import 'package:flutter/material.dart';

class DesactivatedAccount extends StatelessWidget {
  const DesactivatedAccount({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Votre compte Pharmabox a été désactivé'),
        ),
      ),
    );
  }
}