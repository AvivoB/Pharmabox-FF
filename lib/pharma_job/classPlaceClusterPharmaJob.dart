import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import 'package:latlong2/latlong.dart' as latlong;

class Place with ClusterItem {
  final String name;
  final LatLng latLng;
  String groupement = '';
  int id = 0;
  Place(
      {required this.name,
      required this.latLng,
      this.groupement = '',
      this.id = 0});

  @override
  LatLng get location => latLng;
  String get groupementData => groupement;
  int get idPlace => id;
}
