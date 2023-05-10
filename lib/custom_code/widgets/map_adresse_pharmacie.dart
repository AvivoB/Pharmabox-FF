import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class MapAdressePharmacie extends StatefulWidget {
  const MapAdressePharmacie({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          obscureText: false,
          onTap: _searchAddress,
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
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15))),
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

  Future<void> _searchAddress() async {
    // Clear previous markers
    _markers.clear();

    // Get predictions for the search query
    List<Location> locations =
        await locationFromAddress(_searchController.text);
 
    // If there are no predictions, display an error message
    if (locations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No address found')),
      );
      return;
    }

    // Get the first prediction
    Location location = locations.first;

    // Set the camera position to the selected location
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 16,
      ),
    ));

    // Add a marker for the selected location
    _markers.add(Marker(
      markerId: MarkerId('selected-location'),
      position: LatLng(location.latitude, location.longitude),
    ));

    // // Set the selected address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark placemark = placemarks.first;
    setState(() {
      _selectedAddress = placemark.street ?? '';
      _selectedPostalCode = placemark.postalCode ?? '';
      _selectedCity = placemark.locality ?? '';
    });

    // Update the text field
    _searchController.text = _selectedAddress;

    // Display a message with the selected address
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected address: $_selectedAddress')),
    );
  }
}
