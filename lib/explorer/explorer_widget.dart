import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:permission_handler/permission_handler.dart';

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
  List selectedItem = [];
  var _currentCameraPosition;

  Future<void> getCurrentPosition() async {
    bool isLocationPermissionGranted = await requestLocationPermission();

    if (isLocationPermissionGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        );
      });
    } else {
      // Handle the case when the user denies the location permission
      // Add your own logic or show a message to the user
    }
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    return status == PermissionStatus.granted;
  }

  List<Place> items = [];
  List pharmacieInPlace = [];
  List userSearch = [];

  Future<void> getAllPharmacies() async {
    items.clear();
    pharmacieInPlace.clear();

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await _firestore
        .collection('pharmacies')
        .where('user_id', isNotEqualTo: await getCurrentUserId())
        .get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Create a new map that includes all keys from `data` and also adds `documentId`
      Map<String, dynamic> dataWithId = {
        ...data,
        'documentId': doc.id,
      };

      String name = dataWithId['situation_geographique']['adresse'];
      List<dynamic> location = dataWithId['situation_geographique']['lat_lng'];
      Place place = Place(name: name, latLng: LatLng(location[0], location[1]));
      setState(() {
        items.add(place);
        pharmacieInPlace.add(dataWithId);
      });
    }
  }

  Future<void> searchPharmacies(String query) async {
    items.clear();
    pharmacieInPlace.clear();

    final lowerCaseQuery = query.toLowerCase();

    final pharmacieRef = FirebaseFirestore.instance.collection('pharmacies');

    // Start by getting all users
    final pharmacieSnapshot = await pharmacieRef
        .where('user_id', isNotEqualTo: await getCurrentUserId())
        .get();

    // Prepare to launch search queries for each field
    final fields = [
      'situation_geographique_adresse',
      'situation_geographique_data_postcode',
      'situation_geographique_data_region',
      'situation_geographique_data_rue',
      'situation_geographique_data_ville',
      'titulaire_principal',
    ];

    List<Future<QuerySnapshot>> searchDataFutures = [];

    pharmacieSnapshot.docs.forEach((userDoc) {
      fields.forEach((field) {
        searchDataFutures.add(userDoc.reference
            .collection('searchDataPharmacie')
            .where(field, isGreaterThanOrEqualTo: lowerCaseQuery)
            .where(field, isLessThan: lowerCaseQuery + '\uf8ff')
            .get());
      });
    });

    // Wait for all searchData queries to complete
    final List<QuerySnapshot> searchDataSnapshots =
        await Future.wait(searchDataFutures);

    // Now, get the parent user documents for each searchData document that matches the query
    final List pharmacieFuture =
        searchDataSnapshots.expand((searchDataSnapshot) {
      return searchDataSnapshot.docs.map((searchDataDoc) {
        return pharmacieRef.doc(searchDataDoc.id).get();
      });
    }).toList();

    // Wait for all user queries to complete
    List<DocumentSnapshot> userDocs = await Future.wait(
        pharmacieFuture as Iterable<Future<DocumentSnapshot<Object?>>>);

    // Remove duplicate users and convert to list of user data
    final Set<String> addedUserIds = {}; // Set to keep track of added user IDs
    final List<Map<String, dynamic>> uniquePharmacie = [];
    final List<Place> uniqueItem = []; // List to store unique user data
    userDocs.forEach((pharmacieDoc) {
      final String pharmacieId = pharmacieDoc.id;
      final Map<String, dynamic> userData =
          pharmacieDoc.data() as Map<String, dynamic>;
      if (!addedUserIds.contains(pharmacieId)) {
        userData['documentId'] = pharmacieId;
        print(userData);
        List<dynamic> location = userData['situation_geographique']['lat_lng'];
        Place place = Place(
            name: userData['situation_geographique']['adresse'],
            latLng: LatLng(location[0], location[1]));

        uniqueItem.add(place);
        uniquePharmacie.add(userData);
      }
    });

    setState(() {
      items = uniqueItem;
      pharmacieInPlace = uniquePharmacie;
    });

    _manager.setItems(items);
    _manager.updateMap();
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    getAllPharmacies();
    _model = createModel(context, () => ExplorerModel());
    _model.textController ??= TextEditingController();
    _manager = _initClusterManager();
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
                            setState(() async {
                              if (currentTAB == 0) {
                                if (query.isEmpty) {
                                  userSearch.clear();
                                } else {
                                  userSearch = await ExplorerSearchData()
                                      .searchUsers(query);
                                }
                              }

                              if (currentTAB == 1) {
                                if (query.isEmpty) {
                                  items.clear();
                                  pharmacieInPlace.clear();
                                  await getAllPharmacies();
                                } else {
                                  pharmacieInPlace.clear();
                                  await searchPharmacies(query);
                                }
                              }
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
                        onTap: (value) async {
                          currentTAB = value;
                          setState(() {
                            selectedItem.clear();
                            // items.clear();
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
              if (currentTAB == 0)
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF6F7),
                    ),
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: userSearch.length == 1
                                  ? Text(
                                      userSearch.length.toString() +
                                          ' résultat',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF595A71),
                                            fontSize: 14.0,
                                          ))
                                  : Text(
                                      userSearch.length.toString() +
                                          ' résultats',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF595A71),
                                            fontSize: 14.0,
                                          )),
                            ),
                            for (var user in userSearch)
                              CardUserWidget(
                                data: user,
                              ),
                          ],
                        ),
                      ),
                    )),
              if (currentTAB == 1)
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.67,
                  child: Stack(children: [
                    Container(
                      child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _currentCameraPosition,
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
                              selectedItem.clear();
                            });
                          },
                          onCameraIdle: _manager.updateMap),
                    ),

                    if (selectedItem.isNotEmpty)
                      Positioned(
                        bottom: 60.0,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i in selectedItem)
                                CardPharmacieWidget(data: pharmacieInPlace[i]),
                            ],
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
                                      child: pharmacieInPlace.length == 1
                                          ? Text(
                                              pharmacieInPlace.length
                                                      .toString() +
                                                  ' résultat',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFF595A71),
                                                        fontSize: 14.0,
                                                      ))
                                          : Text(
                                              pharmacieInPlace.length
                                                      .toString() +
                                                  ' résultats',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFF595A71),
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
            cluster.items.forEach((p) => selectedItem.add(1));
            _playAnimation();
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
          text: cluster.count.toString()),
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
    final data = await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
