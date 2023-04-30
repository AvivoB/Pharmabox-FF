// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_google_places/flutter_google_places.dart' as fp;
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;

class WidgetSelectedAdressPharmacie extends StatefulWidget {
  WidgetSelectedAdressPharmacie(
      {Key? key, this.width, this.height, this.addressController})
      : super(key: key);
  final TextEditingController? addressController;
  final double? width;
  final double? height;

  @override
  State<WidgetSelectedAdressPharmacie> createState() =>
      _WidgetSelectedAdressPharmacieState();
}

class _WidgetSelectedAdressPharmacieState
    extends State<WidgetSelectedAdressPharmacie>
    with SingleTickerProviderStateMixin {
  // camera animation
  late AnimationController controller;
  maps.GoogleMapController? mapController;
  late maps.Marker marker;
  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    marker = maps.Marker(
      markerId: const maps.MarkerId("localisation"),
      position: maps.LatLng(local.lat, local.lng),
    );
  }

  ////get location frm the address
  Future<places.LatLng> getLocationFromAddress(String address) async {
    List<geo.Location> locations = await geo.locationFromAddress(address);
    geo.Location location = locations.first;
    return places.LatLng(lat: location.latitude, lng: location.longitude);
  }

  places.LatLng local = const places.LatLng(lat: 44, lng: 44);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.addressController,
          onChanged: (String val) async {
            try {
              Prediction? p = await fp.PlacesAutocomplete.show(
                context: context,
                apiKey: 'AIzaSyA_cdEvBvs-uWSOpXmBC7SzdVnTTmOZJns',
                radius: 10000000,
                types: [],
                strictbounds: false,
                mode: fp.Mode.fullscreen,
                language: "fr",
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Localisation',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                components: [Component(Component.country, "fr")],
              );
              if (p != null) {
                widget.addressController.text = p.description!;

                local = await getLocationFromAddress(p.description!);
                controller.forward().then((_) {
                  mapController!.animateCamera(maps.CameraUpdate.newLatLng(
                      maps.LatLng(local.lat, local.lng)));
                  setState(() {
                    marker = marker.copyWith(
                      positionParam: maps.LatLng(local.lat, local.lng),
                    );
                  });
                });
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        ),
        Container(
          child: maps.GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              compassEnabled: true,
              zoomControlsEnabled: false,
              mapType: maps.MapType.normal,
              markers: {
                maps.Marker(
                  markerId: const maps.MarkerId("localisation"),
                  position: maps.LatLng(local.lat, local.lng),
                ),
              },
              initialCameraPosition: maps.CameraPosition(
                target: maps.LatLng(local.lat, local.lng),
                zoom: 12.0,
              )),
        ),
      ],
    );
  }
}
