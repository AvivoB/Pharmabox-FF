import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_pharmacie_offre_recherche/card_pharmacie_offre_recherche_widget.dart';
import '../composants/card_user/card_user_widget.dart';
import '../custom_code/widgets/box_in_draggable_scroll.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'explorerSearchData.dart';
import 'explorer_model.dart';
export 'explorer_model.dart';
import 'classPlaceClusterExplorer.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'explorer_provider.dart';

class ExplorerWidget extends StatefulWidget {
  const ExplorerWidget({Key? key}) : super(key: key);

  @override
  _ExplorerWidgetState createState() => _ExplorerWidgetState();
}

class _ExplorerWidgetState extends State<ExplorerWidget>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int currentTAB = 0;
  late ExplorerModel _model;
  late AnimationController _animationController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late ClusterManager _manager;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  String? searchTerms;
  List searchResults = [];
  var selectedItem;

  final CameraPosition _parisCameraPosition =
      CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 16.0);

  List<Place> items = [];
  List pharmacieInPlace = [];
  List userSearch = [];

  Future<void> getPharmaciesLocations({String searchTerm = ''}) async {
    // Get the filtered query snapshot based on the search term
    QuerySnapshot querySnapshot;

    if (searchTerm != null && searchTerm.isNotEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('pharmacies')
          .where('situation_geographique.data.ville',
              isGreaterThanOrEqualTo: searchTerm)
          .get();
    } else {
      querySnapshot =
          await FirebaseFirestore.instance.collection('pharmacies').get();
    }

    // Clear the previous data
    setState(() {
      items.clear();
      pharmacieInPlace.clear();
    });

    // Loop through the documents
    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String documentId = doc.reference.id.toString();

      data['documentId'] = documentId;

      // Retrieve the pharmacy name
      String name = data['situation_geographique']['adresse'];

      List<dynamic> location = data['situation_geographique']['lat_lng'];

      // Create a Place object
      Place place = Place(name: name, latLng: LatLng(location[0], location[1]));

      // Add the Place object to the list of places
      setState(() {
        items.add(place);
        pharmacieInPlace.add(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExplorerModel());
    _model.textController ??= TextEditingController();
    _manager = _initClusterManager();
    getPharmaciesLocations();
    _tabController = TabController(length: 2, vsync: this);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void _playAnimation() {
    _animationController.reset();
    _animationController.forward();
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
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                          validator: _model.textControllerValidator
                              .asValidator(context),
                          onChanged: (query) async {                           
                            if (currentTAB == 0)
                            setState(() async {
                              userSearch = await ExplorerSearchData().searchUsers(query);
                            });
                            if (currentTAB == 1)
                            setState(() async {
                              pharmacieInPlace = await ExplorerSearchData().searchPharmacies(query);
                            });
                          }),
                      TabBar(
                        labelColor: blackColor,
                        unselectedLabelColor: blackColor,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7CEDAC),
                              Color(0xFF42D2FF),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        indicatorWeight: 1,
                        indicatorPadding: EdgeInsets.only(top: 40),
                        controller: _tabController,
                        onTap: (value) {
                          setState(() {
                            currentTAB = value;
                          });
                        },
                        unselectedLabelStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF595A71),
                                  fontSize: 14.0,
                                ),
                        labelStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                                fontFamily: 'Poppins',
                                color: blackColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600),
                        tabs: [
                          Tab(text: 'Membres'),
                          Tab(text: 'Pharmacies'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.68,
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
                        onCameraMove: (position) {
                          setState(() {
                            selectedItem = null;
                          });
                        },
                        onCameraIdle: _manager.updateMap),
                  ),

                  if (selectedItem != null)
                    Positioned(
                      bottom: 60.0,
                      left: 10.0,
                      right: 10.0,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset.zero,
                        ).animate(_animationController),
                        child: CardPharmacieWidget(
                          data: pharmacieInPlace,
                        ),
                      ),
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
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: 
                                    currentTAB == 0 ? 
                                    Text(userSearch.length.toString() +' résultats',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF595A71),
                                              fontSize: 14.0,
                                            )) 
                                    :
                                    Text(pharmacieInPlace.length.toString() +' résultats',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF595A71),
                                              fontSize: 14.0,
                                            )),
                                  ),
                                  if (currentTAB == 0) 
                                    for (var user in userSearch)
                                      CardUserWidget(
                                        data: user,
                                      ),
                                    
                                  if (currentTAB == 1)
                                    for (var pharmacie in pharmacieInPlace)
                                      CardPharmacieWidget(
                                          data: pharmacie,
                                      ),
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
            // selectedItem = cluster.items.first;
            cluster.items.forEach((p) => selectedItem = p);
            _playAnimation();
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
