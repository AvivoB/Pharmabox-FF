// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class ScrollableSheet extends StatefulWidget {
  const ScrollableSheet({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _ScrollableSheetState createState() => _ScrollableSheetState();
}

class _ScrollableSheetState extends State<ScrollableSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // En-tête du DraggableScrollableSheet
        Container(
          height: 50,
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'En-tête du DraggableScrollableSheet',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        // Contenu du DraggableScrollableSheet
        Expanded(
          child: DraggableScrollableSheet(
            initialChildSize: 0.15,
            minChildSize: 0.15,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 50,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Element $index'),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
