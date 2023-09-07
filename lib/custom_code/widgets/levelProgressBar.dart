import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class LevelProgressBar extends StatelessWidget {
  final int level;
  final bool isUser;

  LevelProgressBar({required this.level, this.isUser = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
        child: Column(
          children: [
            if (isUser)
              Text(
                level == 0
                    ? 'Maîtrise basique'
                    : level == 1
                        ? 'Maîtrise moyenne'
                        : 'Maîtrise complète',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF595A71),
                    ),
              ),
            Slider(
                value: level.toDouble(),
                min: 0,
                max: 2,
                // divisions: 2,
                onChanged: (double value) {},
                activeColor: level == 0
                    ? redColor
                    : level == 1
                        ? yellowColor
                        : greenColor),
          ],
        ));
  }
}
