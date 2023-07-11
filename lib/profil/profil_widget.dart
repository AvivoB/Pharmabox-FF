import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmabox/constant.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_user/card_user_widget.dart';
import '../custom_code/widgets/gradient_text_custom.dart';
import '../custom_code/widgets/like_button.dart';
import '../popups/popup_specialisation/popup_specialisation_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/popups/popup_profil/popup_profil_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'profil_model.dart';
export 'profil_model.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class ProfilWidget extends StatefulWidget {
  const ProfilWidget({
    Key? key,
    String? tyeRedirect,
  })  : this.tyeRedirect = tyeRedirect ?? 'profil',
        super(key: key);

  final String tyeRedirect;

  @override
  _ProfilWidgetState createState() => _ProfilWidgetState();
}

class _ProfilWidgetState extends State<ProfilWidget> {
  late ProfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var userData;
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;

    List titulairesNetwork = [];
  List nonTitulairesNetwork = [];
  List pharmaciesNetwork = [];

  Future<void> getNetworkData() async {
    String currentUserId = await getCurrentUserId();

    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance
        .collection('users')
        .where('reseau', arrayContains: currentUserId)
        .get();

    QuerySnapshot queryPharmacies = await FirebaseFirestore.instance
        .collection('pharmacies')
        .where('reseau', arrayContains: currentUserId)
        .get();

    for (var doc in queryPharmacies?.docs ?? []) {
      var data = doc.data();
      data['documentId'] = doc.id;
      pharmaciesNetwork.add(data);
    }

    // Split users based on their 'poste' field
    for (var doc in queryUsers.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data != null && data['poste'] == 'Pharmacien(ne) titulaire') {
        titulairesNetwork.add(data);
      } else {
        nonTitulairesNetwork.add(data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        context: context,
        builder: (bottomSheetContext) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
            child: Padding(
              padding: MediaQuery.of(bottomSheetContext).viewInsets,
              child: PopupProfilWidget(),
            ),
          );
        },
      ).then((value) => setState(() {}));
    });

    getUserData();
    getNetworkData();

    _model.nomFamilleController ??= TextEditingController();
    _model.prenomController ??= TextEditingController();
    _model.emailController ??= TextEditingController(text: currentUserEmail);
    _model.telephoneController ??= TextEditingController();
    _model.birthDateController ??= TextEditingController();
    _model.postcodeController ??= TextEditingController();
    _model.cityController ??= TextEditingController();
    _model.presentationController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Gérer le cas où l'utilisateur n'est pas connecté.
      return;
    }

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (docSnapshot.exists) {
      // Accéder aux données du document.
      var data = docSnapshot.data();
      setState(() {
        userData = data;
      });

      // Définir les valeurs initiales dans les contrôleurs de texte.
      _model.nomFamilleController.text = userData['nom'] ?? '';
      _model.prenomController.text = userData['prenom'] ?? '';
      _model.emailController.text = userData['email'];
      _model.telephoneController.text = userData['telephone'] ?? '';
      _model.birthDateController.text = userData['date_naissance'] ?? '';
      _model.postcodeController.text = userData['code_postal'] ?? '';
      _model.cityController.text = userData['city'] ?? '';
      _model.presentationController.text = userData['presentation'] ?? '';
    } else {
      // Gérer le cas où les données de l'utilisateur n'existent pas.
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                wrapWithModel(
                  model: _model.headerAppModel,
                  updateCallback: () => setState(() {}),
                  child: HeaderAppWidget(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7F7FD5),
                              Color(0xFF86A8E7),
                              Color(0xFF91EAE4)
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: AlignmentDirectional(1.0, 0.34),
                            end: AlignmentDirectional(-1.0, -0.34),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.50,
                                  height: 150.0,
                                  child: Stack(
                                    alignment: AlignmentDirectional(0.0, 1.0),
                                    children: [
                                      Container(
                                        width: 150.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x00FFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(95.0),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  7.0, 7.0, 7.0, 7.0),
                                          child: Container(
                                            width: 150.0,
                                            height: 150.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            
                                            child: userData['photoUrl'] != '' ? 
                                            
                                            Image.network(
                                              userData['photoUrl'],
                                              fit: BoxFit.cover,
                                            )
                                            :
                                            Image.asset(
                                              'assets/images/Group_18.png',
                                              fit: BoxFit.cover,
                                            )
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.65, 1.0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 30.0,
                                          borderWidth: 1.0,
                                          buttonSize: 50.0,
                                          fillColor: Colors.white,
                                          icon: Icon(
                                            Icons.add_a_photo_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 30.0,
                                          ),
                                          onPressed: () {
                                            print('IconButton pressed ...');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['prenom'] + ' ' + userData['nom'],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    userData['poste'],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                  ),
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 10.0, 0.0, 0.0),
                                      child: LikeButtonWidget(
                                        documentId: userData['id'],
                                        isActive: false,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              25.0, 20.0, 25.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Form(
                                key: _model.formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.nomFamilleController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nom de famille *',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        validator: _model
                                            .nomFamilleControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.prenomController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Prénom',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        validator: _model
                                            .prenomControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: Container(
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            color: Color(0xFFD0D1DE),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                              child: Icon(
                                                Icons.work_outline,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                            FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .posteValueController ??=
                                                  FormFieldController<String>(
                                                      userData['poste']),
                                              options: [
                                                'Rayonniste',
                                                'Conseiller',
                                                'Préparateur',
                                                'Apprenti',
                                                'Etudiant pharmacie',
                                                'Etudiant pharmacie 6ème année validée',
                                                'Pharmacien(ne)',
                                                'Pharmacien(ne) titulaire'
                                              ],
                                              onChanged: (val) => setState(() =>
                                                  _model.posteValue = val),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.78,
                                              height: 50.0,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.black,
                                                      ),
                                              hintText: 'Poste *',
                                              fillColor: Colors.white,
                                              elevation: 2.0,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0.0,
                                              borderRadius: 0.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 4.0, 12.0, 4.0),
                                              hidesUnderline: true,
                                              isSearchable: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.emailController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.mail_outline_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        validator: _model
                                            .emailControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.telephoneController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Téléphone',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.local_phone,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model
                                            .telephoneControllerValidator
                                            .asValidator(context),
                                        inputFormatters: [_model.telephoneMask],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.birthDateController,
                                        onFieldSubmitted: (_) async {
                                          final _datePickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: getCurrentTimestamp,
                                            firstDate: DateTime(1900),
                                            lastDate: getCurrentTimestamp,
                                          );

                                          if (_datePickedDate != null) {
                                            setState(() {
                                              _model.datePicked = DateTime(
                                                _datePickedDate.year,
                                                _datePickedDate.month,
                                                _datePickedDate.day,
                                              );
                                            });
                                          }
                                        },
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Date de naissance',
                                          hintText: '01/01/1970',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.cake,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.datetime,
                                        validator: _model
                                            .birthDateControllerValidator
                                            .asValidator(context),
                                        inputFormatters: [_model.birthDateMask],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.postcodeController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Code postal *',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.location_on,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model
                                            .postcodeControllerValidator
                                            .asValidator(context),
                                        inputFormatters: [_model.postcodeMask],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller: _model.cityController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Ville *',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.location_city,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        validator: _model
                                            .cityControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: TextFormField(
                                        controller:
                                            _model.presentationController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Présentation',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .focusColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        validator: _model
                                            .presentationControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.height * 1.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: DefaultTabController(
                            length: 3,
                            initialIndex: 0,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
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
                                    unselectedLabelStyle:
                                        FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
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
                                      Tab(
                                        text: 'Profil',
                                      ),
                                      Tab(
                                        text: 'Réseau',
                                      ),
                                      Tab(
                                        text: userData['poste'] == 'Pharmacien(ne) titulaire'
                                            ? 'Offres'
                                            : 'Recherches',
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEFF6F7),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 12,
                                                color: Color(0x2B1F5C67),
                                                offset: Offset(10, 10),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(15),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Spécialisations',
                                                        style: FlutterFlowTheme.of(context)
                                                            .headlineMedium
                                                            .override(
                                                              fontFamily: 'Poppins',
                                                              color: FlutterFlowTheme.of(context)
                                                                  .primaryText,
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                      InkWell(
                                                        splashColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        hoverColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        onTap: () async {
                                                          await showModalBottomSheet(
                                                            isScrollControlled: true,
                                                            backgroundColor: Colors.transparent,
                                                            enableDrag: false,
                                                            context: context,
                                                            builder: (bottomSheetContext) {
                                                              return GestureDetector(
                                                                onTap: () => FocusScope.of(context)
                                                                    .requestFocus(_unfocusNode),
                                                                child: Padding(
                                                                  padding: MediaQuery.of(
                                                                          bottomSheetContext)
                                                                      .viewInsets,
                                                                  child:
                                                                      PopupSpecialisationWidget(),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) => setState(() {}));
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 30,
                                                          child: GradientTextCustom(
                                                            width: 100,
                                                            height: 30,
                                                            text: 'Ajouter',
                                                            radius: 0.0,
                                                            fontSize: 12.0,
                                                            action: () async {
                                                              await showModalBottomSheet(
                                                                isScrollControlled: true,
                                                                backgroundColor: Colors.transparent,
                                                                enableDrag: false,
                                                                context: context,
                                                                builder: (bottomSheetContext) {
                                                                  return GestureDetector(
                                                                    onTap: () => FocusScope.of(
                                                                            context)
                                                                        .requestFocus(_unfocusNode),
                                                                    child: Padding(
                                                                      padding: MediaQuery.of(
                                                                              bottomSheetContext)
                                                                          .viewInsets,
                                                                      child:
                                                                          PopupSpecialisationWidget(),
                                                                    ),
                                                                  );
                                                                },
                                                              ).then((value) => setState(() {}));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            5, 5, 5, 5),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context)
                                                                .secondaryBackground,
                                                          ),
                                                          child: ListView.builder(
                                                            padding: EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.vertical,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: /* providerUserRegister
                                                                .selectedSpecialisation.length */10,
                                                            itemBuilder: (context, index) {
                                                              return Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        0, 10, 0, 0),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                  children: [
                                                                    FlutterFlowIconButton(
                                                                      borderColor:
                                                                          Colors.transparent,
                                                                      borderRadius: 30,
                                                                      borderWidth: 1,
                                                                      buttonSize: 40,
                                                                      icon: Icon(
                                                                        Icons.delete_outline_sharp,
                                                                        color: FlutterFlowTheme.of(
                                                                                context)
                                                                            .alternate,
                                                                        size: 20,
                                                                      ),
                                                                      onPressed: () {
                                                                        // userRegisterSate
                                                                        //     .deleteSelectedSpecialisation(
                                                                        //         index);

                                                                      },
                                                                    ),
                                                                    Icon(
                                                                      Icons.verified,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size: 24,
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.6,
                                                                      decoration: BoxDecoration(
                                                                        color: FlutterFlowTheme.of(
                                                                                context)
                                                                            .secondaryBackground,
                                                                      ),
                                                                      child: Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(
                                                                                    5, 0, 0, 0),
                                                                        child: Text(
                                                                          // userData
                                                                          //         .selectedSpecialisation[
                                                                          //     index],
                                                                          'hhh',
                                                                          style:
                                                                              FlutterFlowTheme.of(
                                                                                      context)
                                                                                  .bodyMedium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
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
                                      Container(
                                        child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExpanded_Titu = !isExpanded_Titu;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: 67,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xFFF2FDFF),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x2b1e5b67),
                                      blurRadius: 12,
                                      offset: Offset(10, 10))
                                ]),
                            child: Row(
                              children: [
                                Icon(isExpanded_Titu
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                Text(
                                  'Membres titulaires (' +
                                      titulairesNetwork.length.toString() +
                                      ')',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded_Titu)
                          for (var i in titulairesNetwork)
                            CardUserWidget(data: i),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExpanded_NonTitu = !isExpanded_NonTitu;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: 67,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xFFF2FDFF),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x2b1e5b67),
                                      blurRadius: 12,
                                      offset: Offset(10, 10))
                                ]),
                            child: Row(
                              children: [
                                Icon(isExpanded_NonTitu
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                Text(
                                  'Membres (' +
                                      nonTitulairesNetwork.length.toString() +
                                      ')',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded_NonTitu)
                          for (var i in nonTitulairesNetwork)
                            CardUserWidget(data: i),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExpanded_Pharma = !isExpanded_Pharma;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: 67,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xFFF2FDFF),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x2b1e5b67),
                                      blurRadius: 12,
                                      offset: Offset(10, 10))
                                ]),
                            child: Row(
                              children: [
                                Icon(isExpanded_Pharma
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                Text(
                                  'Pharmacies (' +
                                      pharmaciesNetwork.length.toString() +
                                      ')',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded_Pharma)
                          for (var i in pharmaciesNetwork)
                            CardPharmacieWidget(data: i),
                      ],
                    ),
                  
                  ),
                                      ),
                                      Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
