import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/explorer/classPlaceCluster.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExplorerModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // Model for HeaderApp component.
  late HeaderAppModel headerAppModel;
  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    headerAppModel = createModel(context, () => HeaderAppModel());
  }

  void dispose() {
    headerAppModel.dispose();
    textController?.dispose();
  }

  List<Place> _explorerData = [];

  List<Place> get explorerData => _explorerData;

  // Search pharmacie, jobs and memeber in explorer
  getPharmaciesLocations({searchTerm}) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pharmacies').get();

    // Boucle à travers les documents
    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Récupération du nom de la pharmacie
      String name = data['situation_geographique']['adresse'];

      List location = data['situation_geographique']['lat_lng'];

      // Création d'un objet Place
      Place place = Place(name: name, latLng: LatLng(location[0], location[1]));

      // Ajout de l'objet Place à la liste des places
      _explorerData.add(place);
    }
  }
}
