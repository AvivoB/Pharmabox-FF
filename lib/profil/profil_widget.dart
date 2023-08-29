import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmabox/composants/card_offers_profile/card_offers_profile.dart';
import 'package:pharmabox/composants/card_searchs_profile/card_searchs_profile.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/profil/profil_provider.dart';

import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_user/card_user_widget.dart';
import '../composants/list_skill_with_slider/list_skill_with_slider_widget.dart';
import '../custom_code/widgets/date_selector_interimaire.dart';
import '../custom_code/widgets/gradient_text_custom.dart';
import '../custom_code/widgets/like_button.dart';
import '../custom_code/widgets/planningTable/custom_table.dart';
import '../custom_code/widgets/prediction_localisation_offre_recherches.dart';
import '../popups/popup_experiences/popup_experiences_widget.dart';
import '../popups/popup_langues/popup_langues_widget.dart';
import '../popups/popup_lgo/popup_lgo_widget.dart';
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

class _ProfilWidgetState extends State<ProfilWidget> with SingleTickerProviderStateMixin {
  late ProfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var userData;
  List recherchesUser = [];
  List offresUser = [];
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;

  List titulairesNetwork = [];
  List nonTitulairesNetwork = [];
  List pharmaciesNetwork = [];

  TabController? _tabController;
  int _selectedIndex = 0;

  Future<void> getNetworkData() async {
    String currentUserId = await getCurrentUserId();

    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: currentUserId).get();

    QuerySnapshot queryPharmacies = await FirebaseFirestore.instance.collection('pharmacies').where('reseau', arrayContains: currentUserId).get();

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

  updateUserToFirebase(context) {
    final providerProfilUser = Provider.of<ProviderProfilUser>(context, listen: false);

    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    final CollectionReference<Map<String, dynamic>> usersRef = FirebaseFirestore.instance.collection('users');

    if (_model.nomFamilleController.text != '' && _model.prenomController.text != '' && _model.postcodeController.text != '' && _model.cityController.text != '' && _model.posteValue != null) {
      usersRef.doc(currentUser?.uid).update({
        'nom': _model.nomFamilleController.text,
        'prenom': _model.prenomController.text,
        'poste': _model.posteValue,
        'email': _model.emailController.text,
        'telephone': _model.telephoneController.text,
        'date_naissance': _model.birthDateController.text,
        'code_postal': _model.postcodeController.text,
        'city': _model.cityController.text,
        'presentation': _model.presentationController.text,
        'specialisations': providerProfilUser.selectedSpecialisation,
        'lgo': providerProfilUser.selectedLgo,
        'competences': providerProfilUser.selectedCompetences,
        'langues': providerProfilUser.selectedLangues,
        'experiences': providerProfilUser.selectedExperiences,
        'photoUrl': _model.imageURL,
      });
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Merci de compléter votre profil'),
          backgroundColor: redColor,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilModel());
    _tabController = TabController(length: 3, vsync: this);
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

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    QuerySnapshot recherches = await FirebaseFirestore.instance.collection('recherches').where('user_id', isEqualTo: user.uid).get();
    QuerySnapshot offres = await FirebaseFirestore.instance.collection('offres').where('user_id', isEqualTo: user.uid).get();

    if (docSnapshot.exists) {
      // Accéder aux données du document.
      var data = docSnapshot.data();
      setState(() {
        userData = data;
        for (var doc in recherches.docs) {
          var docData = doc.data() as Map<String, dynamic>;
          docData['doc_id'] = doc.id;
          recherchesUser.add(docData);
        }
        for (var doc in offres.docs) {
          var docData = doc.data() as Map<String, dynamic>;
          docData['doc_id'] = doc.id;
          offresUser.add(docData);
        }
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
      _model.imageURL = userData['photoUrl'] ?? '';
      _model.posteValue = userData['poste'] ?? '';
    } else {
      // Gérer le cas où les données de l'utilisateur n'existent pas.
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerProfilUser = Provider.of<ProviderProfilUser>(context);
    providerProfilUser.setSpecialisation(userData != null ? userData['specialisations'] : []);
    providerProfilUser.setLGO(userData != null ? userData['lgo'] : []);
    providerProfilUser.setCompetence(userData != null ? userData['competences'] : []);
    providerProfilUser.setLangues(userData != null ? userData['langues'] : []);
    providerProfilUser.setExperiences(userData != null ? userData['experiences'] : []);

    File? _image;
    bool _isUploading = false;

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isUploading = true;
        });

        final Reference storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putFile(_image!);
        final TaskSnapshot downloadUrl = (await uploadTask);

        String url = (await downloadUrl.ref.getDownloadURL());

        setState(() {
          _isUploading = false;
          _model.imageURL = url;
        });
      }
    }

