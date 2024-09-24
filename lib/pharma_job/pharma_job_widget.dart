import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pharmabox/auth/AuthProvider.dart';
import 'package:pharmabox/composants/card_user/card_user_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmabox/custom_code/widgets/FlutterMap.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/pharma_job/pharmaJobSearchData.dart';
import 'package:pharmabox/popups/popup_recherches_saved/popup_recherches_saved_widget.dart';

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
// import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PharmaJobWidget extends StatefulWidget {
  const PharmaJobWidget({Key? key}) : super(key: key);

  @override
  _PharmaJobWidgetState createState() => _PharmaJobWidgetState();
}

class _PharmaJobWidgetState extends State<PharmaJobWidget> {
  late PharmaJobModel _model;
  bool isTitulaire = false;
  bool pharmaExist = true;

  LatLng? _currentPosition;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? searchTerms;

  List offres = [];
  List recherches = [];

  int selectedOffreSearchSaved = 0;

  List foundedOffres = [];
  List foundedOffresLocation = [];
  List foundedRecherches = [];
  bool isLoading = true;
  List selectedPharmaciesJobs = [];
  final MapController mapController = MapController();

  bool isFromSaved = false;
  bool isFromAll = true;

  double widgetOpacity = 0.0; // 0.0 est totalement transparent, 1.0 est totalement opaque

