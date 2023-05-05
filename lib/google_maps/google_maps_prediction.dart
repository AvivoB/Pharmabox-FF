import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pharmabox/constant.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class GoogleMapsPredictions extends StatefulWidget {
  const GoogleMapsPredictions(
      {Key? key,
      required this.controller,
      this.icon,
      this.label,
      this.readonly = false})
      : super(key: key);

  final TextEditingController? controller;
  final Icon? icon;
  final String? label;
  final bool readonly;

  @override
  _GoogleMapsPredictionsState createState() => _GoogleMapsPredictionsState();
}

class _GoogleMapsPredictionsState extends State<GoogleMapsPredictions> {
  List<dynamic> _predictions = [];

  void _onTextChanged(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$googleMapsApi';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    setState(() {
      _predictions = json['results']
      .where((element) =>
          element['types'].toString().toLowerCase().contains('locality'))
      .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            TextFormField(
          controller: widget.controller,
          obscureText: false,
          readOnly: widget.readonly,
          onChanged: _onTextChanged,
          decoration: InputDecoration(
              labelText: widget.label,
              hintStyle: FlutterFlowTheme.of(context).bodySmall,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFD0D1DE),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).focusColor,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x00000000),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x00000000),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              prefixIcon: widget.icon),
        ),
        if (_predictions.isNotEmpty)
          DropdownButtonFormField(
            items: _predictions
                .map(
                  (prediction) => DropdownMenuItem(
                    value: prediction,
                    child: Text(prediction),
                  ),
                )
                .toList(),
            onChanged: (value) {
              // setState(() {
              //   _textEditingController.text = value.toString();
              //   _predictions = [];
              // });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ],
        )        
      ],
    );
  }
}


// Container(
//           child: ListView.builder(
//             itemCount: _predictions.length,
//             itemBuilder: (context, index) {
              
//             },
//             ),
//         )