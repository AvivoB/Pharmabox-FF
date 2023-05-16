import 'package:flutter/material.dart';
import 'package:pharmabox/composants/card_pharmacie/card_pharmacie_widget.dart';

import '../../composants/card_pharmacie_offre_recherche/card_pharmacie_offre_recherche_widget.dart';
import '../../composants/card_user/card_user_widget.dart';

class BoxDraggableSheet extends StatefulWidget {
  BoxDraggableSheet(
      {Key? key, this.type = '', required this.nbResultats, this.data})
      : super(key: key);

  final String type;
  List nbResultats = [];
  final data;


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
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x2b1e5b67),
                        blurRadius: 12,
                        offset: Offset(10, 10))
                  ]),
              child: Row(
                children: [
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  Text(
                    widget.type + ' (${widget.nbResultats.length.toString()})',
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
        if (isExpanded && widget.type == 'Pharmacies')
          for (var i in widget.nbResultats) CardPharmacieWidget(data: widget.data, dataKey: widget.nbResultats.indexOf(i),),
        if (isExpanded && widget.type == 'Membres')
          for (var i in widget.nbResultats) CardUserWidget(),
        if (isExpanded && widget.type == 'Jobs')
          for (var i in widget.nbResultats) CardPharmacieOffreRechercheWidget(),
      ],
    );
  }
}
