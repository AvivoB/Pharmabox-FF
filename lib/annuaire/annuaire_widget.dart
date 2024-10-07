import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmabox/auth/AuthProvider.dart';
import 'package:pharmabox/backend/googlesheeet/laboratoires_db.dart';
import 'package:pharmabox/composants/card_labo_annuaire/card_labo_widget.dart';
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
import 'annuaire_model.dart';
export 'annuaire_model.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmabox/custom_code/widgets/prediction_ville.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';


class AnnuaireWidget extends StatefulWidget {
  final int? tabSTart;
  const AnnuaireWidget({Key? key, this.tabSTart}) : super(key: key);

  @override
  _AnnuaireWidgetState createState() => _AnnuaireWidgetState();
}

class _AnnuaireWidgetState extends State<AnnuaireWidget> with TickerProviderStateMixin {
  TabController? _tabController;
  int currentTAB = 1;
  late AnnuaireModel _model;
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

  List _laboDB = [];
  


  Future<void> getLaboDB() async {
    final String url = 'https://script.google.com/macros/s/AKfycbxrqjg978ezEg4gI4lM_BPIWoS_bIay5cQItBBsBCG4AK22rE3qtcRsRiYAkiTrLT4uLw/exec';

    try {
      final prefs = await SharedPreferences.getInstance();

        // Pas de données en cache, récupérer depuis l'API
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List fetchedData = json.decode(response.body);
          // Mettre en cache les nouvelles données
          await prefs.setString('laboDB', json.encode(fetchedData));
          setState(() {
            _laboDB = fetchedData.cast<Map<String, dynamic>>();
            isLoading = false;
          });
        } else {
          throw Exception('Erreur de chargement des données: ${response.statusCode}');
        }
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getLaboDB();
    setStatistics('Annuaire', 'Open Annuaire');
    _model = createModel(context, () => AnnuaireModel());
    _model.textController ??= TextEditingController();
    currentTAB = widget.tabSTart ?? 1;
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
                  child: TextFormField(
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
                            onChanged: (query) async {
                              setState(() async {
                                searchTerms = query;
                              });
                            }),
                ),
              ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEFF6F7),
                    ),
                    child: Builder(
                            builder: (context) {
                              // Filtrer les documents en fonction du terme de recherche
                              final filteredDocuments = _laboDB.where((document) {
                                final data = document as Map<String, dynamic>;
                                final nom = data['name'] ?? '';
                                // Comparez le titre avec le terme de recherche (en minuscules).
                                return nom.toLowerCase().contains(searchTerms?.toLowerCase() ?? '');
                              }).toList();

                              // Utiliser filteredDocuments dans le ListView.builder
                              return ListView.builder(
                                itemCount: filteredDocuments.length,  // Utiliser la longueur de filteredDocuments
                                itemBuilder: (context, index) {
                                  final itemLabo = filteredDocuments[index];  // Utiliser filteredDocuments au lieu de _laboDB
                                  return CardLaboWidget(data: itemLabo);
                                },
                              );
                            },
                          ),

                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
