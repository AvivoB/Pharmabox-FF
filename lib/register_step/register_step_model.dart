import 'package:image_picker/image_picker.dart';
import 'package:pharmabox/register_step/register_provider.dart';

import '/composants/list_skill_with_slider/list_skill_with_slider_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/popups/popup_experiences/popup_experiences_widget.dart';
import '/popups/popup_langues/popup_langues_widget.dart';
import '/popups/popup_lgo/popup_lgo_widget.dart';
import '/popups/popup_specialisation/popup_specialisation_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/material.dart';

class RegisterStepModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for NomFamille widget.
  TextEditingController? nomFamilleController;
  String? Function(BuildContext, String?)? nomFamilleControllerValidator;
  // State field(s) for Prenom widget.
  TextEditingController? prenomController;
  String? Function(BuildContext, String?)? prenomControllerValidator;
  // State field(s) for Poste widget.
  String? posteValue;
  FormFieldController<String>? posteValueController;
  // State field(s) for Email widget.
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;
  // State field(s) for Telephone widget.
  TextEditingController? telephoneController;
  final telephoneMask = MaskTextInputFormatter(mask: '## ## ## ## ##');
  String? Function(BuildContext, String?)? telephoneControllerValidator;
  // State field(s) for BirthDate widget.
  TextEditingController? birthDateController;
  final birthDateMask = MaskTextInputFormatter(mask: '##/##/####');
  String? Function(BuildContext, String?)? birthDateControllerValidator;
  DateTime? datePicked;
  // State field(s) for Postcode widget.
  TextEditingController? postcodeController;
  final postcodeMask = MaskTextInputFormatter(mask: '#####');
  String? Function(BuildContext, String?)? postcodeControllerValidator;
  // State field(s) for City widget.
  TextEditingController? cityController;
  String? Function(BuildContext, String?)? cityControllerValidator;
  // State field(s) for Presentation widget.
  TextEditingController? presentationController;
  String? Function(BuildContext, String?)? presentationControllerValidator;
  // Model for ListSkillWithSlider component.
  late ListSkillWithSliderModel listSkillWithSliderModel1;
  // State field(s) for ComptencesTestCovid widget.
  bool comptencesTestCovidValue = false;
  // State field(s) for ComptencesVaccination widget.
  bool comptencesVaccinationValue = false;
  // State field(s) for ComptencesTiersPayant widget.
  bool comptencesTiersPayantValue = false;
  // State field(s) for ComptencesLabo widget.
  bool comptencesLaboValue = false;
  // State field(s) for ComptencesTROD widget.
  bool comptencesTRODValue = false;
  // Model for ListSkillWithSlider component.
  late ListSkillWithSliderModel listSkillWithSliderModel2;
  // State field(s) for AllowNotifs widget.
  bool allowNotifsValue = false;
  // State field(s) for AllowCGU widget.
  bool allowCGUValue = false;

  bool afficherEmail = true;

  bool afficherTelephone = true;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    listSkillWithSliderModel1 = createModel(context, () => ListSkillWithSliderModel());
    listSkillWithSliderModel2 = createModel(context, () => ListSkillWithSliderModel());
  }

  void dispose() {
    nomFamilleController?.dispose();
    prenomController?.dispose();
    emailController?.dispose();
    telephoneController?.dispose();
    birthDateController?.dispose();
    postcodeController?.dispose();
    cityController?.dispose();
    presentationController?.dispose();
    listSkillWithSliderModel1.dispose();
    listSkillWithSliderModel2.dispose();
  }

// Envoyer les données dans firebase
  createUserToFirebase(context, afficher_tel, afficher_email, nomFamille, prenom, poste, email, telephone, birthDate, postcode, city, presentation, comptencesTestCovid, comptencesVaccination, comptencesTiersPayant, comptencesLabo, comptencesTROD, allowNotifs, allowCGU, imageURL) {
    final providerUserRegister = Provider.of<ProviderUserRegister>(context, listen: false);

    final firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    final CollectionReference<Map<String, dynamic>> usersRef = FirebaseFirestore.instance.collection('users');

    List competences = [];

    if (comptencesTestCovid) {
      competences.add('Test COVID');
    }
    if (comptencesVaccination) {
      competences.add('Vaccination');
    }
    if (comptencesTiersPayant) {
      competences.add('Gestion des tiers payant');
    }
    if (comptencesLabo) {
      competences.add('Gestion de laboratoire');
    }
    if (comptencesTROD) {
      competences.add('TROD');
    }

    if (nomFamille != '' && prenom != '' && postcode != '' && city != '' && poste != null && allowCGU && allowNotifs) {
      usersRef.doc(currentUser?.uid).update({
        'id': currentUser?.uid,
        'nom': nomFamille,
        'prenom': prenom,
        'poste': poste,
        'email': email,
        'afficher_email': afficher_email,
        'telephone': telephone,
        'afficher_tel': afficher_tel,
        'date_naissance': birthDate,
        'code_postal': postcode,
        'city': city,
        'presentation': presentation,
        'specialisations': providerUserRegister.selectedSpecialisation,
        'lgo': providerUserRegister.selectedLgo,
        'competences': competences,
        'langues': providerUserRegister.selectedLangues,
        'experiences': providerUserRegister.selectedExperiences,
        'photoUrl': imageURL,
        'isComplete': true,
      });

      return true;
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pour continuer, vous devez compléter votre compte et vous devez accepter les CGU', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryBackground)),
          backgroundColor: redColor,
        ),
      );
    }
  }
}