  Future<void> getCurrentPosition() async {
    setState(() {
      isLoading = true;
    });
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
      });
    } else {
      setState(() {
        _currentPosition = LatLng(48.866667, 2.333333);
      });
    }
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    return status == PermissionStatus.granted;
  }



  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    _model = createModel(context, () => PharmaJobModel());
    _model.searchJobController ??= TextEditingController();
    _model.searchJobController ??= TextEditingController();
    checkTitulaireStatus();
    _getMesRecherches();
    setStatistics('Jobs', 'Open Jobs');
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void checkTitulaireStatus() {
    checkIsTitulaire().then((isTitulaire) {
      if (isTitulaire) {
        getPharmacyByUserId().then((pharmaExist) {
          print('MaPharma' + pharmaExist.toString());
          if (pharmaExist != '') {
            setState(() {
              this.pharmaExist = true;
            });
          } else {
            setState(() {
              this.pharmaExist = false;
              showDialogAlertCreatePharma(context);
            });
          }
        });
      }
      setState(() {
        this.isTitulaire = isTitulaire;
      });
    });
  }

  void _getAllOffres() async {
    if(isTitulaire == false) {
      foundedOffres.clear();
      selectedPharmaciesJobs.clear();
      foundedOffresLocation.clear();

      setState(() {
        isLoading = true;
      });

      var allOffres = await PharmaJobSearchData().getAllOffres();

      setState(() {
        foundedOffres = allOffres;
        for (var pharmaLocationAllOffres in allOffres) {
          foundedOffresLocation.add(pharmaLocationAllOffres['pharma_data']);
        }
        isLoading = false;
      });
    }
  }
  void _getAllrecherches() async {
    if(isTitulaire == true) {
      foundedRecherches.clear();

      setState(() {
        isLoading = true;
      });

      var allrecherces = await PharmaJobSearchData().getAllrecherches();

      setState(() {
        foundedRecherches = allrecherces;
        isLoading = false;
      });
    }
  }

  void _getMesRecherches() async {
    var mesRecherches = await PharmaJobSearchData().getMesRecherches();
    isTitulaire ? offres = mesRecherches : recherches = mesRecherches;

    if(isTitulaire == true) {
       var allSearchs = await PharmaJobSearchData().getAllrecherches();
        setState(() {
          foundedRecherches = allSearchs;
          isLoading = false;
        });
    }

    if(isTitulaire == false) {
      foundedOffres.clear();
      selectedPharmaciesJobs.clear();
      foundedOffresLocation.clear();

      setState(() {
        isLoading = true;
      });

      var allOffres = await PharmaJobSearchData().getAllOffres();

      setState(() {
        foundedOffres = allOffres;
        for (var pharmaLocationAllOffres in allOffres) {
          foundedOffresLocation.add(pharmaLocationAllOffres['pharma_data']);
        }
        isLoading = false;
      });
    }

    // isTitulaire ? _findRecherche(mesRecherches[0]) : _findOffres(mesRecherches[0]);
  }

  void _findRecherche(filters) async {
    var data = await PharmaJobSearchData().filterOffreToFindRecherches(filters);
    setState(() {
      foundedRecherches.clear();
      foundedRecherches = data;
    });
  }

  void _findOffres(filters) async {
    foundedOffres.clear();
    selectedPharmaciesJobs.clear();
    foundedOffresLocation.clear();

    setState(() {
      isLoading = true;
    });

    var data = await PharmaJobSearchData().filterRechercheToFindOffre(filters);

    setState(() {
      foundedOffres = data;
      for (var pharmaLocation in foundedOffres) {
        foundedOffresLocation.add(pharmaLocation['pharma_data']);
      }
      isLoading = false;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
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
                                    setState(() {
                                      isFromSaved = false;
                                    });
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (bottomSheetContext) {
                                        return Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: DraggableScrollableSheet(
                                                initialChildSize: 0.80,
                                                builder: (BuildContext context, ScrollController scrollController) {
                                                  return Padding(
                                                    padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                    child: isTitulaire
                                                        ? ListView(
                                                            children: [
                                                              PopupOffreWidget(
                                                                onFilter: (filters, isSaved) {
                                                                  if (isSaved) {
                                                                    _getMesRecherches();
                                                                  }
                                                                  _findRecherche(filters);
                                                                },
                                                              )
                                                            ],
                                                          )
                                                        : ListView(
                                                            children: [
                                                              PopupRechercheWidget(
                                                                onFilter: (filters, isSaved) {
                                                                  if (isSaved) {
                                                                    _getMesRecherches();
                                                                  }
                                                                  _findOffres(filters);
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                  );
                                                }),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  text: 'Nouvelle recherche',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 20.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: Color(0x00FFFFFF),
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
                                    borderRadius: BorderRadius.circular(80.0),
                                  ),
                                ),
                              ),
                            ),
                      if (offres.isNotEmpty && isTitulaire == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                      margin: EdgeInsets.all(2.0),
                                      padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      decoration: isFromAll
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
                                      child: Text('Tous les profils', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: isFromAll ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                    ),
                                  onTap: () async {
                                    setState(() {
                                      isFromSaved = false;
                                      isFromAll = true;
                                    });
                                    _getAllrecherches();
                                  },
                                ),
                              GestureDetector(
                                child: Container(
                                      margin: EdgeInsets.all(2.0),
                                      padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      decoration: isFromSaved
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
                                      child: Text('Mes recherches', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: isFromSaved ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                    ),
                                  onTap: () async {
                                    setState(() {
                                      isFromSaved = true;
                                      isFromAll = false;
                                    });
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (bottomSheetContext) {
                                        return DraggableScrollableSheet(
                                            initialChildSize: 0.80,
                                            builder: (BuildContext context, ScrollController scrollController) {
                                              return Padding(
                                                padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                child: ListView(
                                                  children: [
                                                    PopupSearchSaved(
                                                      itemSelected: selectedOffreSearchSaved,
                                                      isOffer: true,
                                                      searchSaved: offres,
                                                      onSelect: (index) {
                                                        setState(() {
                                                          _findRecherche(offres[index]);
                                                          selectedOffreSearchSaved = index;
                                                        });
                                                      },
                                                      onSave: (data) {
                                                        setState(() {
                                                          _findRecherche(data);
                                                          offres[selectedOffreSearchSaved] = data;
                                                        });
                                                      },
                                                      onDelete: (index) {
                                                        setState(() {
                                                          if (offres.length > 0) {
                                                            selectedOffreSearchSaved = 0;
                                                          } else {
                                                            offres.clear();
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    ).then((value) => setState(() {}));
                                  },
                                ),
                            ],
                          ),
                          ],
                        ),
                      if (recherches.isNotEmpty && isTitulaire == false)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.all(2.0),
                                    padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    decoration: isFromAll
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
                                    child: Text('Toutes les offres', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: isFromAll ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isFromSaved = false;
                                      isFromAll = true;
                                    });
                                    _getAllOffres();
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.all(2.0),
                                    padding: EdgeInsets.all(10.0), // adjust as needed for border width
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    decoration: isFromSaved
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
                                    child: Text('Mes recherches', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: isFromSaved ? Colors.white : blackColor, fontSize: 12.0, fontWeight: FontWeight.w400)), 
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isFromSaved = true;
                                      isFromAll = false;
                                    });
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (bottomSheetContext) {
                                        return DraggableScrollableSheet(
                                            initialChildSize: 0.80,
                                            builder: (BuildContext context, ScrollController scrollController) {
                                              return Padding(
                                                padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                child: PopupSearchSaved(
                                                  itemSelected: selectedOffreSearchSaved,
                                                  isOffer: false,
                                                  searchSaved: recherches,
                                                  onSelect: (index) {
                                                    setState(() {
                                                      _findOffres(recherches[index]);
                                                      selectedOffreSearchSaved = index;
                                                      isFromSaved = true;
                                                      isFromAll = false;
                                                    });
                                                  },
                                                  onSave: (data) {
                                                    setState(() {
                                                      _findOffres(data);
                                                      recherches[selectedOffreSearchSaved] = data;
                                                      isFromSaved = true;
                                                      isFromAll = false;
                                                    });
                                                  },
                                                  onDelete: (index) {
                                                    setState(() {
                                                      if (recherches.length > 0) {
                                                        selectedOffreSearchSaved = 0;
                                                      } else {
                                                        recherches.clear();
                                                      }
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                      },
                                    ).then((value) => setState(() {}));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      
                    ],
                  )),
            ),
            if (isTitulaire)
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF6F7),
                    ),
                    width: MediaQuery.of(context).size.width * 1.0,
                    // height: offres.isNotEmpty || recherches.isNotEmpty ? MediaQuery.of(context).size.height * 0.61 : MediaQuery.of(context).size.height * 0.72,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: foundedRecherches.length == 1
                                  ? Text(foundedRecherches.length.toString() + ' résultat',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF595A71),
                                            fontSize: 14.0,
                                          ))
                                  : Text(foundedRecherches.length.toString() + ' résultats',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF595A71),
                                            fontSize: 14.0,
                                          )),
                            ),
                            for (var user in foundedRecherches) CardUserWidget(data: user),
                          ],
                        ),
                      ),
                    )),
              ),
            if (!isTitulaire)
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  // height: offres.isNotEmpty || recherches.isNotEmpty ? MediaQuery.of(context).size.height * 0.61 : MediaQuery.of(context).size.height * 0.67,
                  child: Stack(children: [
                    isLoading
                        ? ProgressIndicatorPharmabox()
                        : MyMapWidget(
                            currentPosition: _currentPosition ?? LatLng(48.866667, 2.333333),
                            pharmacies: foundedOffresLocation,
                            mapController: mapController,
                            onMarkerTap: (id) {
                              setState(() {
                                selectedPharmaciesJobs.clear();
                                selectedPharmaciesJobs.addAll(foundedOffres.where((element) => element['pharma_data']['documentId'].toString() == id));
                              });
                            },
                          ),
                    if (selectedPharmaciesJobs.isNotEmpty)
                      AnimatedPositioned(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        bottom: 60,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var i in selectedPharmaciesJobs)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                      child: Container(width: MediaQuery.of(context).size.width * 0.9, child: CardPharmacieOffreRechercheWidget(data: i)),
                                    )
                                ],
                              ),
                            ),
                            Container(
                              child: FloatingActionButton.extended(
                                label: Text('Fermer', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: redColor, fontSize: 10.0, fontWeight: FontWeight.w500)), // <-- Text
                                backgroundColor: Colors.white,
                                elevation: 0.0,
                                icon: Icon(
                                  Icons.close,
                                  size: 18.0,
                                  color: redColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedPharmaciesJobs.clear();
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(isTitulaire ? foundedRecherches.length.toString() + ' résultats' : foundedOffres.length.toString() + ' résultats',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Poppins',
                                                color: Color(0xFF595A71),
                                                fontSize: 14.0,
                                              )),
                                    ),
                                    if (foundedOffres.isNotEmpty)
                                      for (var i in foundedOffres) CardPharmacieOffreRechercheWidget(data: i),
                                    if (foundedRecherches.isNotEmpty)
                                      for (var i in foundedRecherches) CardUserWidget(data: i),
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
    );
  }

  // Future<Marker> Function(Cluster<Place>) get _markerBuilder => (cluster) async {
  //       bool isSamePoint = false;
  //       cluster.items.forEach((p) {
  //         double distance = haversineDistance(p.location, cluster.location);
  //         print('--- FOREACH ITEMS : ' + (distance < 10 ? 'VRAI' : 'FAUX')); // Seuil de 10 mètres
  //         distance < 10 ? isSamePoint = true : isSamePoint = false;
  //       });
  //       // bool isSamePoint = false;
  //       return Marker(
  //         markerId: MarkerId(cluster.getId()),
  //         position: cluster.location,
  //         onTap: () {
  //           setState(() {
  //             selectedPharmaciesJobs.clear();
  //             cluster.items.forEach((p) {
  //               selectedPharmaciesJobs.add(p.id);
  //               print(selectedPharmaciesJobs);
  //             });
  //           });
  //         },
  //         icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75, isSamePoint, text: cluster.isMultiple ? cluster.count.toString() : cluster.count.toString(), icons: cluster.items.first.groupement.toString()),
  //       );
  //     };
  // Future<BitmapDescriptor> _getMarkerBitmap(int size, bool isSamePoint, {String text = '', icons = ''}) async {
  //   print(isSamePoint);
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder, Rect.fromPoints(Offset(0, 0), Offset(size.toDouble(), size.toDouble())));

  //   if (isSamePoint) {
  //     print('IS SAME POINT');
  //     final double markerSize = 120.0;
  //     final double radius = markerSize / 2;

  //     // Starting a new drawing on a canvas
  //     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //     final Canvas canvas = Canvas(pictureRecorder, Rect.fromPoints(Offset(0, 0), Offset(markerSize, markerSize + radius))); // Extra space for the pointy bottom

  //     // Drawing gradient circle
  //     final Paint paint = Paint()
  //       ..shader = ui.Gradient.linear(
  //         Offset(0, 0),
  //         Offset(markerSize, markerSize),
  //         [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
  //       );
  //     canvas.drawCircle(Offset(radius, radius), radius, paint);

  //     // Drawing a white circle
  //     final Paint bgWhite = Paint()..color = Color(0xFFFFFFFF);
  //     canvas.drawCircle(Offset(radius, radius), radius - 10, bgWhite);

  //     // Load and resize the image
  //     const double padding = 10.0;
  //     double imageSize = 2 * (radius - padding);

  //     // Largeur souhaitée
  //     const double desiredWidth = 150.0;

  //     final ByteData data = await rootBundle.load('assets/groupements/' + icons + '.jpg');
  //     final Uint8List bytes = Uint8List.view(data.buffer);
  //     final Codec codec = await ui.instantiateImageCodec(bytes); // Load original image first
  //     final FrameInfo frameInfo = await codec.getNextFrame();

  //     // Calculate the scale factor based on desired width
  //     double scaleFactor = desiredWidth / frameInfo.image.width.toDouble();

  //     // New width and height based on the scale factor
  //     double newWidth = frameInfo.image.width.toDouble() * scaleFactor;
  //     double newHeight = frameInfo.image.height.toDouble() * scaleFactor;

  //     // Re-decode the image with the new dimensions
  //     final Codec resizedCodec = await ui.instantiateImageCodec(bytes, targetWidth: newWidth.toInt(), targetHeight: newHeight.toInt());
  //     final FrameInfo resizedFrameInfo = await resizedCodec.getNextFrame();

  //     // Calculate the proper offset to center the image within the circle
  //     final Offset imageOffset = Offset((markerSize - newWidth) / 2, (markerSize - newHeight) / 2);

  //     // Clip the canvas to make sure the image is drawn inside the circle
  //     final Path clipOvalPath = Path()..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius));
  //     canvas.clipPath(clipOvalPath);

  //     canvas.drawImage(resizedFrameInfo.image, imageOffset, Paint());

  //     // Remove clipping so we can draw the bottom part
  //     canvas.restore();

  //     // Draw the pointy bottom
  //     final path = Path()
  //       ..moveTo(radius / 2, markerSize)
  //       ..lineTo(markerSize - (radius / 2), markerSize)
  //       ..lineTo(radius, markerSize + radius / 1.5) // Makes the triangle more pointy
  //       ..close();

  //     canvas.drawPath(path, paint);

  //     // Converting the canvas into a PNG
  //     final img = await pictureRecorder.endRecording().toImage(markerSize.toInt(), (markerSize + radius / 1.5).toInt()); // Adjust height based on pointiness
  //     final dataBytes = await img.toByteData(format: ui.ImageByteFormat.png);

  //     // Creating a BitmapDescriptor from the PNG
  //     return BitmapDescriptor.fromBytes(dataBytes!.buffer.asUint8List());
  //   } else {
  //     // Code for cluster icon with numbers
  //     final Paint paint1 = Paint()..color = Color.fromARGB(255, 65, 79, 232);
  //     final Paint paint2 = Paint()..color = Color.fromARGB(177, 41, 57, 227);

  //     canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
  //     canvas.drawCircle(Offset(size / 2, size / 2), size / 3.2, paint1);
  //     TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
  //     painter.text = TextSpan(
  //       text: text,
  //       style: TextStyle(
  //         // Using TextStyle for now, adjust as per your theme and requirements
  //         fontFamily: 'Poppins',
  //         color: Color(0xFFFFFFFF),
  //         fontSize: size / 3,
  //       ),
  //     );
  //     painter.layout();
  //     painter.paint(
  //       canvas,
  //       Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
  //     );
  //   }

  //   final img = await pictureRecorder.endRecording().toImage(size, size);
  //   final dataBytes = await img.toByteData(format: ui.ImageByteFormat.png);

  //   return BitmapDescriptor.fromBytes(dataBytes!.buffer.asUint8List());
  // }

  // double haversineDistance(LatLng p1, LatLng p2) {
  //   const R = 6371000; // rayon de la Terre en mètres
  //   var lat1Rad = p1.latitude * (pi / 180);
  //   var lat2Rad = p2.latitude * (pi / 180);
  //   var deltaLat = (p2.latitude - p1.latitude) * (pi / 180);
  //   var deltaLon = (p2.longitude - p1.longitude) * (pi / 180);

  //   var a = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
  //   var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  //   return R * c;
  // }
}
