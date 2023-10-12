import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';

import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/form_field_controller.dart';

class HorraireSemaineSelect extends StatefulWidget {
  const HorraireSemaineSelect({Key? key, required this.callback, this.initialHours, this.isEditable = true});
  final Function(dynamic) callback;
  final dynamic initialHours;
  final bool isEditable;

  @override
  State<HorraireSemaineSelect> createState() => _HorraireSemaineSelectState();
}

class _HorraireSemaineSelectState extends State<HorraireSemaineSelect> {
  Map _selectedHour = {
    'Lundi': ['00:00', '00:00', true],
    'Mardi': ['00:00', '00:00', true],
    'Mercredi': ['00:00', '00:00', true],
    'Jeudi': ['00:00', '00:00', true],
    'Vendredi': ['00:00', '00:00', true],
    'Samedi': ['00:00', '00:00', true],
    'Dimanche': ['00:00', '00:00', true],
  };
  List<String> orderedDays = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];

  List<String> _hours = List<String>.generate(24 * 2, (int index) {
    int hour = index ~/ 2;
    int minute = (index % 2) * 30;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  });

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHours != null ? widget.initialHours : LinkedHashMap.fromIterable(orderedDays, key: (k) => k, value: (v) => _selectedHour[v]);

    print('SELECT EHRUES' + _selectedHour.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 350,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _selectedHour.keys.length,
        itemBuilder: (context, index) {
          String day = _selectedHour.keys.elementAt(index);
          return Row(
            mainAxisAlignment: widget.isEditable ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(day, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12.0, fontWeight: FontWeight.w500)),
                  ),
                ),
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFEFF6F7),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  // borderRadius: BorderRadius.circular(4),
                  // border: Border.all(
                  //   color: Color(0xFFD0D1DE),
                  // ),
                ),
                child: _selectedHour[day]![2]
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: widget.isEditable ? MainAxisAlignment.spaceAround : MainAxisAlignment.spaceBetween,
                        children: [
                          Text(' de ', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                          if (widget.isEditable == false) Text(_selectedHour[day]![0].toString(), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                          if (widget.isEditable)
                            DropdownButton<String>(
                              isDense: true,
                              menuMaxHeight: 350,
                              value: _selectedHour[day]![0],
                              items: _hours.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedHour[day]![0] = newValue!;
                                  if (day == 'Lundi') {
                                    _selectedHour.forEach((key, value) {
                                      _selectedHour[key]![0] = newValue;
                                    });
                                  }
                                });
                                widget.callback(_selectedHour);
                              },
                            ),
                          Text(' à ', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                          if (widget.isEditable == false) Text(_selectedHour[day]![1].toString(), style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                          if (widget.isEditable)
                            DropdownButton<String>(
                              isDense: true,
                              menuMaxHeight: 350,
                              value: _selectedHour[day]![1],
                              items: _hours.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedHour[day]![1] = newValue!;
                                  if (day == 'Lundi') {
                                    _selectedHour.forEach((key, value) {
                                      _selectedHour[key]![1] = newValue;
                                    });
                                  }
                                });
                                widget.callback(_selectedHour);
                              },
                            ),
                        ],
                      )
                    : Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Fermé',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: redColor),
                          ),
                        ),
                        height: 50,
                      ),
              ),
              if (widget.isEditable)
                Container(
                  child: Switch.adaptive(
                    value: _selectedHour[day]![2] ?? false,
                    onChanged: (newValue) async {
                      setState(() => _selectedHour[day]![2] = newValue);
                    },
                    activeColor: Color(0xFF7CEDAC),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
