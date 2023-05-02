// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the button on the right!
class CustomTable extends StatefulWidget {
  List<Horaire> horraires;
  CustomTable({Key? key, required this.horraires}) : super(key: key);

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final List<String> week = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            10,
          ),
          topRight: Radius.circular(
            10,
          ),
        ),
      ),
      children: [
        const TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xfF161730),
              ),
            ),
            color: Color.fromRGBO(239, 246, 247, 1),
          ),
          children: [
            CustomTabletext(
              text: '',
              textStyle: TextStyle(),
            ),
            CustomTabletext(
              text: "Matinée",
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfF161730),
              ),
            ),
            CustomTabletext(
              text: "Après-midi",
              textStyle: TextStyle(
                color: Color(0xfF161730),
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTabletext(
              text: "Soirée",
              textStyle: TextStyle(
                color: Color(0xfF161730),
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTabletext(
              text: "Nuit",
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfF161730),
              ),
            ),
          ],
        ),
        ...List.generate(
          7,
          (index) => TableRow(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(231, 237, 238, 1),
                ),
              ),
            ),
            children: [
              CustomTabletext(
                text: week[index],
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xfF161730),
                ),
              ),
              CustomCheckBox(
                  icon: widget.horraires[index].matinee,
                  onClick: () {
                    if (widget.horraires[index].matinee.isEmpty) {
                      widget.horraires[index].matinee = 'check';
                    } else if (widget.horraires[index].matinee == 'check') {
                      widget.horraires[index].matinee = 'cross';
                    } else {
                      widget.horraires[index].matinee = '';
                    }
                    setState(() {});
                  }),
              CustomCheckBox(
                  icon: widget.horraires[index].apresMidi,
                  onClick: () {
                    if (widget.horraires[index].apresMidi.isEmpty) {
                      widget.horraires[index].apresMidi = 'check';
                    } else if (widget.horraires[index].apresMidi == 'check') {
                      widget.horraires[index].apresMidi = 'cross';
                    } else {
                      widget.horraires[index].apresMidi = '';
                    }
                    setState(() {});
                  }),
              CustomCheckBox(
                  icon: widget.horraires[index].soiree,
                  onClick: () {
                    if (widget.horraires[index].soiree.isEmpty) {
                      widget.horraires[index].soiree = 'check';
                    } else if (widget.horraires[index].soiree == 'check') {
                      widget.horraires[index].soiree = 'cross';
                    } else {
                      widget.horraires[index].soiree = '';
                    }
                    setState(() {});
                  }),
              CustomCheckBox(
                icon: widget.horraires[index].nuit,
                onClick: () {
                  if (widget.horraires[index].nuit.isEmpty) {
                    widget.horraires[index].nuit = 'check';
                  } else if (widget.horraires[index].nuit == 'check') {
                    widget.horraires[index].nuit = 'cross';
                  } else {
                    widget.horraires[index].nuit = '';
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  String icon;
  VoidCallback onClick;
  CustomCheckBox({Key? key, required this.icon, required this.onClick});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        top: 5,
        right: 30,
      ),
      child: GestureDetector(
        onTap: widget.onClick,
        child: Container(
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.icon == 'check'
                ? const Color.fromRGBO(124, 237, 172, 1)
                : widget.icon == 'cross'
                    ? const Color.fromRGBO(248, 153, 153, 1)
                    : const Color.fromRGBO(253, 197, 113, 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: widget.icon == 'check'
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : widget.icon == 'cross'
                  ? const Icon(
                      Icons.close,
                      color: Colors.white,
                    )
                  : const Icon(
                      null,
                    ),
        ),
      ),
    );
  }
}

class CustomTabletext extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  const CustomTabletext(
      {Key? key, required this.text, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 4,
        right: 2,
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}

class Horaire {
  String matinee;
  String apresMidi;
  String soiree;
  String nuit;
  Horaire({
    required this.matinee,
    required this.apresMidi,
    required this.soiree,
    required this.nuit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matinee': matinee,
      'apresMidi': apresMidi,
      'soiree': soiree,
      'nuit': nuit,
    };
  }

  factory Horaire.fromMap(Map<String, dynamic> map) {
    return Horaire(
      matinee: map['matinee'] as String,
      apresMidi: map['apresMidi'] as String,
      soiree: map['soiree'] as String,
      nuit: map['nuit'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Horaire.fromJson(String source) =>
      Horaire.fromMap(json.decode(source) as Map<String, dynamic>);
}
