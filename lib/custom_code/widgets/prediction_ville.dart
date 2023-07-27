import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../register_pharmacy/register_pharmacie_provider.dart';

class PredictionVille extends StatefulWidget {
  PredictionVille({Key? key, required this.onPlaceSelected, this.initialValue})
      : super(key: key);

  final Function(dynamic) onPlaceSelected;
  String? initialValue;
  @override
  _PredictionVilleState createState() => _PredictionVilleState();
}

class _PredictionVilleState extends State<PredictionVille> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  Set<Marker> _markers = {};
  late LatLng _center;
  late String _selectedAddress;
  late String _selectedPostalCode;
  late String _selectedCity;
  List<dynamic> _predictions = [];
  final postcodeMask = MaskTextInputFormatter(mask: '#####');

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$query&region=fr&key=$googleMapsApi'));
      final json = jsonDecode(response.body);

      if (json['status'] == 'OK') {
        setState(() {
          // Extract city names and postal codes from addresses
          _predictions = json['results']
              .map((result) {
                final localityComponent = result['address_components']
                    .firstWhere(
                        (component) =>
                            component['types'].contains('locality') as bool,
                        orElse: () => null);

                final postalCodeComponent = result['address_components']
                    .firstWhere(
                        (component) =>
                            component['types'].contains('postal_code') as bool,
                        orElse: () => null);

                if (localityComponent != null && postalCodeComponent != null) {
                  return {
                    'city': localityComponent['long_name'],
                    'postal_code': postalCodeComponent['long_name']
                  };
                }
                return null;
              })
              .where((item) => item != null)
              .toList();
        });
      } else {
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
    setState(() {
      _searchController.text = prediction['postal_code'];
      _predictions = [];
    });
    if (widget.onPlaceSelected != null) {
      widget.onPlaceSelected(prediction);
      _cityController.text = prediction['city'];
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: TextFormField(
            obscureText: false,
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Code postal *',
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
                Icons.location_on,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium,
            keyboardType: TextInputType.number,
            inputFormatters: [postcodeMask],
          ),
        ),
        if (_predictions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      _predictions[index]['postal_code'] +
                          ', ' +
                          _predictions[index]['city'],
                      style: FlutterFlowTheme.of(context).bodyMedium),
                  onTap: () {
                    _onPredictionSelected(_predictions[index]);
                  },
                );
              },
            ),
          ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: TextFormField(
            obscureText: false,
            readOnly: true,
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Ville *',
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
      ],
    );
  }
}
