import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pharmabox/constant.dart';

import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/form_field_controller.dart';

class HorraireSemaineSelect extends StatefulWidget {
  const HorraireSemaineSelect(
      {Key? key, required this.callback, this.initialHours});
  final Function(dynamic) callback;
  final dynamic initialHours;

  @override
  State<HorraireSemaineSelect> createState() => _HorraireSemaineSelectState();
}

class _HorraireSemaineSelectState extends State<HorraireSemaineSelect> {
  dynamic _selectedHour = {
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
     if (widget.initialHours != null) {
      _selectedHour = widget.initialHours!;
      _selectedHour = LinkedHashMap.fromIterable(orderedDays,
          key: (k) => k, value: (v) => _selectedHour[v]);
      print(_selectedHour);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 350,
      child: ListView.builder(
        itemCount: _selectedHour.keys.length,
        itemBuilder: (context, index) {
          String day = _selectedHour.keys.elementAt(index);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(day),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(' de '),
                          DropdownButton<String>(
                            isDense: true,
                            menuMaxHeight: 350,
                            value: _selectedHour[day]![0],
                            items: _hours
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                          Text(' à '),
                          DropdownButton<String>(
                            isDense: true,
                            menuMaxHeight: 350,
                            value: _selectedHour[day]![1],
                            items: _hours
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: redColor),
                          ),
                        ),
                        height: 50,
                      ),
              ),
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
