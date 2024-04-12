import 'package:pharmabox/auth/firebase_auth/apple_auth.dart';
import 'package:pharmabox/auth/firebase_auth/email_auth.dart';
import 'package:pharmabox/auth/firebase_auth/google_auth.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/input.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_drop_down.dart';
import 'package:pharmabox/flutter_flow/form_field_controller.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'register_model.dart';
export 'register_model.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  late RegisterModel _model;

  String typeConnexion = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterModel());

    _model.emailController ??= TextEditingController();
    _model.motdepasseController ??= TextEditingController();
    _model.nomController ??= TextEditingController();
    _model.prenomController ??= TextEditingController();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 25.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(child: Image.asset('assets/icons/logo-pharma-box.png', width: 30), borderRadius: BorderRadius.circular(10.0)),
                                  SizedBox(height: 10, width: 10),
                                  Text('Pharma-Box', style: FlutterFlowTheme.of(context).displaySmall),
                                ],
                              ),
                            ),
                            Text(
                              'Créez votre compte Pharma-Box et rejoignez un réseau dédié à la pharmacie',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(typeConnexion == '')
                            Text('En Pharmacie vous êtes ...', style: FlutterFlowTheme.of(context).displaySmall),
                            if(typeConnexion == '')
                            SizedBox(height: 10, width: 10),
                            if(typeConnexion == '')
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
                                      controller: _model.posteValueController ??= FormFieldController<String>(''),
                                      options: ['Rayonniste', 'Conseiller', 'Préparateur', 'Apprenti', 'Etudiant pharmacie', 'Etudiant pharmacie 6ème année validée', 'Pharmacien', 'Pharmacien titulaire'],
                                      onChanged: (val) => setState(() => _model.posteValue = val),
                                      width: MediaQuery.of(context).size.width * 0.78,
                                      height: 50,
                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                      hintText: 'Sélectionnez votre poste',
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
                            if(typeConnexion == '')
                            Text('Comment créer votre compte ?', style: FlutterFlowTheme.of(context).displaySmall),
                            SizedBox(height: 10, width: 10),
                            if(typeConnexion == '')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    if(_model.posteValue == '') {
                                      showCustomSnackBar(context, 'Veuillez sélectionner votre poste', isError: true);
                                    }else {
                                      typeConnexion = 'email';
                                    }
                                  }),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.28,
                                    decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Color(0xFFD0D1DE),
                                    ),
                                  ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                      child: Column(
                                        children: [
                                         Image.asset('assets/images/Mail.png', width: 80,),
                                          SizedBox(height: 10),
                                          Text('Par E-mail', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                            fontSize: 10
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print('Poste : ${_model.posteValue}');
                                    if(_model.posteValue == '') {
                                      showCustomSnackBar(context, 'Veuillez sélectionner votre poste', isError: true);
                                    } else {
                                        final user = await createAccountWithGoogle(
                                          context,
                                          _model.posteValue ?? 'Pharmacien',
                                        );
                                        if (user == null) {
                                          return;
                                        }
                                                        
                                        if(_model.posteValue != null && _model.posteValue == 'Pharmacien titulaire') {
                                          context.pushNamed('RegisterPharmacy', queryParameters: {'titulaire': _model.nomController.text + ' ' + _model.prenomController.text});
                                        } else {
                                          context.pushNamed('Explorer');
                                        }
                                    }
                                        
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.28,
                                    decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Color(0xFFD0D1DE),
                                    ),
                                  ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Image.asset('assets/images/Google.png', width: 50,),
                                          ),
                                          SizedBox(height: 10),
                                          Text('Avec Google', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                            fontSize: 10
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print('Poste : ${_model.posteValue}');
                                    if(_model.posteValue == '') {
                                      showCustomSnackBar(context, 'Veuillez sélectionner votre poste', isError: true);
                                    } else {
                                      final user = await signInWithApple(
                                          context,
                                          _model.posteValue ?? 'Pharmacien',
                                        );
                                        if (user == null) {
                                          return;
                                        }

                                        if(_model.posteValue != null && _model.posteValue == 'Pharmacien titulaire') {
                                          context.pushNamed('RegisterPharmacy');
                                        } else {
                                          context.pushNamed('Explorer');
                                        }
                                    }
                                        
               
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.28,
                                    decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Color(0xFFD0D1DE),
                                    ),
                                  ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Image.asset('assets/images/AppleConnect.png', width: 50,),
                                          ),
                                          SizedBox(height: 10),
                                          Text('Avec Apple', style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                            fontSize: 10
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if(typeConnexion == 'email')
                            Column(
                              children: [
                                Input(controller: _model.nomController, label: 'Nom'),
                                Input(controller: _model.prenomController, label: 'Prénom'),
                                Input(controller: _model.emailController, label: 'Email'),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                  child: TextFormField(
                                    controller: _model.motdepasseController,
                                    obscureText: !_model.motdepasseVisibility,
                                    decoration: InputDecoration(
                                      labelText: 'Mot de passe',
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
                                          color: Color(0xFF42D2FF),
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
                                      suffixIcon: InkWell(
                                        onTap: () => setState(
                                          () => _model.motdepasseVisibility = !_model.motdepasseVisibility,
                                        ),
                                        focusNode: FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.motdepasseVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          color: Color(0xFF757575),
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    validator: _model.motdepasseControllerValidator.asValidator(context),
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
                                      onPressed: () async {
                                        print('Nom : ${_model.nomController.text}');
                                        print('Prenom : ${_model.prenomController.text}');
                                        final user = await createAccountWithEmail(
                                          context,
                                          _model.emailController.text,
                                          _model.motdepasseController.text,
                                          _model.nomController.text,
                                          _model.prenomController.text,
                                          _model.posteValue ?? 'Pharmacien',
                                        );
                                        if (user == null) {
                                          return;
                                        }
                                                        
                                        if(_model.posteValue != null && _model.posteValue == 'Pharmacien titulaire') {
                                          context.pushNamed('RegisterPharmacy');
                                        } else {
                                          context.pushNamed('Explorer');
                                        }
                                      },
                                      text: 'S\'enregistrer',
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
                          ],
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed('Login');
                          },
                          text: 'Avez-vous déjà un compte? Me connecter',
                          options: FFButtonOptions(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: Color(0x004B39EF),
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context).focusColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
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
      ),
    );
  }
}
