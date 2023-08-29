import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'maps_widget_adresse_pharmacie_model.dart';
export 'maps_widget_adresse_pharmacie_model.dart';

class MapsWidgetAdressePharmacieWidget extends StatefulWidget {
  const MapsWidgetAdressePharmacieWidget({Key? key}) : super(key: key);

  @override
  _MapsWidgetAdressePharmacieWidgetState createState() => _MapsWidgetAdressePharmacieWidgetState();
}

class _MapsWidgetAdressePharmacieWidgetState extends State<MapsWidgetAdressePharmacieWidget> {
  late MapsWidgetAdressePharmacieModel _model;

  LatLng? currentUserLocationValue;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapsWidgetAdressePharmacieModel());

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true).then((loc) => setState(() => currentUserLocationValue = loc));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).accent3,
            ),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: FlutterFlowGoogleMap(
        controller: _model.googleMapsController,
        onCameraIdle: (latLng) => setState(() => _model.googleMapsCenter = latLng),
        initialLocation: _model.googleMapsCenter ??= currentUserLocationValue!,
        markerColor: GoogleMarkerColor.red,
        mapType: MapType.normal,
        style: GoogleMapStyle.standard,
        initialZoom: 18.0,
        allowInteraction: false,
        allowZoom: true,
        showZoomControls: true,
        showLocation: true,
        showCompass: false,
        showMapToolbar: false,
        showTraffic: false,
        centerMapOnMarkerTap: true,
      ),
    );
  }
}
