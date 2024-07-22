import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constant.dart';
import '../../custom_code/widgets/date_selector_interimaire.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'popup_offre_model.dart';
export 'popup_offre_model.dart';

class PopupOffreWidget extends StatefulWidget {
  const PopupOffreWidget({Key? key, this.onFilter }) : super(key: key);
  final Function(dynamic, bool)? onFilter;

  @override
  _PopupOffreWidgetState createState() => _PopupOffreWidgetState();
}

class _PopupOffreWidgetState extends State<PopupOffreWidget> {
  late PopupOffreModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupOffreModel());

    _model.localisationController ??= TextEditingController();
    _model.dureMoisController ??= TextEditingController();
    _model.debutContratController ??= TextEditingController(text: dateTimeFormat('d/M/y', _model.datePicked));
    _model.salaireMensuelNetController ??= TextEditingController();
    _model.descriptionOffreController ??= TextEditingController();
    _model.nomOffreController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void saveOffre(context) async {
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
    final createOffre = {
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
      'nom': _model.nomOffreController.text != '' ? _model.nomOffreController.text : _model.posteValue,
      'user_id': currentUser?.uid,
      'pharmacie_id': pharmacieId,
      'date_created': Timestamp.now(),
      'isActive': true,
    };

    if (_model.posteValue != null && _model.enregistrerOffre == true) {
      firestore.collection('offres').add(createOffre);
      showCustomSnackBar(context, 'Votre offre a été enregistrée');
      widget.onFilter!(createOffre, true);
    } else if (_model.enregistrerOffre == false) {
      widget.onFilter!(createOffre, false);
    } else {
      showCustomSnackBar(context, 'Merci de renseigner le poste recherché', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedContrats = _model.contratType.toList().take(5).toList();
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
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Filtrer',
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
                Expanded(
                  child: SingleChildScrollView(
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
                                  controller: _model.posteValueController ??= FormFieldController<String>(null),
                                  options: ['Rayonniste', 'Conseiller', 'Préparateur', 'Apprenti', 'Etudiant pharmacie', 'Etudiant pharmacie 6ème année validée', 'Pharmacien'],
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
                                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
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
                                    controller: _model.tempspleinpartielValueController ??= FormFieldController<String>(null),
                                    options: ['Temps plein', 'Temps partiel'],
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
                                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          validator: _model.salaireMensuelNetControllerValidator.asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _model.contratType.contains('Intérimaire') ? '€ NET / H' : '€ / mois',
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
                                      [],
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
                                      [],
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
                                custom_widgets.GrilleHoraire(
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
                          custom_widgets.GrilleHoraire(
                            onSelectionChanged: (selected) {
                              _model.grilleHoraireImpaire = selected;
                            },
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
                                  Text(
                                    'Enregistrer mon offre d\'emploi ?',
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ],
                              ),
                              Switch.adaptive(
                                value: _model.enregistrerOffre ??= false,
                                onChanged: (newValue) async {
                                  setState(() => _model.enregistrerOffre = newValue!);
                                },
                                activeColor: Color(0xFF7CEDAC),
                              ),
                            ],
                          ),
                        ),
                        if (_model.enregistrerOffre == true)
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
                              textInputAction: TextInputAction.done,
                              validator: _model.descriptionOffreControllerValidator.asValidator(context),
                            ),
                          ),
                        if (_model.enregistrerOffre == true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
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
                        if (_model.enregistrerOffre == true)
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
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  saveOffre(context);
                                  Navigator.pop(context);
                                },
                                text: 'Enregistrer mon offre et rechercher',
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
                                        fontWeight: FontWeight.w600,
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
                        if (_model.enregistrerOffre == false)
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
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  saveOffre(context);
                                  Navigator.pop(context);
                                },
                                text: 'Rechercher',
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
                                        fontWeight: FontWeight.w600,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
