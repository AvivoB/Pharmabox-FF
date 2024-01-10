import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_drop_down.dart';
import 'package:pharmabox/flutter_flow/form_field_controller.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../register_pharmacy/register_pharmacie_provider.dart';

class PredictionVille extends StatefulWidget {
  PredictionVille({Key? key, required this.onPlaceSelected, this.initialPostCode, this.initialCity}) : super(key: key);

  final Function(dynamic) onPlaceSelected;
  String? initialPostCode;
  String? initialCity;
  @override
  _PredictionVilleState createState() => _PredictionVilleState();
}

class _PredictionVilleState extends State<PredictionVille> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  List<dynamic> _predictions = [];
  final postcodeMask = MaskTextInputFormatter(mask: '#####');

  FormFieldController<String>? _countrieController;

  String? countrieValue;

  void _onSearchChanged(String query) async {
  if (query.isNotEmpty) {

    widget.onPlaceSelected({'city': query, 'country': 'France'});
    try {
      final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleMapsApi&language=fr'));
      final json = jsonDecode(response.body);

      if (json['status'] == 'OK') {
        setState(() {
          _predictions = json['predictions']
              .map((prediction) {
                List<String> predictionData = prediction['description'].split(', ');

                return {'city': predictionData[0], 'country': predictionData[1]};
              })
              .where((item) => item != null)
              .toList();
        });
      } else {
        setState(() {
          _predictions = [];
        });
      }
    } catch (e) {
      print("Erreur lors de la requête: $e");
      setState(() {
        _predictions = [];
      });
    }
  } else {
    setState(() {
      _predictions = [];
    });
  }
}


  void _onPredictionSelected(prediction) {

    print(prediction);

    if (prediction != null) {
      widget.onPlaceSelected(prediction);
      _cityController.text = prediction['city'].toString();
      if (_searchController.text != '') {
        _searchController.text = prediction['country'];
      }
    } else {
      widget.onPlaceSelected({'city': _cityController.text, 'country': 'France'});
    }

    setState(() {
      _predictions = [];
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialPostCode ?? '';
    _cityController.text = widget.initialCity ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        //   child: TextFormField(
        //     obscureText: false,
        //     controller: _searchController,
        //     onChanged: _onSearchChanged,
        //     decoration: InputDecoration(
        //       labelText: 'Code postal *',
        //       hintStyle: FlutterFlowTheme.of(context).bodySmall,
        //       enabledBorder: OutlineInputBorder(
        //         borderSide: BorderSide(
        //           color: Color(0xFFD0D1DE),
        //           width: 1,
        //         ),
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       focusedBorder: OutlineInputBorder(
        //         borderSide: BorderSide(
        //           color: FlutterFlowTheme.of(context).focusColor,
        //           width: 1,
        //         ),
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       errorBorder: OutlineInputBorder(
        //         borderSide: BorderSide(
        //           color: Color(0x00000000),
        //           width: 1,
        //         ),
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       focusedErrorBorder: OutlineInputBorder(
        //         borderSide: BorderSide(
        //           color: Color(0x00000000),
        //           width: 1,
        //         ),
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       prefixIcon: Icon(
        //         Icons.location_on,
        //         color: FlutterFlowTheme.of(context).secondaryText,
        //       ),
        //     ),
        //     style: FlutterFlowTheme.of(context).bodyMedium,
        //     keyboardType: TextInputType.number,
        //     // inputFormatters: [postcodeMask],
        //   ),
        // ),
        // if (_predictions.isNotEmpty && _predictions[0]['postal_code'] != '')
        //   Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Colors.grey),
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     child: ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: 1,
        //       itemBuilder: (context, index) {
        //         return ListTile(
        //           title: Row(
        //             children: [
        //               Icon(Icons.location_on_outlined),
        //               Text(_predictions[index]['postal_code'], style: FlutterFlowTheme.of(context).bodyMedium),
        //             ],
        //           ),
        //           onTap: () {
        //             _onPredictionSelected(_predictions[index]);
        //           },
        //         );
        //       },
        //     ),
        //   ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            obscureText: false,
            // readOnly: true,
            controller: _cityController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Ville *',
              hintText: 'Recherchez votre ville',
              hintStyle: FlutterFlowTheme.of(context).bodySmall,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFD0D1DE),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).focusColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              prefixIcon: Icon(
                Icons.location_city,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ),
        if (_predictions.isNotEmpty && _predictions[0]['city'] != '')
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.location_on_outlined),
                  title: Text(_predictions[index]['city'] + ', ' + _predictions[index]['country'], style: FlutterFlowTheme.of(context).bodyMedium, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    _onPredictionSelected(_predictions[index]);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
