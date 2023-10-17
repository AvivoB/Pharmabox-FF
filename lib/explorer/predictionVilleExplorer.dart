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

class PredictionExplorer extends StatefulWidget {
  PredictionExplorer({Key? key, required this.onPlaceSelected, this.query = ''}) : super(key: key);

  final Function(dynamic) onPlaceSelected;
  String query;
  @override
  _PredictionExplorerState createState() => _PredictionExplorerState();
}

class _PredictionExplorerState extends State<PredictionExplorer> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  List<dynamic> _predictions = [];
  final postcodeMask = MaskTextInputFormatter(mask: '#####');

  FormFieldController<String>? _countrieController;

  String? countrieValue;

  void _search(String query) async {
    print('predictionnn' + query.toString());
    if (query != null) {
      try {
        final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$googleMapsApi&language=fr'));
        final json = jsonDecode(response.body);

        if (json['status'] == 'OK') {
          setState(() {
            _predictions = json['results']
                .map((result) {
                  String city = '';
                  String postalCode = '';
                  String country = '';

                  for (var component in result['address_components']) {
                    if (component['types'].contains('locality')) {
                      city = component['long_name'];
                    }
                    if (component['types'].contains('postal_code')) {
                      postalCode = component['long_name'];
                    }
                    if (component['types'].contains('country')) {
                      country = component['long_name'];
                    }
                  }

                  print(city);
                  print(postalCode);
                  print(country);

                  return {'city': city, 'postal_code': postalCode, 'country': country};
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
    setState(() {
      _predictions = [];
    });
    if (widget.onPlaceSelected != null) {
      widget.onPlaceSelected(prediction);
      _cityController.text = prediction['city'];
      if (_searchController.text != '') {
        _searchController.text = prediction['postal_code'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _search(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_predictions.isNotEmpty && _predictions[0]['city'] != '')
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text(_predictions[index]['city'] + ', ' + _predictions[index]['country'], style: FlutterFlowTheme.of(context).bodyMedium),
                    ],
                  ),
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