    return Consumer<ProviderProfilUser>(builder: (context, providerProfilUser, child) {
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
                              colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
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
                                            borderRadius: BorderRadius.circular(95.0),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(7.0, 7.0, 7.0, 7.0),
                                            child: Container(
                                                width: 150.0,
                                                height: 150.0,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: (userData != null && userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty)
                                                    ? Image.network(
                                                        userData['photoUrl'],
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/Group_18.png',
                                                        fit: BoxFit.cover,
                                                      )),
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(0.65, 1.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            borderWidth: 1.0,
                                            buttonSize: 50.0,
                                            fillColor: Colors.white,
                                            icon: Icon(
                                              Icons.add_a_photo_outlined,
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              _pickImage();
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
                                      userData != null ? userData['prenom'] + ' ' + userData['nom'] : '',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      userData != null ? userData['poste'] : '',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                          ),
                                    ),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                        child: LikeButtonWidget(
                                          documentId: userData != null ? userData['id'] : '',
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
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(25.0, 20.0, 25.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.nomFamilleController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Nom de famille *',
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
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    validator: _model.nomFamilleControllerValidator.asValidator(context),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.prenomController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Prénom',
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
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    validator: _model.prenomControllerValidator.asValidator(context),
                                  ),
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
                                          child: Icon(
                                            Icons.work_outline,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 24.0,
                                          ),
                                        ),
                                        FlutterFlowDropDown<String>(
                                          controller: _model.posteValueController ??= FormFieldController<String>(userData['poste'] != null ? userData['poste'] : ''),
                                          options: ['Rayonniste', 'Conseiller', 'Préparateur', 'Apprenti', 'Etudiant pharmacie', 'Etudiant pharmacie 6ème année validée', 'Pharmacien(ne)', 'Pharmacien(ne) titulaire'],
                                          onChanged: (val) => setState(() => _model.posteValue = val),
                                          width: MediaQuery.of(context).size.width * 0.78,
                                          height: 50.0,
                                          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                          hintText: 'Poste *',
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.emailController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
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
                                      prefixIcon: Icon(
                                        Icons.mail_outline_rounded,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    validator: _model.emailControllerValidator.asValidator(context),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.telephoneController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Téléphone',
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
                                      prefixIcon: Icon(
                                        Icons.local_phone,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.number,
                                    validator: _model.telephoneControllerValidator.asValidator(context),
                                    inputFormatters: [_model.telephoneMask],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.birthDateController,
                                    onFieldSubmitted: (_) async {
                                      final _datePickedDate = await showDatePicker(
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
                                      prefixIcon: Icon(
                                        Icons.cake,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.datetime,
                                    validator: _model.birthDateControllerValidator.asValidator(context),
                                    inputFormatters: [_model.birthDateMask],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.postcodeController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Code postal *',
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
                                      prefixIcon: Icon(
                                        Icons.location_on,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.number,
                                    validator: _model.postcodeControllerValidator.asValidator(context),
                                    inputFormatters: [_model.postcodeMask],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.cityController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Ville *',
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
                                      prefixIcon: Icon(
                                        Icons.location_city,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    validator: _model.cityControllerValidator.asValidator(context),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.presentationController,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Présentation',
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
                                    validator: _model.presentationControllerValidator.asValidator(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          // height: MediaQuery.of(context).size.height * 1,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: TabBar(
                            onTap: (value) {
                              setState(() {
                                _selectedIndex = value;
                              });
                            },
                            controller: _tabController,
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
                            unselectedLabelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF595A71),
                                  fontSize: 14.0,
                                ),
                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 14.0, fontWeight: FontWeight.w600),
                            tabs: [
                              Tab(
                                text: 'Profil',
                              ),
                              Tab(
                                text: 'Réseau',
                              ),
                              Tab(
                                text: userData != null && userData['poste'] == 'Pharmacien(ne) titulaire' ? 'Offres' : 'Recherches',
                              ),
                            ],
                          ),
                        ),
                        if (_selectedIndex == 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Container(
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
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(15),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Spécialisations',
                                                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                        fontFamily: 'Poppins',
                                                        color: FlutterFlowTheme.of(context).primaryText,
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
                                                          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                          child: Padding(
                                                            padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                            child: PopupSpecialisationWidget(
                                                              onTap: (specialisation) => {providerProfilUser.addSelectedSpecialisation(specialisation)},
                                                            ),
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
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    ),
                                                    child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.vertical,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: providerProfilUser.selectedSpecialisation.length,
                                                      itemBuilder: (context, index) {
                                                        return Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              FlutterFlowIconButton(
                                                                borderColor: Colors.transparent,
                                                                borderRadius: 30,
                                                                borderWidth: 1,
                                                                buttonSize: 40,
                                                                icon: Icon(
                                                                  Icons.delete_outline_sharp,
                                                                  color: FlutterFlowTheme.of(context).alternate,
                                                                  size: 20,
                                                                ),
                                                                onPressed: () {
                                                                  providerProfilUser.deleteSelectedSpecialisation(index);
                                                                },
                                                              ),
                                                              Icon(
                                                                Icons.verified,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                size: 24,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 0.6,
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                                  child: Text(
                                                                    providerProfilUser.selectedSpecialisation[index],
                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          color: Color(0x2B1F5C67),
                                          offset: Offset(10, 10),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(15),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'LGO',
                                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: FlutterFlowTheme.of(context).primaryText,
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
                                                              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                              child: Padding(
                                                                padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                                child: PopupLgoWidget(
                                                                  onTap: (lgo) => {providerProfilUser.addSelectedLgo(lgo)},
                                                                ),
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
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: providerProfilUser.selectedLgo.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.42,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          FlutterFlowIconButton(
                                                            borderColor: Colors.transparent,
                                                            borderRadius: 30,
                                                            borderWidth: 1,
                                                            buttonSize: 40,
                                                            icon: Icon(
                                                              Icons.delete_outline_sharp,
                                                              color: FlutterFlowTheme.of(context).alternate,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              providerProfilUser.deleteSelectedLgo(index);
                                                            },
                                                          ),
                                                          Image.asset(
                                                            'assets/lgo/' + providerProfilUser.selectedLgo[index]['image'],
                                                            width: 120,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.4,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                      child: ListSkillWithSliderWidget(
                                                        slider: providerProfilUser.selectedLgo[index]['niveau'],
                                                        onChanged: (value) {
                                                          providerProfilUser.updateSelectedLgo(index, value);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          color: Color(0x2B1F5C67),
                                          offset: Offset(10, 10),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Compétences',
                                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                      fontFamily: 'Poppins',
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.coronavirus,
                                                        color: Color(0xFF595A71),
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Test COVID',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                Switch.adaptive(
                                                  value: providerProfilUser.selectedCompetences.contains('Test COVID') ? true : false,
                                                  onChanged: (newValue) async {
                                                    setState(() {
                                                      providerProfilUser.updateCompetence(newValue, 'Test COVID');
                                                    });
                                                  },
                                                  activeColor: Color(0xFF7CEDAC),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/Vaccines.svg',
                                                          width: 24,
                                                          colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                        )),
                                                    Text(
                                                      'Vaccination',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                Switch.adaptive(
                                                  value: providerProfilUser.selectedCompetences.contains('Vaccination') ? true : false,
                                                  onChanged: (newValue) async {
                                                    providerProfilUser.updateCompetence(newValue, 'Vaccination');
                                                  },
                                                  activeColor: Color(0xFF7CEDAC),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.payments_outlined,
                                                        color: Color(0xFF595A71),
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Gestion des tiers payant',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                Switch.adaptive(
                                                  value: providerProfilUser.selectedCompetences.contains('Gestion des tiers payant') ? true : false,
                                                  onChanged: (newValue) async {
                                                    providerProfilUser.updateCompetence(newValue, 'Gestion des tiers payant');
                                                  },
                                                  activeColor: Color(0xFF7CEDAC),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.science_outlined,
                                                        color: Color(0xFF595A71),
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Gestion de laboratoire',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                Switch.adaptive(
                                                  value: providerProfilUser.selectedCompetences.contains('Gestion de laboratoire') ? true : false,
                                                  onChanged: (newValue) async {
                                                    providerProfilUser.updateCompetence(newValue, 'Gestion de laboratoire');
                                                  },
                                                  activeColor: Color(0xFF7CEDAC),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/labs.svg',
                                                          width: 27,
                                                          colorFilter: ColorFilter.mode(Color(0xFF595A71), BlendMode.srcIn),
                                                        )),
                                                    Text(
                                                      'TROD',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                Switch.adaptive(
                                                  value: providerProfilUser.selectedCompetences.contains('TROD') ? true : false,
                                                  onChanged: (newValue) async {
                                                    providerProfilUser.updateCompetence(newValue, 'TROD');
                                                  },
                                                  activeColor: Color(0xFF7CEDAC),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          color: Color(0x2B1F5C67),
                                          offset: Offset(10, 10),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(15),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Langues',
                                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: FlutterFlowTheme.of(context).primaryText,
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
                                                              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                              child: Padding(
                                                                padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                                child: PopupLanguesWidget(
                                                                  onTap: (langue) => {providerProfilUser.addLangues(langue)},
                                                                ),
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
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: providerProfilUser.selectedLangues.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.4,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          FlutterFlowIconButton(
                                                            borderColor: Colors.transparent,
                                                            borderRadius: 30,
                                                            borderWidth: 1,
                                                            buttonSize: 40,
                                                            icon: Icon(
                                                              Icons.delete_outline_sharp,
                                                              color: FlutterFlowTheme.of(context).alternate,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              providerProfilUser.deleteLangues(index);
                                                            },
                                                          ),
                                                          Icon(
                                                            Icons.language_sharp,
                                                            color: Color(0xFF595A71),
                                                            size: 24,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                            child: Text(
                                                              providerProfilUser.selectedLangues[index]['name'],
                                                              overflow: TextOverflow.ellipsis,
                                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.4,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                      child: wrapWithModel(
                                                        model: _model.headerAppModel /*  _model.listSkillWithSliderModel2 */,
                                                        updateCallback: () => setState(() {}),
                                                        child: ListSkillWithSliderWidget(
                                                          slider: providerProfilUser.selectedLangues[index]['niveau'],
                                                          onChanged: (value) {
                                                            providerProfilUser.updateLangues(index, value);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          color: Color(0x2B1F5C67),
                                          offset: Offset(10, 10),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Expériences',
                                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                      fontFamily: 'Poppins',
                                                      color: FlutterFlowTheme.of(context).primaryText,
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
                                                        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                        child: Padding(
                                                          padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                          child: PopupExperiencesWidget(
                                                            onTap: (nom_pharmacie, annee_debut, annee_fin) => {providerProfilUser.addExperiences(nom_pharmacie, annee_debut, annee_fin)},
                                                          ),
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
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: providerProfilUser.selectedExperiences.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    FlutterFlowIconButton(
                                                      borderColor: Colors.transparent,
                                                      borderRadius: 30,
                                                      borderWidth: 1,
                                                      buttonSize: 40,
                                                      icon: Icon(
                                                        Icons.delete_outline_sharp,
                                                        color: FlutterFlowTheme.of(context).alternate,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        providerProfilUser.deleteExperience(index);
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                                      child: Icon(
                                                        Icons.work_outline,
                                                        color: Color(0xFF595A71),
                                                        size: 24,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      ),
                                                      child: Text(
                                                        providerProfilUser.selectedExperiences[index]['nom_pharmacie'] + ', ' + providerProfilUser.selectedExperiences[index]['annee_debut'] + '-' + providerProfilUser.selectedExperiences[index]['annee_fin'],
                                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
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
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: FFButtonWidget(
                                      onPressed: () {
                                        updateUserToFirebase(context);
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
                        if (_selectedIndex == 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
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
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xFFF2FDFF), boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                                        child: Row(
                                          children: [
                                            Icon(isExpanded_Titu ? Icons.expand_less : Icons.expand_more),
                                            Text(
                                              'Membres titulaires (' + titulairesNetwork.length.toString() + ')',
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
                                      for (var i in titulairesNetwork) CardUserWidget(data: i),
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
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xFFF2FDFF), boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                                        child: Row(
                                          children: [
                                            Icon(isExpanded_NonTitu ? Icons.expand_less : Icons.expand_more),
                                            Text(
                                              'Membres (' + nonTitulairesNetwork.length.toString() + ')',
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
                                      for (var i in nonTitulairesNetwork) CardUserWidget(data: i),
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
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xFFF2FDFF), boxShadow: [BoxShadow(color: Color(0x2b1e5b67), blurRadius: 12, offset: Offset(10, 10))]),
                                        child: Row(
                                          children: [
                                            Icon(isExpanded_Pharma ? Icons.expand_less : Icons.expand_more),
                                            Text(
                                              'Pharmacies (' + pharmaciesNetwork.length.toString() + ')',
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
                                      for (var i in pharmaciesNetwork) CardPharmacieWidget(data: i),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (_selectedIndex == 2 && recherchesUser.isNotEmpty)
                          for (var searchI in recherchesUser)
                            CardSearchProfilWidget(
                              searchI: searchI,
                            ),
                        if (_selectedIndex == 2 && offresUser.isNotEmpty)
                          for (var searchI in offresUser)
                            CardOfferProfilWidget(
                              searchI: searchI,
                            )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
