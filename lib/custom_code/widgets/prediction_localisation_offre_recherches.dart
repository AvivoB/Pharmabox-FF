import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../register_pharmacy/register_pharmacie_provider.dart';

class PredictionOffreRechercheLocalisation extends StatefulWidget {
  const PredictionOffreRechercheLocalisation({Key? key, required this.onPlaceSelected, this.initialValue = ''}) : super(key: key);

  final Function(String) onPlaceSelected;
  final String initialValue;
  @override
  _PredictionOffreRechercheLocalisationState createState() => _PredictionOffreRechercheLocalisationState();
}

class _PredictionOffreRechercheLocalisationState extends State<PredictionOffreRechercheLocalisation> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  late LatLng _center;
  late String _selectedAddress;
  late String _selectedPostalCode;
  late String _selectedCity;
  List<dynamic> _predictions = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialValue;
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=(regions)&key=$googleMapsApi'));
      final json = jsonDecode(response.body);

      if (json['status'] == 'OK') {
        setState(() {
          _predictions = json['predictions'];
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

  void _onPredictionSelected(String prediction) {
    setState(() {
      _searchController.text = prediction;
      _predictions = [];
    });
    if (widget.onPlaceSelected != null) {
      widget.onPlaceSelected(prediction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          obscureText: false,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            labelText: 'Localisation',
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
              Icons.place_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium,
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
                  title: Text(_predictions[index]['description'], style: FlutterFlowTheme.of(context).bodyMedium),
                  onTap: () {
                    _onPredictionSelected(_predictions[index]['description']);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
