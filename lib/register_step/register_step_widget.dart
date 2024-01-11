import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmabox/custom_code/widgets/pdfViewer.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/register_step/register_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../constant.dart';
import '../custom_code/widgets/gradient_text_custom.dart';
import '../custom_code/widgets/prediction_ville.dart';
import '/auth/firebase_auth/auth_util.dart';
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
import 'register_step_model.dart';
export 'register_step_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterStepWidget extends StatefulWidget {
  const RegisterStepWidget({Key? key}) : super(key: key);

  @override
  _RegisterStepWidgetState createState() => _RegisterStepWidgetState();
}

class _RegisterStepWidgetState extends State<RegisterStepWidget> {
  late RegisterStepModel _model;
  File? image;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String? _imageURL;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterStepModel());
    var namefull = currentUserDisplayName.split(' ');
    print('heyy' +currentUserDisplayName);

    _model.nomFamilleController ??= TextEditingController(text: namefull.last);
    _model.prenomController ??= TextEditingController(text: namefull.first);
    _model.emailController ??= TextEditingController(text: currentUserEmail);
    _model.telephoneController ??= TextEditingController();
    _model.birthDateController ??= TextEditingController();
    _model.postcodeController ??= TextEditingController();
    _model.cityController ??= TextEditingController();
    _model.presentationController ??= TextEditingController();
    _imageURL = 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage({required ImageSource source}) async {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(toolbarTitle: 'Redimensionner l\'image', toolbarColor: blueColor, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
            IOSUiSettings(
              title: 'Redimensionner l\'image',
            ),
          ],
        );

        if (croppedImage != null) {
          setState(() {
            _image = File(croppedImage.path);
            _isLoading = true;
          });

          final Reference storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${DateTime.now()}.png');
          final UploadTask uploadTask = storageRef.putFile(_image!);
          final TaskSnapshot downloadUrl = (await uploadTask);

          String url = (await downloadUrl.ref.getDownloadURL());

          setState(() {
            _isLoading = false;
            _imageURL = url;
          });
        }
      }
    }

    void _showPickSourceDialog(BuildContext context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choisir une image depuis la gallerie', style: FlutterFlowTheme.of(context).bodyMedium),
                      onTap: () {
                        Navigator.of(context).pop(); // Fermer le BottomSheet
                        _pickImage(source: ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Prendre une photo avec la caméra', style: FlutterFlowTheme.of(context).bodyMedium),
                      onTap: () {
                        Navigator.of(context).pop(); // Fermer le BottomSheet
                        _pickImage(source: ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    var widget_context_provider = context;

    final providerUserRegister = Provider.of<ProviderUserRegister>(context);

    if (_isLoading) {
      return ProgressIndicatorPharmabox();
    } else {
      return Consumer<ProviderUserRegister>(builder: (context, userRegisterSate, child) {
        return WillPopScope(
          onWillPop: () async {
            // Retourner 'false' pour empêcher le retour en arrière
            return Future.value(false);
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Color(0xFFEFF6F7),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                            stops: [0, 0.5, 1],
                            begin: AlignmentDirectional(1, 0.34),
                            end: AlignmentDirectional(-1, -0.34),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                height: 150,
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 1),
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Color(0x00FFFFFF),
                                        borderRadius: BorderRadius.circular(95),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: _imageURL! != null
                                              ? Image.network(
                                                  _imageURL!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset('assets/images/Group_18.png'),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0.65, 1),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30,
                                        borderWidth: 1,
                                        buttonSize: 60,
                                        fillColor: Colors.white,
                                        icon: Icon(
                                          Icons.add_a_photo_outlined,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          _showPickSourceDialog(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Text(
                                  'Les profils avec photo ont 80% de vues en plus',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.nomFamilleController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Nom de famille *',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.prenomController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Prénom *',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Color(0xFFD0D1DE),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                              child: Icon(
                                                Icons.work_outline,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24,
                                              ),
                                            ),
                                            FlutterFlowDropDown<String>(
                                              controller: _model.posteValueController ??= FormFieldController<String>(null),
                                              options: ['Rayonniste', 'Conseiller', 'Préparateur', 'Apprenti', 'Etudiant pharmacie', 'Etudiant pharmacie 6ème année validée', 'Pharmacien', 'Pharmacien titulaire'],
                                              onChanged: (val) => setState(() => _model.posteValue = val),
                                              width: MediaQuery.of(context).size.width * 0.78,
                                              height: 50,
                                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black,
                                                  ),
                                              hintText: 'Poste',
                                              fillColor: Colors.white,
                                              elevation: 2,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0,
                                              borderRadius: 0,
                                              margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                                              hidesUnderline: true,
                                              isSearchable: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.emailController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.telephoneController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Téléphone',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.local_phone,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        keyboardType: TextInputType.number,
                                        validator: _model.telephoneControllerValidator.asValidator(context),
                                        // inputFormatters: [_model.telephoneMask],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        controller: _model.birthDateController,
                                        readOnly: true,
                                        onTap: () async {
                                          final _datePickedDate = await showDatePicker(context: context, initialDate: getCurrentTimestamp, firstDate: DateTime(1900), lastDate: getCurrentTimestamp, keyboardType: TextInputType.url);

                                          if (_datePickedDate != null) {
                                            setState(() {
                                              _model.datePicked = DateTime(
                                                _datePickedDate.year,
                                                _datePickedDate.month,
                                                _datePickedDate.day,
                                              );

                                              _model.birthDateController.text = _datePickedDate.day.toString().padLeft(2, '0') + '/' + _datePickedDate.month.toString().padLeft(2, '0') + '/' + _datePickedDate.year.toString();
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
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
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
                                    PredictionVille(onPlaceSelected: (ville) {
                                      _model.cityController.text = ville['city'].toString();
                                      _model.countryController = ville['country'].toString();

                                      print(ville);
                                    }),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _model.presentationController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Présentation',
                                          hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFD0D1DE),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).focusColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        validator: _model.presentationControllerValidator.asValidator(context),
                                      ),
                                    ),
                                    Text('Séléctionnez si vous souhaitez être contacté par téléphone ou E-mail.', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12)),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                                                  Icons.phone,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Afficher mon numéro de téléphone',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.afficherTelephone ??= false,
                                            onChanged: (newValue) async {
                                              setState(() => _model.afficherTelephone = newValue);
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
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
                                                  Icons.email_outlined,
                                                  color: Color(0xFF595A71),
                                                  size: 28,
                                                ),
                                              ),
                                              Text(
                                                'Afficher mon E-mail',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Switch.adaptive(
                                            value: _model.afficherEmail ??= false,
                                            onChanged: (newValue) async {
                                              setState(() {
                                                _model.afficherEmail = newValue;
                                              });
                                            },
                                            activeColor: Color(0xFF7CEDAC),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
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
                            width: 100,
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
                                            enableDrag: true,
                                            context: context,
                                            builder: (bottomSheetContext) {
                                              return GestureDetector(
                                                onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                child: Padding(
                                                  padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                  child: PopupSpecialisationWidget(onTap: (specialisation) => {userRegisterSate.addSelectedSpecialisation(specialisation)}),
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
                                            itemCount: providerUserRegister.selectedSpecialisation.length,
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
                                                        userRegisterSate.deleteSelectedSpecialisation(index);
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
                                                          userRegisterSate.selectedSpecialisation[index],
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
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
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
                                                enableDrag: true,
                                                context: context,
                                                builder: (bottomSheetContext) {
                                                  return GestureDetector(
                                                    onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                    child: Padding(
                                                      padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                      child: PopupLgoWidget(
                                                        onTap: (lgo) => {userRegisterSate.addSelectedLgo(lgo)},
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) => setState(() {}));
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 30,
                                              child: custom_widgets.GradientTextCustom(
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
                                    itemCount: userRegisterSate.selectedLgo.length,
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
                                                    userRegisterSate.deleteSelectedLgo(index);
                                                  },
                                                ),
                                                Image.asset(
                                                  'assets/lgo/' + userRegisterSate.selectedLgo[index]['image'],
                                                  width: 80,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                                // Padding(
                                                //   padding: EdgeInsetsDirectional
                                                //       .fromSTEB(5, 0, 0, 0),
                                                //   child: Text(
                                                //     userRegisterSate
                                                //         .selectedLgo[index]['name'],
                                                //     style:
                                                //         FlutterFlowTheme.of(context)
                                                //             .bodyMedium
                                                //             .override(
                                                //               fontFamily: 'Poppins',
                                                //               fontSize: 13,
                                                //               color:
                                                //                   Color(0xFF595A71),
                                                //             ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: wrapWithModel(
                                              model: _model.listSkillWithSliderModel1,
                                              updateCallback: () {
                                                print(_model.listSkillWithSliderModel1);
                                              },
                                              child: ListSkillWithSliderWidget(
                                                slider: 1,
                                                onChanged: (value) {
                                                  userRegisterSate.updateSelectedLgo(index, value);
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
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 100,
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
                                          value: _model.comptencesTestCovidValue ??= false,
                                          onChanged: (newValue) async {
                                            setState(() => _model.comptencesTestCovidValue = newValue);
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
                                          value: _model.comptencesVaccinationValue ??= false,
                                          onChanged: (newValue) async {
                                            setState(() => _model.comptencesVaccinationValue = newValue);
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
                                          value: _model.comptencesTiersPayantValue ??= false,
                                          onChanged: (newValue) async {
                                            setState(() => _model.comptencesTiersPayantValue = newValue);
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
                                          value: _model.comptencesLaboValue ??= false,
                                          onChanged: (newValue) async {
                                            setState(() => _model.comptencesLaboValue = newValue);
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
                                          value: _model.comptencesTRODValue ??= false,
                                          onChanged: (newValue) async {
                                            setState(() => _model.comptencesTRODValue = newValue);
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
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
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
                                                enableDrag: true,
                                                context: context,
                                                builder: (bottomSheetContext) {
                                                  return GestureDetector(
                                                    onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                    child: Padding(
                                                      padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                      child: PopupLanguesWidget(
                                                        onTap: (langue) {
                                                          userRegisterSate.addLangues(langue);
                                                        },
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
                                    itemCount: userRegisterSate.selectedLangues.length,
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
                                                    userRegisterSate.deleteLangues(index);
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
                                                    userRegisterSate.selectedLangues[index]['name'],
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
                                              model: _model.listSkillWithSliderModel2,
                                              updateCallback: () => setState(() {}),
                                              child: ListSkillWithSliderWidget(
                                                slider: 0,
                                                onChanged: (value) {
                                                  userRegisterSate.updateLangues(index, value);
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
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 100,
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
                                            enableDrag: true,
                                            context: context,
                                            builder: (bottomSheetContext) {
                                              return GestureDetector(
                                                onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
                                                child: Padding(
                                                  padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                  child: PopupExperiencesWidget(
                                                    onTap: (nom_pharmacie, annee_debut, annee_fin) => {userRegisterSate.addExperiences(nom_pharmacie, annee_debut, annee_fin)},
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          child: custom_widgets.GradientTextCustom(
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
                                    itemCount: userRegisterSate.selectedExperiences.length,
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
                                                userRegisterSate.deleteExperience(index);
                                                print(userRegisterSate.selectedExperiences[index]);
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
                                                userRegisterSate.selectedExperiences[index]['nom_pharmacie'] + ', ' + userRegisterSate.selectedExperiences[index]['annee_debut'] + '-' + userRegisterSate.selectedExperiences[index]['annee_fin'],
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
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
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
                          child: Container(
                            width: 100,
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.70,
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                        ),
                                        child: TextButton(
                                          onPressed: () async {
                                            await launch('https://www.pharma-box.fr/mentions-legales-application.html');
                                          },
                                          child: Text(
                                            'J\'accepte les conditions générales d\'utilisation  cliquez ici pour les consulter',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Switch.adaptive(
                                        value: _model.allowCGUValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(() => _model.allowCGUValue = newValue);
                                        },
                                        activeColor: Color(0xFF7CEDAC),
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
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x301F5C67),
                                offset: Offset(0, 4),
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                              stops: [0, 1],
                              begin: AlignmentDirectional(1, -1),
                              end: AlignmentDirectional(-1, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await Future.delayed(Duration(seconds: 2));
                              var send_data = RegisterStepModel().createUserToFirebase(widget_context_provider, _model.afficherTelephone, _model.afficherEmail, _model.nomFamilleController.text, _model.prenomController.text, _model.posteValue, _model.emailController.text, _model.telephoneController.text, _model.birthDateController.text,
                                  _model.cityController.text, _model.countryController, _model.presentationController.text, _model.comptencesTestCovidValue, _model.comptencesVaccinationValue, _model.comptencesTiersPayantValue, _model.comptencesLaboValue, _model.comptencesTRODValue, _model.allowNotifsValue, _model.allowCGUValue, _imageURL!);
                              if (send_data) {
                                // setState(() {
                                //   _isLoading = true;
                                // });

                                if (_model.posteValue == 'Pharmacien titulaire') {
                                  context.pushNamed('RegisterPharmacy',
                                      params: {
                                        'titulaire': serializeParam(
                                          _model.nomFamilleController.text + ' ' + _model.prenomController.text,
                                          ParamType.String,
                                        ),
                                        'countryCode': serializeParam(
                                          _model.countryController,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls);
                                } else {
                                  context.pushNamed('ValidateAccount');
                                }
                              }
                            },
                            text: 'Créer mon compte',
                            options: FFButtonOptions(
                              elevation: 0,
                              width: double.infinity,
                              height: 40,
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: Color(0x00FFFFFF),
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }
  }
}
