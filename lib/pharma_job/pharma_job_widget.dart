import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_pharmacie_offre_recherche/card_pharmacie_offre_recherche_widget.dart';
import '../custom_code/widgets/box_in_draggable_scroll.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../popups/popup_offre/popup_offre_widget.dart';
import '../popups/popup_recherche/popup_recherche_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pharma_job_model.dart';
export 'pharma_job_model.dart';
import 'classPlaceClusterPharmaJob.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PharmaJobWidget extends StatefulWidget {
  const PharmaJobWidget({Key? key}) : super(key: key);

  @override
  _PharmaJobWidgetState createState() => _PharmaJobWidgetState();
}

class _PharmaJobWidgetState extends State<PharmaJobWidget> {
  late PharmaJobModel _model;
  bool isTitulaire = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ClusterManager _manager;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  String? searchTerms;

  final CameraPosition _parisCameraPosition =
      CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 16.0);

  List<Place> items = [];
  List pharmacieInPlace = [];
  List offres = [];

  Future<void> getPharmaciesLocations({searchTerm}) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pharmacies').get();

    // Boucle à travers les documents
    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String documentId = doc.reference.id.toString();

      data['documentId'] = documentId;

      // Récupération du nom de la pharmacie
      String name = data['situation_geographique']['adresse'];

      List location = data['situation_geographique']['lat_lng'];

      // Création d'un objet Place
      Place place = Place(name: name, latLng: LatLng(location[0], location[1]));

      // Ajout de l'objet Place à la liste des places
      setState(() {
        items.add(place);
        pharmacieInPlace.add(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PharmaJobModel());
    _model.searchJobController ??= TextEditingController();
    _model.searchJobController ??= TextEditingController();
    _manager = _initClusterManager();
    getPharmaciesLocations();
    checkTitulaireStatus();
    getOffres();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void checkTitulaireStatus() {
    checkIsTitulaire().then((isTitulaire) {
      setState(() {
        this.isTitulaire = isTitulaire;
      });
    });
  }

void getOffres() async {
    offres.clear();
    String pharmacieId = await getPharmacyByUserId();

    final Query query = FirebaseFirestore.instance
            .collection('offres')
            .where('pharmacie_id', isEqualTo: pharmacieId);

    final QuerySnapshot querySnapshot = await query.get();

    querySnapshot.docs.forEach((doc) {
      offres.add(doc.data());
      print(doc.data());
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.headerAppModel,
              updateCallback: () => setState(() {}),
              child: HeaderAppWidget(),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: /* Stack(
                  children: [
                     TextFormField(
                        controller: _model.searchJobController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                          contentPadding: EdgeInsets.all(15.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD0D1DE),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(48.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD0D1DE),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 24.0,
                            color: Color(0xFFD0D1DE),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator:
                            _model.searchJobControllerValidator.asValidator(context),
                      ),
                    Align(
                      alignment: AlignmentDirectional(0.94, -0.07),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 60.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor: Color(0xFFEFF6F7),
                          icon: Icon(
                            Icons.tune,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20.0,
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: false,
                              context: context,
                              builder: (bottomSheetContext) {
                                return Padding(
                                  padding: MediaQuery.of(bottomSheetContext)
                                      .viewInsets,
                                  child: isTitulaire ? PopupOffreWidget() : PopupRechercheWidget(),
                                );
                              },
                            ).then((value) => setState(() {}));
                          },
                        ),
                      ),
                    ),
                  ],
                ), */
                     Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (offres.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ma dernière recherche',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Poppins',
                                        color: blackColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                            Container(
                              width: MediaQuery.of(context).size.width * 1.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xFF7CEDAC), Color(0xFF42D2FF)
                                  ],
                                ),
                              ),
                              child: Container(
                                 margin: EdgeInsets.all(2.0),
                                 padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                decoration: BoxDecoration(
                                  color: Colors.white, // or whatever the inner color needs to be
                                  borderRadius: BorderRadius.circular(5.0), // adjust as needed
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(offres[0]['nom'], overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins',color: blackColor,fontSize: 14.0,fontWeight: FontWeight.w400)),
                                    Text(offres[0]['poste']+' - '+offres[0]['temps']+' - '+offres[0]['salaire_mensuel']+'€ / mois', overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins',color: greyColor,fontSize: 14.0,fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x301F5C67),
                                offset: Offset(0.0, 4.0),
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(1.0, -1.0),
                              end: AlignmentDirectional(-1.0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: FFButtonWidget(
                            showLoadingIndicator: false,
                            icon: Icon(
                              Icons.tune,
                              color: greyLightColor,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (bottomSheetContext) {
                                  return Padding(
                                    padding: MediaQuery.of(bottomSheetContext)
                                        .viewInsets,
                                    child: isTitulaire
                                        ? PopupOffreWidget()
                                        : PopupRechercheWidget(),
                                  );
                                },
                              ).then((value) => setState(() {}));
                            },
                            text: 'Nouvelle recherche',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 20.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0x00FFFFFF),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 0.58,
              child: Stack(children: [
                Container(
                  child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _parisCameraPosition,
                      markers: markers,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        _manager.setMapId(controller.mapId);
                      },
                      onCameraMove: _manager.onCameraMove,
                      onCameraIdle: _manager.updateMap),
                ),

                // Afficher les resulats
                DraggableScrollableSheet(
                  minChildSize: 0.09,
                  initialChildSize: 0.09,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFEFF6F7),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Home-Indicator.svg',
                                  width: 60,
                                  colorFilter: ColorFilter.mode(
                                      Color(0xFFD0D1DE), BlendMode.srcIn),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      pharmacieInPlace.length.toString() +
                                          ' résultats',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF595A71),
                                            fontSize: 14.0,
                                          )),
                                ),
                                for (var i in pharmacieInPlace)
                                  CardPharmacieOffreRechercheWidget(data: i),
                              ],
                            ),
                          ),
                        ));
                  },
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: /* cluster.isMultiple ? */
                  cluster.count.toString() /* : null */),
        );
      };
  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Color.fromARGB(255, 65, 79, 232);
    final Paint paint2 = Paint()..color = Color.fromARGB(177, 41, 57, 227);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.2, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              color: Color(0xFFFFFFFF),
              fontSize: size / 3,
            ),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
