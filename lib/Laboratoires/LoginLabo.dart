import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_widgets.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginLabo extends StatefulWidget {
  const LoginLabo({Key? key}) : super(key: key);

  @override
  State<LoginLabo> createState() => _LoginLaboState();
}

class _LoginLaboState extends State<LoginLabo> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisibility = false;
  final _auth = FirebaseAuth.instance;
  final _unfocusNode = FocusNode();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Firebase authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
          // Navigate to labo home screen after successful login
        if (userCredential.user != null) {
          // TODO: Rediriger vers l'interface laboratoire
          Navigator.of(context).pushReplacementNamed('/labo');
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Une erreur est survenue';
        
        if (e.code == 'user-not-found') {
          errorMessage = 'Aucun utilisateur trouvé pour cet email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Mot de passe incorrect';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Format d\'email invalide';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'Ce compte a été désactivé';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: kIsWeb 
                    ? _buildWebLayout(context)
                    : _buildMobileLayout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Row(
      children: [
        // Côté gauche - Illustration/Branding
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                stops: [0.0, 1.0],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PharmaboxLogo(width: 80),
                  SizedBox(height: 30),
                  Text(
                    'Pharmabox',
                    style: FlutterFlowTheme.of(context).displayMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Laboratoire',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Gérez votre réseau de pharmacies\net optimisez vos relations commerciales',                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 60),
                  _buildFeatureItem('Gestion de catalogue produits', Icons.inventory_2),
                  SizedBox(height: 20),
                  _buildFeatureItem('Suivi des commandes', Icons.analytics),
                  SizedBox(height: 20),
                  _buildFeatureItem('Réseau pharmacies partenaires', Icons.people),
                ],
              ),
            ),
          ),
        ),
        // Côté droit - Formulaire de connexion
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
            child: _buildLoginForm(context),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(25.0, 0.0, 25.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PharmaboxLogo(width: 80),
          SizedBox(height: 20),
          Text(
            'Pharmabox Laboratoire',
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Connectez-vous à votre espace laboratoire',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
          SizedBox(height: 40),
          _buildLoginForm(context),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (kIsWeb) ...[
          Text(
            'Connexion',
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Accédez à votre espace laboratoire',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 40),
        ],
        Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ Email
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Adresse email',
                    labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              // Champ Mot de passe
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _passwordVisibility = !_passwordVisibility),
                      child: Icon(
                        _passwordVisibility ? Icons.visibility : Icons.visibility_off,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              // Mot de passe oublié
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigation vers la récupération de mot de passe
                  },
                  child: Text(
                    'Mot de passe oublié?',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFF42D2FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              // Bouton de connexion
              Container(
                width: double.infinity,
                height: 55.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
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
                  onPressed: _isLoading ? null : _login,
                  text: _isLoading ? 'Connexion...' : 'Se connecter',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 55.0,
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
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Lien d'inscription
              TextButton(
                onPressed: () {
                  // TODO: Navigation vers l'inscription laboratoire
                },
                child: RichText(
                  text: TextSpan(
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Pas encore de compte? ',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      TextSpan(
                        text: 'Créer un compte',
                        style: TextStyle(
                          color: Color(0xFF42D2FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}