import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_widgets.dart';
import 'package:http/http.dart' as http;

class ValidateAccount extends StatefulWidget {
  @override
  _ValidateAccountState createState() => _ValidateAccountState();
}

class _ValidateAccountState extends State<ValidateAccount> {
  bool _isLoading = false;
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  Map<dynamic, String> _resendMessage = {};

  Future<bool> isVerificationCodeValid() async {
    await Future.delayed(Duration(seconds: 2));
    // Concaténez les valeurs des contrôleurs pour obtenir le code saisi par l'utilisateur
    String enteredCode = _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text;

    String currentUserId = await getCurrentUserId();

    // Obtenez le document de l'utilisateur actuel
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    // Vérifiez si le document existe et comparez les codes
    if (userDoc.exists && userDoc.data() != null) {
      if ((userDoc.data()! as Map<String, dynamic>)['verificationCode']
              .toString() ==
          enteredCode) {
        // Mettez à jour les champs isVerified et isValid à true pour cet utilisateur
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .update({'isVerified': true, 'isValid': true});

        return true; // le code est correct
      }
    }
    return false; // le code est incorrect ou les données n'existent pas
  }

  Future<bool> _sendCodeVerification() async {
    String currentUserId = await getCurrentUserId();
    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-pharmaff-dab40.cloudfunctions.net/sendCodeVerification'),
        body: {'userId': currentUserId},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Erreur lors de l\'appel de la fonction: $error');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _sendCodeVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/logo-pharma-box.png', width: 30),
                    SizedBox(height: 10, width: 10),
                    Text('Validation de votre compte',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 50, width: 100),
                Text(
                    'Afin de valider votre compte, merci d\'entrer le code reçu par email',
                    style: FlutterFlowTheme.of(context).bodySmall,
                    textAlign: TextAlign.center),
                SizedBox(height: 50, width: 100),
                if (_resendMessage.isNotEmpty)
                  Text(_resendMessage['message'].toString(),
                      style: FlutterFlowTheme.of(context).bodySmall,
                      textAlign: TextAlign.center),
                if (_resendMessage.isNotEmpty) SizedBox(height: 50, width: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildCodeBox(_controller1),
                    _buildCodeBox(_controller2),
                    _buildCodeBox(_controller3),
                    _buildCodeBox(_controller4),
                  ],
                ),
                SizedBox(height: 50, width: 100),
                TextButton(
                    onPressed: () async {
                      if (await _sendCodeVerification()) {
                        setState(() {
                          _resendMessage = {
                            'type': 'success',
                            'message': 'Votre nouveau code vous a été envoyé'
                          };
                        });
                      } else {
                        setState(() {
                          _resendMessage = {
                            'type': 'error',
                            'message': 'Error d\'envoi du code de validation'
                          };
                        });
                      }
                    },
                    child: Text('Code non reçu ? Renvoyer le code',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Poppins',
                              color: blueColor,
                              fontSize: 14,
                            ))),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 10, 25, 10),
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
                        if (await isVerificationCodeValid()) {
                          context.pushNamed('Explorer');
                        } else {
                          // Le code est incorrect
                          return ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Le code est incorrect, merci d\'entrer un code valide',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground)),
                              backgroundColor: redColor,
                            ),
                          );
                        }
                      },
                      text: 'Vérifier mon compte',
                      options: FFButtonOptions(
                        elevation: 0,
                        width: double.infinity,
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0x00FFFFFF),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
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
    );
  }

  Widget _buildCodeBox(TextEditingController controller) {
    return Container(
      width: 50,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: FlutterFlowTheme.of(context).bodyMedium,
        decoration: InputDecoration(
          counterText: "", // Pour cacher le compteur de caractères
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyColor, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blueColor, width: 4),
          ),
        ),
        onChanged: (value) {
          // Passer au champ suivant après la saisie
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
