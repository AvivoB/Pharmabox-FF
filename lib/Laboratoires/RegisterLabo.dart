import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_widgets.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Laboratoire {
  final String name;
  final String code;
  final String? image;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;

  Laboratoire({
    required this.name,
    required this.code,
    this.image,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.website,
  });

  factory Laboratoire.fromJson(Map<String, dynamic> json) {
    return Laboratoire(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      image: json['image'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
    );
  }
}

class RegisterLabo extends StatefulWidget {
  const RegisterLabo({Key? key}) : super(key: key);

  @override
  State<RegisterLabo> createState() => _RegisterLaboState();
}

class _RegisterLaboState extends State<RegisterLabo> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLoadingLabos = false;
  bool _passwordVisibility = false;
  bool _confirmPasswordVisibility = false;
  bool _acceptTerms = false;
  
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;  final _unfocusNode = FocusNode();
    List<Laboratoire> _laboratoires = [];
  List<Laboratoire> _filteredLaboratoires = [];
  Laboratoire? _selectedLaboratoire;  final _searchController = TextEditingController();
  bool _showDropdown = false;
  final _laboratoireFieldKey = GlobalKey<FormFieldState>();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchLaboratoires();
  }  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _searchController.dispose();
    _unfocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLaboratoires() async {
    setState(() {
      _isLoadingLabos = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://script.google.com/macros/s/AKfycbxrqjg978ezEg4gI4lM_BPIWoS_bIay5cQItBBsBCG4AK22rE3qtcRsRiYAkiTrLT4uLw/exec'),
      );      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _laboratoires = (data as List)
              .map((item) => Laboratoire.fromJson(item))
              .toList();
          _filteredLaboratoires = List.from(_laboratoires);
        });
      } else {
        throw Exception('Erreur lors du chargement des laboratoires');
      }
    } catch (e) {
      print('Erreur API: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des laboratoires: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingLabos = false;
      });    }
  }
  void _filterLaboratoires(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLaboratoires = List.from(_laboratoires);
        _showDropdown = false;
      } else {
        _filteredLaboratoires = _laboratoires
            .where((labo) => 
                labo.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showDropdown = true;
      }
    });
  }

  void _onSearchChanged(String query) {
    // Annuler le timer précédent s'il existe
    _debounceTimer?.cancel();
    
    // Créer un nouveau timer avec un délai de 300ms
    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      _filterLaboratoires(query);
    });
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez accepter les conditions d\'utilisation')),
        );
        return;
      }

      if (_selectedLaboratoire == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez sélectionner un laboratoire')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Créer le compte Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Créer le profil utilisateur dans Firestore
        if (userCredential.user != null) {
          await _firestore.collection('laboratoires').doc(userCredential.user!.uid).set({
            'email': _emailController.text.trim(),
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'position': _positionController.text.trim(),
            'laboratoire': {
              'name': _selectedLaboratoire!.name,
              'code': _selectedLaboratoire!.code,
            },
            'userType': 'laboratoire',
            'createdAt': FieldValue.serverTimestamp(),
            'isActive': true,
          });

          // Mettre à jour le profil Firebase Auth
          await userCredential.user!.updateDisplayName(
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Inscription réussie! Bienvenue chez Pharmabox')),
          );

          // Rediriger vers l'interface laboratoire
          Navigator.of(context).pushReplacementNamed('/labo');
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Une erreur est survenue';
        
        if (e.code == 'weak-password') {
          errorMessage = 'Le mot de passe est trop faible';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Un compte existe déjà avec cet email';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Format d\'email invalide';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'inscription: ${e.toString()}')),
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
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 1.0,
                  ),
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
                    'Rejoignez notre réseau et développez\nvos relations avec les pharmacies',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 60),
                  _buildFeatureItem('Accès à un réseau de pharmacies', Icons.network_check),
                  SizedBox(height: 20),
                  _buildFeatureItem('Prennez vos commandes en direct', Icons.inventory_2),
                  SizedBox(height: 20),
                  _buildFeatureItem('Prospectez et développez votre réseau', Icons.analytics),
                  SizedBox(height: 20),
                  _buildFeatureItem('Suivi en temps réel des commandes', Icons.analytics),
                  SizedBox(height: 20),
                  _buildFeatureItem('Suivi en temps réel des commandes', Icons.analytics),
                ],
              ),
            ),
          ),
        ),
        // Côté droit - Formulaire d'inscription
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
            child: _buildRegisterForm(context),
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
      padding: EdgeInsetsDirectional.fromSTEB(25.0, 20.0, 25.0, 20.0),
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
            'Créez votre compte laboratoire',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
          SizedBox(height: 40),
          _buildRegisterForm(context),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (kIsWeb) ...[
          Text(
            'Inscription',
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Créez votre compte laboratoire',
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
            children: [              // Sélection du laboratoire avec recherche et images
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  
                ),
                child: _isLoadingLabos
                  ? Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 16),
                          Text('Chargement des laboratoires...'),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Champ de recherche
                        TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Rechercher un laboratoire',
                            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterLaboratoires('');
                                    },
                                  )
                                : null,                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                        
                        // Laboratoire sélectionné ou liste de résultats
                        if (_selectedLaboratoire != null && !_showDropdown)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                // Image du laboratoire
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    
                                  ),
                                  child: _selectedLaboratoire!.image != null && _selectedLaboratoire!.image!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            _selectedLaboratoire!.image!,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.business,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 30,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.business,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 30,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedLaboratoire!.name,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (_selectedLaboratoire!.description != null && _selectedLaboratoire!.description!.isNotEmpty)
                                        Text(
                                          _selectedLaboratoire!.description!,
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _showDropdown = true;
                                      _searchController.text = _selectedLaboratoire!.name;
                                      _filterLaboratoires(_selectedLaboratoire!.name);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        
                        // Liste des résultats de recherche
                        if (_showDropdown && _filteredLaboratoires.isNotEmpty)
                          Container(
                            constraints: BoxConstraints(maxHeight: 300),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredLaboratoires.length,
                              itemBuilder: (context, index) {
                                final labo = _filteredLaboratoires[index];
                                return ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: labo.image != null && labo.image!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              labo.image!,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.business,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    size: 25,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.business,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 25,
                                            ),
                                          ),
                                  ),
                                  title: Text(
                                    labo.name,
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  subtitle: labo.description != null && labo.description!.isNotEmpty
                                      ? Text(
                                          labo.description!,
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : null,                                  onTap: () {
                                    setState(() {
                                      _selectedLaboratoire = labo;
                                      _searchController.text = labo.name;
                                      _showDropdown = false;
                                    });
                                    // Mettre à jour la validation du FormField
                                    _laboratoireFieldKey.currentState?.didChange(labo);
                                  },
                                );
                              },
                            ),
                          ),
                        
                        // Message si aucun résultat
                        if (_showDropdown && _filteredLaboratoires.isEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Aucun laboratoire trouvé',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),                      ],
                    ),
              ),
                // Widget de validation caché pour la sélection du laboratoire
              FormField<Laboratoire>(
                key: _laboratoireFieldKey,
                initialValue: _selectedLaboratoire,
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un laboratoire';
                  }
                  return null;
                },
                builder: (FormFieldState<Laboratoire> state) {
                  return state.hasError
                      ? Padding(
                          padding: EdgeInsets.only(top: 8, left: 16),
                          child: Text(
                            state.errorText!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).error,
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
              
              SizedBox(height: 20),
              SizedBox(height: 20),
              
              // Email
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Adresse email professionnelle',
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
              
              // Mot de passe
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
                      return 'Veuillez entrer un mot de passe';
                    }
                    if (value.length < 8) {
                      return 'Le mot de passe doit contenir au moins 8 caractères';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              
              // Confirmation mot de passe
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  
                ),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Confirmez le mot de passe',
                    labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _confirmPasswordVisibility = !_confirmPasswordVisibility),
                      child: Icon(
                        _confirmPasswordVisibility ? Icons.visibility : Icons.visibility_off,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24),
              
              // Checkbox conditions d'utilisation
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    activeColor: Color(0xFF42D2FF),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'J\'accepte les ',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          TextSpan(
                            text: 'conditions d\'utilisation',
                            style: TextStyle(
                              color: Color(0xFF42D2FF),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ' et la ',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          TextSpan(
                            text: 'politique de confidentialité',
                            style: TextStyle(
                              color: Color(0xFF42D2FF),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              
              // Bouton d'inscription
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
                  onPressed: _isLoading ? null : _register,
                  text: _isLoading ? 'Inscription...' : 'Créer mon compte',
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
              
              // Lien de connexion
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Retour à la page de connexion
                },
                child: RichText(
                  text: TextSpan(
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: 'Déjà un compte? ',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      TextSpan(
                        text: 'Se connecter',
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