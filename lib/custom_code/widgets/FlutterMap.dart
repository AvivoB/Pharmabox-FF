import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';

class MyMapWidget extends StatefulWidget {
  MyMapWidget({Key? key, required this.pharmacies, this.currentPosition = const LatLng(0, 0), this.onMarkerTap, this.mapController, this.initialZoom = 10.0}) : super(key: key);

  final List pharmacies;
  final LatLng currentPosition;
  Function(String)? onMarkerTap;
  final MapController? mapController;
  final double initialZoom;

  @override
  _MyMapWidgetState createState() => _MyMapWidgetState();
}

class _MyMapWidgetState extends State<MyMapWidget> {
  List<Marker> markers = []; // Initialiser avec une liste vide
  LatLng _currentPosition = LatLng(48.866667, 2.333333);

  @override
  void initState() {
    super.initState();
    // markers.addAll(); // Ajoutez vos marqueurs à l'état

    Set<String> markerIds = Set<String>();

          print('PharmaID : ' + widget.pharmacies.asMap().toString());

    widget.pharmacies.asMap().forEach((index, element) {
      String markerId = widget.pharmacies[index]['documentId'].toString();


      
      // Vérifie si l'ID du marqueur existe déjà dans l'ensemble des IDs
      if (!markerIds.contains(markerId)) {
        markerIds.add(markerId); // Ajoute l'ID du marqueur à l'ensemble des IDs
        markers.add(
          Marker(
            width: 100,
            height: 100,
            key: Key(markerId),
            point: LatLng(
              widget.pharmacies[index]['situation_geographique']['lat_lng'][0].toDouble(),
              widget.pharmacies[index]['situation_geographique']['lat_lng'][1].toDouble(),
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    border: Border.all(
                      color: greenColor,
                      width: 2,
                    ),
                  ),
                  child: Image.asset('assets/groupements/' + widget.pharmacies[index]['groupement'][0]['image']),
                ),
                Text(
                  widget.pharmacies[index]['situation_geographique']['adresse'].toString(),
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 9.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,

                )
              ],
            ),
          ),
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          initialCenter: widget.currentPosition, // Centre sur Londres (latitude, longitude)
          initialZoom: widget.initialZoom, // Zoom initial
        ),
        children: <Widget>[
          TileLayer(
            urlTemplate: "https://api.mapbox.com/styles/v1/pharmaboxdb/clvp81ywq01nc01qvab5ucl8e/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicGhhcm1hYm94ZGIiLCJhIjoiY2x2cDd6bDFtMDJkODJscjFrYnBnc3pwaSJ9.HGzdTcllcS7pG0a7At6wzg",
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              onMarkerTap: (marker) {
                String id = (marker.key as ValueKey<String>).value;
                widget.onMarkerTap!(id);
              },
              onClusterTap: (marker) => {},
              maxClusterRadius: 45,
              size: const Size(40, 40),
              markers: markers,
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color.fromARGB(255, 39, 61, 187)),
                  child: Center(
                    child: Text(markers.length.toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 16,
                            )),
                  ),
                );
              },
            ),
          ),
        ]);
  }
}
