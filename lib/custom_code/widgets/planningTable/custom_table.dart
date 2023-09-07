import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';

class GrilleHoraire extends StatefulWidget {
  final Function(List) onSelectionChanged;
  List onInitialValue;
  final bool isEditable;

  GrilleHoraire({Key? key, required this.onSelectionChanged, this.onInitialValue = const [], this.isEditable = true}) : super(key: key);

  @override
  _GrilleHoraireState createState() => _GrilleHoraireState();
}

class _GrilleHoraireState extends State<GrilleHoraire> {
  List<String> daysOfWeek = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  List<String> periods = ['Matinée', 'Après-midi', 'Soirée', 'Nuit'];
  List selectedOptions = [];

  List transformInitialValue(List initialValue) {
    return initialValue.map((e) => e['semaine']!).toList();
  }

  @override
  void initState() {
    super.initState();

    // ignore: unrelated_type_equality_checks
    selectedOptions = widget.onInitialValue.isNotEmpty ? transformInitialValue(widget.onInitialValue) : List.generate(daysOfWeek.length, (_) => List.generate(periods.length, (_) => 'Obligatoire'));
    print('GRILLE VALUE : ' + selectedOptions.toString());
  }

  void _toggleOption(int row, int col) {
    if (!widget.isEditable) return;
    print(widget.isEditable);

    String currentOption = selectedOptions[row][col];
    String newOption = '';

    if (currentOption == 'Obligatoire') {
      newOption = 'Non souhaité';
    } else if (currentOption == 'Non souhaité') {
      newOption = 'Négociable';
    } else if (currentOption == 'Négociable') {
      newOption = 'Obligatoire';
    }

    setState(() {
      selectedOptions[row][col] = newOption;
    });

    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged(selectedOptions);
    }
  }

  IconData _getIcon(String option) {
    if (option == 'Obligatoire') {
      return Icons.check;
    } else if (option == 'Non souhaité') {
      return Icons.close;
    } else if (option == 'Négociable') {
      return Icons.question_mark_rounded;
    }
    return Icons.check;
  }

  Color _getBackgroundColor(String option) {
    if (option == 'Obligatoire') {
      return greenColor;
    } else if (option == 'Non souhaité') {
      return redColor;
    } else if (option == 'Négociable') {
      return yellowColor;
    }
    return greenColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Table(
        border: TableBorder(horizontalInside: BorderSide(width: 2, color: greyLightColor, style: BorderStyle.solid)),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Color(0xFFEFF6F7),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            children: [
              TableCell(
                child: Container(),
              ),
              for (var period in periods)
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      period,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: greyColor, fontSize: 9.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          for (var i = 0; i < daysOfWeek.length; i++)
            TableRow(
              children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container(
                      child: Text(
                        daysOfWeek[i],
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: greyColor,
                              fontSize: 12.0,
                            ),
                      ),
                    )),
                for (var j = 0; j < periods.length; j++)
                  TableCell(
                    child: GestureDetector(
                      onTap: () => _toggleOption(i, j),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getBackgroundColor(selectedOptions[i][j]),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.all(6.0),
                        margin: EdgeInsets.all(4.0),
                        child: Icon(
                          _getIcon(selectedOptions[i][j]),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
