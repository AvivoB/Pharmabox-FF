import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pharmabox/backend/backend.dart';
import 'package:pharmabox/composants/card_offers_profile/card_offers_profile_model.dart';
import 'package:pharmabox/custom_code/widgets/planningTable/custom_table.dart';
import 'package:pharmabox/custom_code/widgets/prediction_localisation_offre_recherches.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_drop_down.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_icon_button.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_util.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import '../../constant.dart';
import '../../custom_code/widgets/date_selector_interimaire.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/form_field_controller.dart';

class CardOfferProfilWidget extends StatefulWidget {
  CardOfferProfilWidget({Key? key, required this.searchI, this.isEditable = true});

  var searchI;
  final bool isEditable;
  @override
  State<CardOfferProfilWidget> createState() => _CardOfferProfilWidgetState();
}

class _CardOfferProfilWidgetState extends State<CardOfferProfilWidget> {
  late CardOfferProfilModel _model;
  bool isExpendedSearchOffer = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardOfferProfilModel());

    _model.posteValue = widget.searchI['poste'];
    _model.dureMoisController ??= TextEditingController(text: widget.searchI['duree']);
    _model.salaireNegocierSwitcValue = widget.searchI['salaire_negocier_ensemble'];
    _model.tempspleinpartielValue = widget.searchI['temps'];
    _model.salaireMensuelNetController ??= TextEditingController(text: widget.searchI['salaire_mensuel']);
    _model.debutContratController ??= TextEditingController(text: widget.searchI['debut_contrat']);
    _model.contratType = widget.searchI['contrats'];
    _model.tempspleinpartielValue = widget.searchI['temps'];
    _model.debutImmediateValue = widget.searchI['debut_immediat'];
    _model.posteAresponsaValueController = widget.searchI['posteAresponsaValueController'];
    // _model.avantagesValues = (widget.searchI['avantages'] as List).map((item) => item.toString()).toList();
    _model.pairImpaireValue = widget.searchI['grille_pair_impaire_identique'];
    _model.grilleHoraire = widget.searchI['grille_horaire'];
    _model.grilleHoraireImpaire = widget.searchI['grille_horaire_impaire'];
    _model.descriptionOffreController ??= TextEditingController(text: widget.searchI['description_offre']);
    _model.nomOffreController ??= TextEditingController(text: widget.searchI['nom']);
    _model.isActive = widget.searchI['isActive'];
  }

  Future<void> saveOffre(searchId) async {
    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    final CollectionReference<Map<String, dynamic>> usersRef = FirebaseFirestore.instance.collection('users');

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

    String pharmacieId = await getPharmacyByUserId();

    // Données à enregistrer
    final updateData = {
      'poste': _model.posteValue,
      'localisation': _model.localisationController.text,
      'contrats': _model.contratType.toList().take(5).toList(),
      'duree': _model.dureMoisController.text,
      'temps': _model.tempspleinpartielValue,
      'debut_immediat': _model.debutImmediateValue,
      'debut_contrat': _model.debutContratController.text,
      'salaire_negocier_ensemble': _model.salaireNegocierSwitcValue,
      'salaire_mensuel': _model.salaireMensuelNetController.text,
      'poste_responsabilite': _model.posteAresponsaValue,
      'avantages': _model.avantagesValues,
      'grille_horaire': grilleHoraireNetsed,
      'grille_pair_impaire_identique': _model.pairImpaireValue,
      'grille_horaire_impaire': grilleHoraireImpaireNetsed,
      'proposition_dispo_interim': _model.horaireDispoInterim,
      'description_offre': _model.descriptionOffreController.text,
      'nom': _model.nomOffreController.text,
      'user_id': currentUser?.uid,
      'pharmacie_id': pharmacieId,
      'isActive': _model.isActive
    };

    firestore.collection('offres').doc(searchId).update(updateData).then((_) {
      print('Données mises à jour avec succès !');
    }).catchError((error) {
      print('Erreur lors de la mise à jour des données : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedContrats = _model.contratType.toList().take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isExpendedSearchOffer = !isExpendedSearchOffer;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white, boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: widget.isEditable
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.searchI['nom'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Icon(isExpendedSearchOffer ? Icons.expand_less : Icons.expand_more),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: ShapeDecoration(
                                          color: _model.isActive != null && _model.isActive! ? Color(0xFF6AD697) : Color(0xFFD67D6A),
                                          shape: OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: _model.isActive != null && _model.isActive! ? Color(0x596AD697) : Color(0x59D67D6A),
                                              blurRadius: 4,
                                              offset: Offset(0, 0),
                                              spreadRadius: 4,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(_model.isActive != null && _model.isActive! ? 'actif' : 'inactif', style: FlutterFlowTheme.of(context).bodySmall),
                                    ],
                                  ),
                                  if (isExpendedSearchOffer)
                                    Switch.adaptive(
                                      value: _model.isActive ??= false,
                                      onChanged: (newValue) async {
                                        setState(() => _model.isActive = newValue!);
                                      },
                                      activeColor: Color(0xFF7CEDAC),
                                    ),
                                ],
                              ),
                              SizedBox(width: 10, height: 10),
                              Text('Offre valable 1 mois à partir du ' + DateFormat('dd/MM/yyyy').format(widget.searchI['date_created'].toDate()), style: FlutterFlowTheme.of(context).bodySmall),
                              if (isExpendedSearchOffer)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                                                  hintText: 'Poste',
                                                  controller: _model.posteValueController ??= FormFieldController<String>(widget.searchI['poste']),
                                                  options: ['Rayonniste', 'Conseiller', 'Préparateur', 'Apprenti', 'Etudiant pharmacie', 'Etudiant pharmacie 6ème année validée', 'Pharmacien(ne)'],
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
                                        Container(
                                          decoration: BoxDecoration(),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                                                  child: SvgPicture.asset(
                                                    'assets/icons/Contrat.svg',
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                  ),
                                                ),
                                                FlutterFlowDropDown<String>(
                                                  hintText: 'Contrat',
                                                  controller: _model.contratValueController ??= FormFieldController<String>(null),
                                                  options: ['CDI', 'CDD', 'Stage', 'Alternance', 'Intérimaire'],
                                                  onChanged: (val) async {
                                                    setState(() => _model.contratValue = val);
                                                    setState(() {
                                                      _model.addToContratType(_model.contratValue!);
                                                    });
                                                  },
                                                  width: MediaQuery.of(context).size.width * 0.80,
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
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: selectedContrats.map((e) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFEFF6F7),
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                          child: Text(
                                                            e,
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                          ),
                                                        ),
                                                        FlutterFlowIconButton(
                                                          borderColor: Colors.transparent,
                                                          borderRadius: 20.0,
                                                          borderWidth: 1.0,
                                                          buttonSize: 25.0,
                                                          fillColor: Color(0xFF7CEDAC),
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                            size: 10.0,
                                                          ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              _model.removeFromContratType(e);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        if (!_model.contratType.contains('CDI') && !_model.contratType.contains('Intérimaire'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                                                      Icons.calendar_month,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                      child: TextFormField(
                                                        textAlign: TextAlign.center,
                                                        controller: _model.dureMoisController,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          hintText: 'Durée',
                                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                                          enabledBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: Color(0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(4.0),
                                                              topRight: Radius.circular(4.0),
                                                            ),
                                                          ),
                                                          focusedBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: Color(0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(4.0),
                                                              topRight: Radius.circular(4.0),
                                                            ),
                                                          ),
                                                          errorBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: Color(0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(4.0),
                                                              topRight: Radius.circular(4.0),
                                                            ),
                                                          ),
                                                          focusedErrorBorder: UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: Color(0x00000000),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(4.0),
                                                              topRight: Radius.circular(4.0),
                                                            ),
                                                          ),
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                                        keyboardType: TextInputType.number,
                                                        validator: _model.dureMoisControllerValidator.asValidator(context),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'mois',
                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (!_model.contratType.contains('Intérimaire'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                                                      Icons.access_time,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                  FlutterFlowDropDown<String>(
                                                    controller: _model.tempspleinpartielValueController ??= FormFieldController<String>(widget.searchI['temps']),
                                                    options: ['Temps plein', 'Temps partiel', 'Dépannage'],
                                                    onChanged: (val) => setState(() => _model.tempspleinpartielValue = val),
                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                    height: 50.0,
                                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.black,
                                                        ),
                                                    hintText: 'Temps plein/partiel',
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
                                        if (!_model.contratType.contains('Intérimaire'))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                      child: Icon(
                                                        Icons.calendar_today_rounded,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Début immédiate',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                Switch.adaptive(
                                                  value: _model.debutImmediateValue ??= false,
                                                  onChanged: (newValue) async {
                                                    setState(() => _model.debutImmediateValue = newValue!);
                                                  },
                                                  activeColor: Color(0xFF7CEDAC),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (!_model.contratType.contains('Intérimaire'))
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Visibility(
                                              visible: _model.debutImmediateValue == false,
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                                child: TextFormField(
                                                  controller: _model.debutContratController,
                                                  onTap: () async {
                                                    final _datePickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate: getCurrentTimestamp,
                                                      firstDate: getCurrentTimestamp,
                                                      lastDate: DateTime(2100),
                                                    );

                                                    if (_datePickedDate != null) {
                                                      setState(() {
                                                        _model.datePicked = DateTime(
                                                          _datePickedDate.year,
                                                          _datePickedDate.month,
                                                          _datePickedDate.day,
                                                        );

                                                        _model.debutContratController.text = _datePickedDate.day.toString().padLeft(2, '0') + '/' + _datePickedDate.month.toString().padLeft(2, '0') + '/' + _datePickedDate.year.toString();
                                                      });
                                                    }
                                                  },
                                                  readOnly: true,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Début du contrat',
                                                    hintText: 'JJ/MM/AAAA',
                                                    hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0xFFD0D1DE),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context).focusColor,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    focusedErrorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4.0),
                                                        topRight: Radius.circular(4.0),
                                                      ),
                                                    ),
                                                    prefixIcon: Icon(
                                                      Icons.calendar_today_rounded,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                  validator: _model.debutContratControllerValidator.asValidator(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                    child: Icon(
                                                      Icons.payments_outlined,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Salaire à négocier ensemble',
                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                  ),
                                                ],
                                              ),
                                              Switch.adaptive(
                                                value: _model.salaireNegocierSwitcValue ??= false,
                                                onChanged: (newValue) async {
                                                  setState(() => _model.salaireNegocierSwitcValue = newValue!);
                                                },
                                                activeColor: Color(0xFF7CEDAC),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (_model.salaireNegocierSwitcValue == false)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                    child: Icon(
                                                      Icons.payments_outlined,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width * 1.0,
                                                        child: TextFormField(
                                                          textAlign: TextAlign.center,
                                                          controller: _model.salaireMensuelNetController,
                                                          obscureText: false,
                                                          decoration: InputDecoration(
                                                            hintText: _model.contratType.contains('Intérimaire') ? 'Salaire proposé' : 'Salaire mensuel net',
                                                            hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(4.0),
                                                                topRight: Radius.circular(4.0),
                                                              ),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(4.0),
                                                                topRight: Radius.circular(4.0),
                                                              ),
                                                            ),
                                                            errorBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(4.0),
                                                                topRight: Radius.circular(4.0),
                                                              ),
                                                            ),
                                                            focusedErrorBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0x00000000),
                                                                width: 1.0,
                                                              ),
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(4.0),
                                                                topRight: Radius.circular(4.0),
                                                              ),
                                                            ),
                                                          ),
                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                          keyboardType: TextInputType.number,
                                                          validator: _model.salaireMensuelNetControllerValidator.asValidator(context),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    _model.contratType.contains('Intérimaire') ? '€ TTC / H' : '€ / mois',
                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        Container(
                                          decoration: BoxDecoration(),
                                        ),
                                        if (_model.contratType.contains('Intérimaire')) Text('Disponibilités', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600)),
                                        if (_model.contratType.contains('Intérimaire'))
                                          Container(
                                            height: 390,
                                            child: DateSelector(
                                              initialSelectedDates: widget.searchI['proposition_dispo_interim'] != null ? (widget.searchI['proposition_dispo_interim'] as List).map((item) => (item as Timestamp).toDate()).toList() : <DateTime>[],
                                              onDatesChanged: (selectedDates) {
                                                _model.horaireDispoInterim = selectedDates;
                                              },
                                            ),
                                          ),
                                        if (!_model.contratType.contains('Intérimaire'))
                                          Container(
                                            width: MediaQuery.of(context).size.width * 1.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Poste à responsabilité ?',
                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                  ),
                                                  FlutterFlowChoiceChips(
                                                    options: [ChipData('Oui'), ChipData('Non')],
                                                    onChanged: (val) => setState(() => _model.posteAresponsaValue = val?.first),
                                                    selectedChipStyle: ChipStyle(
                                                      backgroundColor: Color(0xFF7CEDAC),
                                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: Colors.white,
                                                          ),
                                                      iconColor: FlutterFlowTheme.of(context).primaryText,
                                                      iconSize: 1.0,
                                                      elevation: 0.0,
                                                    ),
                                                    unselectedChipStyle: ChipStyle(
                                                      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                                      textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                            fontFamily: 'Poppins',
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            fontSize: 16.0,
                                                          ),
                                                      iconColor: FlutterFlowTheme.of(context).primaryText,
                                                      iconSize: 18.0,
                                                      elevation: 0.0,
                                                    ),
                                                    chipSpacing: 20.0,
                                                    multiselect: false,
                                                    alignment: WrapAlignment.start,
                                                    controller: _model.posteAresponsaValueController ??= FormFieldController<List<String>>(
                                                      [widget.searchI['poste_responsabilite'] != null ? widget.searchI['poste_responsabilite'] : ''],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (!_model.contratType.contains('Intérimaire'))
                                          Container(
                                            width: MediaQuery.of(context).size.width * 1.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Avantages',
                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                  ),
                                                  FlutterFlowChoiceChips(
                                                    options: [
                                                      ChipData('Primes', Icons.payments),
                                                      ChipData('Crèche d\'entreprise', Icons.child_friendly),
                                                      ChipData('Déplacements pris en charge', Icons.directions_bus),
                                                      ChipData('Tickets cadeau', Icons.card_giftcard),
                                                      ChipData('Logement possible', Icons.house_siding),
                                                      ChipData('Tickets Restaurants ', Icons.credit_card_outlined)
                                                    ],
                                                    onChanged: (val) => setState(() => _model.avantagesValues = val),
                                                    selectedChipStyle: ChipStyle(
                                                      backgroundColor: Color(0xFF7CEDAC),
                                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: Colors.white,
                                                          ),
                                                      iconColor: Colors.white,
                                                      iconSize: 18.0,
                                                      elevation: 0.0,
                                                    ),
                                                    unselectedChipStyle: ChipStyle(
                                                      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                                      textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                                            fontFamily: 'Poppins',
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            fontSize: 16.0,
                                                          ),
                                                      iconColor: FlutterFlowTheme.of(context).primaryText,
                                                      iconSize: 16.0,
                                                      elevation: 0.0,
                                                    ),
                                                    chipSpacing: 5.0,
                                                    rowSpacing: 5.0,
                                                    multiselect: true,
                                                    initialized: _model.avantagesValues != null,
                                                    alignment: WrapAlignment.start,
                                                    controller: _model.avantagesValueController ??= FormFieldController<List<String>>(
                                                      widget.searchI['avantages'] != null ? (widget.searchI['avantages'] as List).map((item) => item.toString()).toList() : [],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (!_model.contratType.contains('Intérimaire'))
                                          Container(
                                            width: MediaQuery.of(context).size.width * 1.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Grille horaire\n',
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                                GrilleHoraire(
                                                  onInitialValue: widget.searchI['grille_horaire'],
                                                  onSelectionChanged: (selected) {
                                                    _model.grilleHoraire = selected;
                                                  },
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Grille paires / impaires identiques',
                                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                                      ),
                                                      Switch.adaptive(
                                                        value: _model.pairImpaireValue ??= true,
                                                        onChanged: (newValue) async {
                                                          setState(() => _model.pairImpaireValue = newValue!);
                                                        },
                                                        activeColor: Color(0xFF7CEDAC),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (_model.pairImpaireValue == false)
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width * 10.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                      child: Text(
                                                        'Grille horaire semaines impaires',
                                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        if (_model.pairImpaireValue == false)
                                          GrilleHoraire(
                                            onInitialValue: widget.searchI['grille_horaire_impaire'],
                                            onSelectionChanged: (selected) {
                                              _model.grilleHoraire = selected;
                                            },
                                          ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                          child: TextFormField(
                                            controller: _model.descriptionOffreController,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Description de l\'offre',
                                              hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD0D1DE),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context).focusColor,
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                            maxLines: null,
                                            keyboardType: TextInputType.multiline,
                                            validator: _model.descriptionOffreControllerValidator.asValidator(context),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                          child: TextFormField(
                                            controller: _model.nomOffreController,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Nom de l\'offre',
                                              hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD0D1DE),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(context).focusColor,
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                            maxLines: null,
                                            keyboardType: TextInputType.multiline,
                                            validator: _model.nomOffreControllerValidator.asValidator(context),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
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
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                await Future.delayed(Duration(seconds: 2));
                                                saveOffre(widget.searchI['doc_id']);
                                                showCustomSnackBar(context, 'Offre mise à jour');
                                              },
                                              text: 'Enregistrer',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                color: Color(0x00FFFFFF),
                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                elevation: 0.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(0.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.searchI['nom'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Icon(isExpendedSearchOffer ? Icons.expand_less : Icons.expand_more),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: ShapeDecoration(
                                          color: _model.isActive != null && _model.isActive! ? Color(0xFF6AD697) : Color(0xFFD67D6A),
                                          shape: OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: _model.isActive != null && _model.isActive! ? Color(0x596AD697) : Color(0x59D67D6A),
                                              blurRadius: 4,
                                              offset: Offset(0, 0),
                                              spreadRadius: 4,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(_model.isActive != null && _model.isActive! ? 'actif' : 'inactif', style: FlutterFlowTheme.of(context).bodySmall),
                                    ],
                                  ),
                                ],
                              ),
                              if (isExpendedSearchOffer)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                      child: Row(children: [
                                        Icon(
                                          Icons.place_outlined,
                                          color: greyColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(width: 10),
                                        if (widget.searchI != null && widget.searchI['localisation_job'] != null) Flexible(child: Text(widget.searchI['localisation_job'] ?? '', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)))
                                      ]),
                                    ),
                                    for (var contrat in widget.searchI['contrats'] as List)
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.description_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text(contrat.toString(), style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['temps'] != null)
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.schedule_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text(widget.searchI['temps'] != null ? widget.searchI['temps'] : '', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                      child: Row(children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: greyColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(width: 10),
                                        Text(widget.searchI['debut_immediat'] && widget.searchI['debut_contrat'] == '' ? 'Démarrage immédiat' : 'Démarrage le ' + widget.searchI['debut_contrat'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                      ]),
                                    ),
                                    if (widget.searchI['duree'] != '')
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text(widget.searchI['duree'] + ' mois', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                      child: Row(children: [
                                        Icon(
                                          Icons.payments_outlined,
                                          color: greyColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(width: 10),
                                        Text(widget.searchI['contrats'].contains('Intérimaire') ? widget.searchI['salaire_mensuel'] + ' €/mois net' : widget.searchI['salaire_mensuel'] + ' €/H net', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                      ]),
                                    ),
                                    if (widget.searchI['poste_responsabilite'] != "Non")
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.groups,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Offre à responsabilité', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['avantages'] != null && widget.searchI['avantages'].contains('Primes'))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.emoji_events_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Primes', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['avantages'] != null && widget.searchI['avantages'].contains('Crèche d\'entreprise'))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.cruelty_free_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Crèche d\'entreprise', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['avantages'] != null && widget.searchI['avantages'].contains('Déplacements pris en charge'))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.directions_bus,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Frais de transport', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['avantages'] != null && widget.searchI['avantages'].contains('Tickets cadeau'))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.card_giftcard,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Tickets cadeau', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['avantages'] != null && widget.searchI['avantages'].contains('Tickets Restaurants'))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.restaurant_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Tickets restaurant', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (widget.searchI['avantages'] != null && widget.searchI['avantages'].contains('Logement possible'))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.cottage_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Hébergement', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16))
                                        ]),
                                      ),
                                    if (!widget.searchI['contrats'].contains('Intérimaire') && widget.searchI['grille_horaire'] != null && widget.searchI['grille_horaire'] != '')
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Text('Horaires', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
                                      ),
                                    if (widget.searchI['grille_horaire'] != null && widget.searchI['grille_horaire'] != [])
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: GrilleHoraire(onSelectionChanged: (data) => {}, onInitialValue: widget.searchI['grille_horaire'] != [] ? widget.searchI['grille_horaire'] : [], isEditable: false),
                                      ),
                                    if (widget.searchI['grille_pair_impaire_identique'])
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.date_range_outlined,
                                            color: greyColor,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(child: Text('Semaines pairs et impaires identiques', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)))
                                        ]),
                                      ),
                                    if (widget.searchI['grille_pair_impaire_identique'] == false && widget.searchI['grille_horaire_impaire'] != [])
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: GrilleHoraire(onSelectionChanged: (data) => {}, onInitialValue: widget.searchI['grille_horaire_impaire'] != [] ? widget.searchI['grille_horaire_impaire'] : [], isEditable: false),
                                      ),
                                    if (widget.searchI['contrats'].contains('Intérimaire') && widget.searchI['proposition_dispo_interim'] != null)
                                      // Padding(
                                      //   padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                      //   child: DateSelector(initialSelectedDates: widget.searchI['proposition_dispo_interim'] !=null? (widget.searchI['proposition_dispo_interim'] as List).map((item) =>(item as Timestamp).toDate()).toList(): <DateTime>[],onDatesChanged: (selectedDates) {},
                                      // )),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                        child: Text('Description du poste', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
                                      ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 15.0, 0.0),
                                      child: Row(children: [Flexible(child: Text(widget.searchI['description_offre'], style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 16)))]),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
