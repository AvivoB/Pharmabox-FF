import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmabox/auth/AuthProvider.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:pharmabox/custom_code/widgets/FlutterMap.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/explorer/predictionVilleExplorer.dart';
import 'package:pharmabox/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmabox/custom_code/widgets/prediction_ville.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'explorer_provider.dart';

class ExplorerWidget extends StatefulWidget {
  const ExplorerWidget({Key? key}) : super(key: key);

  @override
  _ExplorerWidgetState createState() => _ExplorerWidgetState();
}

class _ExplorerWidgetState extends State<ExplorerWidget> with TickerProviderStateMixin {
  TabController? _tabController;
  int currentTAB = 1;
  late ExplorerModel _model;
  late AnimationController _animationController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final MapController mapController = MapController();
  String? searchTerms;
  List searchResults = [];
  String? selectedItem;
  bool isLoading = true;
  bool searchLoading = false;
  LatLng? _currentPosition;
  double initialZoom = 10.0;

  List _predictions = [];

  Future<void> getCurrentPosition() async {
    bool isLocationPermissionGranted = await requestLocationPermission();
    var permission = await Geolocator.checkPermission();

    print('PErmissions :  ${permission.toString()}');
    if (isLocationPermissionGranted || permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        initialZoom = 10.0;

      });
    } else {
      setState(() {
        _currentPosition = LatLng(48.866667, 2.333333);
        initialZoom = 10.0;

      });
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

    setState(() {
      pharmacieInPlace.clear();
      isLoading = true;
    });

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await _firestore.collection('pharmacies').where('user_id', isNotEqualTo: await getCurrentUserId()).where('isValid', isEqualTo: true).get();
    for (var doc in querySnapshot.docs) {
      print('il y a des données');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Create a new map that includes all keys from `data` and also adds `documentId`
      Map<String, dynamic> dataWithId = {
        ...data,
        'documentId': doc.id,
      };

      setState(() {
        pharmacieInPlace.add(dataWithId);
      });

    }

    setState(() {
      isLoading = false;
    });
    // _manager.setItems(items);
    // _manager.updateMap();
  }

  Future<void> searchPharmacies(String query) async {
    setState(() {
      isLoading = true;
      pharmacieInPlace.clear();
    });

    final lowerCaseQuery = query.toLowerCase();

    final pharmacieRef = FirebaseFirestore.instance.collection('pharmacies');

    // Start by getting all users
    final pharmacieSnapshot = await pharmacieRef.where('user_id', isNotEqualTo: await getCurrentUserId()).get();

    // Prepare to launch search queries for each field
    final fields = [
      'situation_geographique_adresse',
      'situation_geographique_data_postcode',
      'situation_geographique_data_region',
      'situation_geographique_data_rue',
      'situation_geographique_data_ville',
      'situation_geographique_data_country',
      'titulaire_principal',
    ];

    List<Future<QuerySnapshot>> searchDataFutures = [];

    pharmacieSnapshot.docs.forEach((userDoc) {
      fields.forEach((field) {
        searchDataFutures.add(userDoc.reference.collection('searchDataPharmacie').where(field, isGreaterThanOrEqualTo: lowerCaseQuery).where(field, isLessThan: lowerCaseQuery + '\uf8ff').get());
      });
    });

    // Wait for all searchData queries to complete
    final List<QuerySnapshot> searchDataSnapshots = await Future.wait(searchDataFutures);

    // Now, get the parent user documents for each searchData document that matches the query
    final List pharmacieFuture = searchDataSnapshots.expand((searchDataSnapshot) {
      return searchDataSnapshot.docs.map((searchDataDoc) {
        return pharmacieRef.doc(searchDataDoc.id).get();
      });
    }).toList();

    // Wait for all user queries to complete
    List<DocumentSnapshot> userDocs = await Future.wait(pharmacieFuture as Iterable<Future<DocumentSnapshot<Object?>>>);

    // Remove duplicate users and convert to list of user data
    final Set<String> addedUserIds = {}; // Set to keep track of added user IDs
    final List<Map<String, dynamic>> uniquePharmacie = [];
    final List<Place> uniqueItem = []; // List to store unique user data

    int countArray = 0;
    userDocs.forEach((pharmacieDoc) {
      final String pharmacieId = pharmacieDoc.id;
      final Map<String, dynamic> userData = pharmacieDoc.data() as Map<String, dynamic>;
      if (!addedUserIds.contains(pharmacieId)) {
        userData['documentId'] = pharmacieId;
        // print(userData);
        // List<dynamic> location = userData['situation_geographique']['lat_lng'];
        // String groupementDataPlace = userData['groupement'][0]['name'];
        // Place place = Place(name: userData['situation_geographique']['adresse'], latLng: LatLng(location[0], location[1]), groupement: groupementDataPlace, id: pharmacieId);

        // uniqueItem.add(place);
        uniquePharmacie.add(userData);
      }
      setState(() {
        pharmacieInPlace.clear();
        for (var pharma in uniquePharmacie) {
          pharmacieInPlace.add(pharma);
        }
      });
      // _manager.setItems(items);
      // _manager.updateMap();
    });

    setState(() {
      isLoading = false;
      searchLoading = false;
    });

    // print(uniqueItem);
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    getAllPharmacies();
    _model = createModel(context, () => ExplorerModel());
    _model.textController ??= TextEditingController();

    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.isComplete == false && authProvider.isPLusTArd == false ? showAlertCompleteProfile(context) : print('OKKK proifle complet');
    });
  }

  void _search(String query) async {
    print('predictionnn' + query.toString());
    if (query != null) {
      try {
        final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$googleMapsApi&language=fr'));
        final json = jsonDecode(response.body);

        if (json['status'] == 'OK') {
          setState(() {
            _predictions = json['results']
                .map((result) {
                  String city = '';
                  String postalCode = '';
                  String country = '';

                  for (var component in result['address_components']) {
                    if (component['types'].contains('locality')) {
                      city = component['long_name'];
                    }
                    if (component['types'].contains('postal_code')) {
                      postalCode = component['long_name'];
                    }
                    if (component['types'].contains('country')) {
                      country = component['long_name'];
                    }
                  }

                  print(city);
                  print(postalCode);
                  print(country);

                  return {'city': city, 'postal_code': postalCode, 'country': country};
                })
                .where((item) => item != null)
                .toList();
          });
        } else {
          setState(() {
            _predictions = [];
          });
        }
      } catch (e) {
        print("Erreur lors de la requête: $e");
        setState(() {
          _predictions = [];
        });
      }
    } else {
      setState(() {
        _predictions = [];
      });
    }
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
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(currentTAB == 1 || currentTAB == 2)
                      TextFormField(
                          textCapitalization: TextCapitalization.sentences,
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
                          validator: _model.textControllerValidator.asValidator(context),
                          onChanged: (query) async {
                            setState(() async {
                              searchTerms = query;
                              _search(query);
                              if (currentTAB == 1) {
                                if (query.isEmpty) {
                                  await getAllPharmacies();
                                }
                                if(query.length >= 4) {
                                  await searchPharmacies(query);
                                }
                              }
                            });
                          }),
                      if (_predictions.isNotEmpty && _predictions[0]['city'] != '' && currentTAB == 1)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _predictions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      Text(_predictions[index]['city'] + ', ' + _predictions[index]['country'], style: FlutterFlowTheme.of(context).bodyMedium),
                                    ],
                                  ),
                                  onTap: () async {
                                    List<Location> locations = await locationFromAddress(_predictions[index]['city']);
                                    if (locations.isNotEmpty) {
                                      // Les coordonnées GPS sont disponibles dans la liste des locations
                                      double latitude = locations[0].latitude;
                                      double longitude = locations[0].longitude;
                                      setState(() {
                                        _predictions.clear();
                                        mapController.move(LatLng(latitude, longitude), 14.0);
                                      });
                                    }
                                  });
                            },
                          ),
                        ),
                      // TabBar(
                      //   labelColor: blackColor,
                      //   unselectedLabelColor: blackColor,
                      //   indicator: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                      //       stops: [0, 0.5, 1],
                      //       begin: AlignmentDirectional(1, 0),
                      //       end: AlignmentDirectional(-1, 0),
                      //     ),
                      //     color: blueColor,
                      //     borderRadius: BorderRadius.circular(50.0), // adjust as needed
                      //   ),
                      //   indicatorWeight: 1,
                      //   dividerHeight: 0,
                      //   indicatorPadding: EdgeInsets.only(top: 40),
                      //   controller: _tabController,
                      //   onTap: (value) async {
                      //     currentTAB = value;
                      //     setState(() {
                      //       selectedItem = null;
                      //       // items.clear();
                      //     });
                      //   },
                      //   unselectedLabelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      //         fontFamily: 'Poppins',
                      //         color: Color(0xFF595A71),
                      //         fontSize: 14.0,
                      //       ),
                      //   labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600),
                      //   tabs: [
                      //     Tab(text: 'Relations'),
                      //     Tab(text: 'Pharmacies'),
                      //     Tab(text: 'Membres'),
                      //   ],
                      // ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Container(
                                  margin: EdgeInsets.all(2.0),
                                  padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  decoration: currentTAB == 0
                                      ? BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                                            stops: [0, 0.5, 1],
                                            begin: AlignmentDirectional(1, 0),
                                            end: AlignmentDirectional(-1, 0),
                                          ),
                                          color: blueColor,
                                          borderRadius: BorderRadius.circular(50.0), // adjust as needed
                                        )
                                      : null,
                                  child: Text('Relations', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: currentTAB == 0 ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                ),
                              onTap: () async {
                                setState(() {
                                  currentTAB = 0;
                                });
                              },
                            ),
                          GestureDetector(
                            child: Container(
                                  margin: EdgeInsets.all(2.0),
                                  padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  decoration: currentTAB == 1
                                      ? BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                                            stops: [0, 0.5, 1],
                                            begin: AlignmentDirectional(1, 0),
                                            end: AlignmentDirectional(-1, 0),
                                          ),
                                          color: blueColor,
                                          borderRadius: BorderRadius.circular(50.0), // adjust as needed
                                        )
                                      : null,
                                  child: Text('Pharmacies', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: currentTAB == 1 ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                ),
                              onTap: () async {
                                setState(() {
                                  currentTAB = 1;
                                });
                              },
                            ),
                          GestureDetector(
                            child: Container(
                                  margin: EdgeInsets.all(2.0),
                                  padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  decoration: currentTAB == 2
                                      ? BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                                            stops: [0, 0.5, 1],
                                            begin: AlignmentDirectional(1, 0),
                                            end: AlignmentDirectional(-1, 0),
                                          ),
                                          color: blueColor,
                                          borderRadius: BorderRadius.circular(50.0), // adjust as needed
                                        )
                                      : null,
                                  child: Text('Membres', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: currentTAB == 2 ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                ),
                              onTap: () async {
                                setState(() {
                                  currentTAB = 2;
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if(currentTAB == 0)
                ReseauWidget(),
              if (currentTAB == 2)
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF6F7),
                      ),
                      child: FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance.collection('users').where(FieldPath.documentId, isNotEqualTo: currentUserUid).where('isValid', isEqualTo: true).get(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            final users = snapshot.data?.docs;

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container();
                            }

                            // Simule ici la recherche en Full Text en filtrants les requetes Firestores
                            final filteredDocuments = users?.where((document) {
                              final data = document.data() as Map<String, dynamic>;
                              final nom = data['nom'] ?? '';
                              final prenom = data['prenom'] ?? '';
                              final usernameEnOrdre = data['nom'] != null && data['prenom'] != null ? data['nom'] + ' ' + data['prenom'] : '';
                              final usernameEnDesordre = data['nom'] != null && data['prenom'] != null ? data['prenom'] + ' ' + data['nom'] : '';
                              final city = data['city'] ?? '';
                              final codepostal = data['code_postal'] ?? '';
                              final poste = data['poste'] ?? '';
                              final country = data['country'] ?? '';

                              // Comparez le titre avec le terme de recherche (en minuscules).
                              return (nom.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  prenom.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  city.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  codepostal.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  poste.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  usernameEnOrdre.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  usernameEnDesordre.toLowerCase().contains(searchTerms?.toLowerCase() ?? '') ||
                                  country.toLowerCase().contains(searchTerms?.toLowerCase() ?? ''));
                            }).toList();

                            filteredDocuments?.shuffle();

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Text(filteredDocuments!.length > 1 ? filteredDocuments!.length.toString() + ' résultats' : filteredDocuments!.length.toString() + ' résultat',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF595A71),
                                            fontSize: 14.0,
                                          )),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredDocuments?.length,
                                    itemBuilder: (context, index) {
                                      final document = filteredDocuments![index];
                                      final data = document.data() as Map<String, dynamic>;
                                      return Padding(padding: const EdgeInsets.all(8.0), child: CardUserWidget(data: data));
                                    },
                                  ),
                                ),
                              ],
                            );
                          })),
                ),
              if (currentTAB == 1)
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    // height: MediaQuery.of(context).size.height * 0.66,
                    child: Stack(children: [
                      isLoading
                          ? ProgressIndicatorPharmabox()
                          : MyMapWidget(
                              pharmacies: pharmacieInPlace,
                              currentPosition: _currentPosition ?? LatLng(48.866667, 2.333333),
                              initialZoom: initialZoom,
                              mapController: mapController,
                              onMarkerTap: (documentId) {
                                setState(() {
                                  selectedItem = documentId;
                                });
                              },
                            ),

                      if (selectedItem != null)
                        Positioned(
                          bottom: 60.0,
                          left: 10,
                          right: 10,
                          child: Column(
                            children: [
                              CardPharmacieWidget(data: pharmacieInPlace.firstWhere((element) => element['documentId'] == selectedItem, orElse: () => null)),
                              Container(
                                child: FloatingActionButton.extended(
                                  label: Text('Fermer', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: redColor, fontSize: 10.0, fontWeight: FontWeight.w500)), // <-- Text
                                  backgroundColor: Colors.white,
                                  elevation: 0.0,
                                  icon: Icon(
                                    // <-- Icon
                                    Icons.close,
                                    size: 10.0,
                                    color: redColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedItem = null;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      // Afficher les resulats
                      DraggableScrollableSheet(
                        minChildSize: 0.11,
                        initialChildSize: 0.11,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return Container(
                              decoration: BoxDecoration(color: Color(0xFFEFF6F7), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/Home-Indicator.svg',
                                        width: 60,
                                        colorFilter: ColorFilter.mode(Color(0xFFD0D1DE), BlendMode.srcIn),
                                      ),
                                      if (searchLoading) Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), child: CircularProgressIndicator(color: Color(0xFF595A71), value: 5.0)),
                                      if (searchLoading == false)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                          child: pharmacieInPlace.length == 1
                                              ? Text(pharmacieInPlace.length.toString() + ' résultat',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Poppins',
                                                        color: Color(0xFF595A71),
                                                        fontSize: 14.0,
                                                      ))
                                              : Text(pharmacieInPlace.length.toString() + ' résultats',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Poppins',
                                                        color: Color(0xFF595A71),
                                                        fontSize: 14.0,
                                                      )),
                                        ),
                                      if (currentTAB == 1)
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
