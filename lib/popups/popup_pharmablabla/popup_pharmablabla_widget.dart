import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/auth/firebase_auth/auth_util.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:pharmabox/popups/popup_groupement/popup_groupement_model.dart';
import 'package:pharmabox/popups/popup_lgo/popup_lgo_model.dart';

import '../../constant.dart';
import '../../custom_code/widgets/date_selector_interimaire.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'popup_pharmablabla_model.dart';
export 'popup_pharmablabla_model.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;

class PopupPharmaBlabla extends StatefulWidget {
  const PopupPharmaBlabla({Key? key, this.onFilter}) : super(key: key);
  final Function(dynamic)? onFilter;

  @override
  _PopupPharmaBlablaState createState() => _PopupPharmaBlablaState();
}

class _PopupPharmaBlablaState extends State<PopupPharmaBlabla> {
  late PopupPharmaBlablaModel _model;
  Map<String, dynamic> userData = {};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupPharmaBlablaModel());

    _model.localisationController ??= TextEditingController();
    _model.dureMoisController ??= TextEditingController();
    _model.debutContratController ??= TextEditingController(text: dateTimeFormat('d/M/y', _model.datePicked));
    _model.salaireMensuelNetController ??= TextEditingController();
    _model.rayonController ??= TextEditingController();
    _model.nomOffreController ??= TextEditingController();

    final CollectionReference<Map<String, dynamic>> usersRef = FirebaseFirestore.instance.collection('users');

    usersRef.doc(currentUser?.uid).get().then((snapshot) => userData = snapshot.data()!).catchError((error) => print("Error fetching user data: $error"));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void saveRecherche() {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    List<Map<String, dynamic>> grilleHoraireNetsed = _model.grilleHoraire.map((semaine) {
      return {
        'semaine': semaine,
      };
    }).toList();

    List<Map<String, dynamic>> grilleHoraireImpaireNetsed = _model.grilleHoraireImpaire.map((semaine) {
      return {
        'semaine': semaine,
      };
    }).toList();

    // Données à enregistrer
    final createRecherche = {
      'poste': userData['poste'],
      'nom': userData['poste'],
      'localisation': _model.localisationController.text,
      'rayon': _model.rayonController.text,
      'contrats': _model.contratType.toList().take(5).toList(),
      'duree': _model.dureMoisController.text,
      'temps': _model.tempspleinpartielValue,
      'debut_immediat': _model.debutImmediateValue,
      'debut_contrat': _model.debutContratController.text,
      'salaire_mensuel': _model.salaireMensuelNetController.text,
      'grille_horaire': grilleHoraireNetsed,
      'grille_pair_impaire_identique': _model.pairImpaireValue,
      'grille_horaire_impaire': grilleHoraireImpaireNetsed,
      'horaire_dispo_interim': _model.horaireDispoInterim.map((date) => Timestamp.fromDate(date)).toList(),
      'user_id': currentUser?.uid,
      'date_created': Timestamp.now(),
      'isActive': true
    };
    widget.onFilter!(createRecherche);
  }

  @override
  Widget build(BuildContext context) {
    List<Map> listLGO = PopupLgoModel.selectLGO();
    List<Map> listGroupement = PopupGroupementModel.selectGroupement();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Filtres de publication',
                        style: FlutterFlowTheme.of(context).displaySmall,
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderWidth: 0.0,
                        buttonSize: 60.0,
                        icon: Icon(
                          Icons.close,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Text('Vous souhaitez rendre visible votre publication pour :', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12)),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Color(0xFFD0D1DE),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.work_outline,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ),
                          FlutterFlowDropDown<String>(
                            hintText: 'Tout Pharmabox',
                            controller: _model.posteValueController ??= FormFieldController<String>('Tout Pharmabox'),
                            options: ['Tout Pharmabox', 'Uniquement mon réseau'],
                            onChanged: (val) => setState(() => _model.posteValue = val),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50.0,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                ),
                            fillColor: Colors.white,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 0.0,
                            margin: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                            hidesUnderline: true,
                            isSearchable: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('Séléctionnez par quel poste souhaitez que votre publication soit vue.', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12)),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Color(0xFFD0D1DE),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.work_outline,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ),
                          FlutterFlowDropDown<String>(
                            hintText: 'Tous',
                            controller: _model.posteValueController ??= FormFieldController<String>('Tous'),
                            options: ['Tous', 'Rayonniste', 'Conseiller', 'Préparateur', 'Apprenti', 'Etudiant pharmacie', 'Etudiant pharmacie 6ème année validée', 'Pharmacien(ne)'],
                            onChanged: (val) => setState(() => _model.posteValue = val),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50.0,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                ),
                            fillColor: Colors.white,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 0.0,
                            margin: EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 4.0),
                            hidesUnderline: true,
                            isSearchable: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('Séléctionnez par quel poste souhaitez que votre publication soit vue.', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12)),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: listLGO.length,
                      itemBuilder: (context, index) {
                        final item = listLGO;
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                          child: GestureDetector(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/lgo/' + item[index]['image'],
                                  width: 120.0,
                                  height: 60.0,
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    item[index]['name'],
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // widget.onTap(item[index]);
                              // Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.50,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: listGroupement.length,
                      itemBuilder: (context, index) {
                        final item = listGroupement;
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                          child: GestureDetector(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/groupements/' + item[index]['image'],
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  height: 60.0,
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.50,
                                    child: Text(
                                      item[index]['name'],
                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // widget.onTap(item[index]);
                              // Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
