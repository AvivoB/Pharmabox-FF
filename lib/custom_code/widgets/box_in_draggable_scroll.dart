import 'package:flutter/material.dart';

class BoxDraggableSheet extends StatefulWidget {
  BoxDraggableSheet({Key? key, this.type = '', this.nbResultats = 0, this.componentWidget})
      : super(key: key);

  final String type;
  final int nbResultats;
  final componentWidget;

  @override
  _BoxDraggableSheetState createState() => _BoxDraggableSheetState();
}

class _BoxDraggableSheetState extends State<BoxDraggableSheet> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              
              width: MediaQuery.of(context).size.width * 1.0,
              height: 67,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFF2FDFF),
                boxShadow: [BoxShadow(color: Color(0x2b1e5b67),
                                      blurRadius: 12,
                                      offset: Offset(10, 10)
                                    )
                          ]
              ),
              child: Row(
                children: [
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  Text(
                    widget.type + ' (${widget.nbResultats.toString()})',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isExpanded) widget.componentWidget ?? Container(),
      ],
    );
  }
}
