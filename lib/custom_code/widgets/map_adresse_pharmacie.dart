import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../register_pharmacy/register_pharmacie_provider.dart';

class MapAdressePharmacie extends StatefulWidget {
  MapAdressePharmacie({Key? key, required this.onAdressSelected, this.onInitialValue, this.isEditable = true, this.countryCode = 'fr'}) : super(key: key);

  final Function(double, double, String, String, String, String, String, String) onAdressSelected;
  final String? onInitialValue;
  final bool isEditable;
  String countryCode;
  @override
  _MapAdressePharmacieState createState() => _MapAdressePharmacieState();
}

class _MapAdressePharmacieState extends State<MapAdressePharmacie> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  late LatLng _center;
  late String _selectedAddress;
  late String _selectedPostalCode;
  late String _selectedCity;
  List<dynamic> _predictions = [];

  String _countryCode = '';

  @override
  void initState() {
    super.initState(); // Don't forget to call super.initState()
    _searchAddress(widget.onInitialValue ?? '');
    _searchController.text = widget.onInitialValue ?? '';
    // _countryCode = widget.countryCode;
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&components=country:' + widget.countryCode + '&key=$googleMapsApi&language=fr'));
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
      _searchAddress(prediction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isEditable)
          TextFormField(
            controller: _searchController,
            obscureText: false,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Adresse',
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
        if (widget.isEditable == false)
          Container(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                Icons.place_outlined,
                color: greyColor,
                size: 28.0,
              ),
              SizedBox(width: 10),
              Flexible(child: Text(widget.onInitialValue.toString(), style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)))
            ]),
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
                  title: Row(
                    children: [
                      Icon(Icons.place_outlined),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(_predictions[index]['description'], style: FlutterFlowTheme.of(context).bodyMedium.override(fontSize: 12.0, fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                  onTap: () {
                    _onPredictionSelected(_predictions[index]['description']);
                  },
                );
              },
            ),
          ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
          height: 150,
          child: GoogleMap(
            scrollGesturesEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(48.8534, 2.3488), // Paris
              zoom: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _searchAddress(selectedAdress) async {
    // Clear previous markers
    _markers.clear();

    // Get predictions for the search query
    List<Location> locations = await locationFromAddress(selectedAdress);

    // Get the first prediction
    Location location = locations.first;

    final aDreplacemark = await placemarkFromCoordinates(location.latitude, location.longitude);

    widget.onAdressSelected(location.latitude, location.longitude, aDreplacemark.first.street.toString(), aDreplacemark.first.postalCode.toString(), aDreplacemark.first.locality.toString(), aDreplacemark.first.subLocality.toString() ?? '', aDreplacemark.first.administrativeArea.toString() ?? '', aDreplacemark.first.country.toString() ?? '');

    // Set the camera position to the selected location
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 16,
      ),
    ));

    final providerPharmacieRegister = Provider.of<ProviderPharmacieRegister>(context, listen: false);

    providerPharmacieRegister.setPharmacieLocation(location.latitude, location.longitude);

    // Add a marker for the selected location
    _markers.add(Marker(
      markerId: MarkerId('selected-location'),
      position: LatLng(location.latitude, location.longitude),
    ));

    // // Set the selected address
    List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark placemark = placemarks.first;
    setState(() {
      _selectedAddress = placemark.street ?? '';
      _selectedPostalCode = placemark.postalCode ?? '';
      _selectedCity = placemark.locality ?? '';
    });
  }
}
