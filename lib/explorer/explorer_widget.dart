import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../custom_code/widgets/box_in_draggable_scroll.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'explorer_model.dart';
export 'explorer_model.dart';
import 'classPlaceCluster.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'explorer_provider.dart';

class ExplorerWidget extends StatefulWidget {
  const ExplorerWidget({Key? key}) : super(key: key);

  @override
  _ExplorerWidgetState createState() => _ExplorerWidgetState();
}

class _ExplorerWidgetState extends State<ExplorerWidget> {
  late ExplorerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late ClusterManager _manager;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  String? searchTerms;

  final CameraPosition _parisCameraPosition =
      CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 16.0);

  List<Place> items = [];
  List pharmacieInPlace = [];

  Future<void> getPharmaciesLocations({searchTerm}) async {
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
      setState(() {
        items.add(place);
        pharmacieInPlace.add(data);
      });
      print(place.latLng);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExplorerModel());
    _model.textController ??= TextEditingController();
    _manager = _initClusterManager();
    getPharmaciesLocations();
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

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              wrapWithModel(
                model: _model.headerAppModel,
                updateCallback: () => setState(() {}),
                child: HeaderAppWidget(),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _model.textController,
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
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.71,
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
                                    child: Text(pharmacieInPlace.length.toString()+' résultats',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF595A71),
                                              fontSize: 14.0,
                                            )),
                                  ),
                                  BoxDraggableSheet(type: 'Membres',),
                                  BoxDraggableSheet(type: 'Pharmacies', nbResultats: pharmacieInPlace.length, componentWidget: CardPharmacieWidget),
                                  BoxDraggableSheet(type: 'Jobs'),
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
