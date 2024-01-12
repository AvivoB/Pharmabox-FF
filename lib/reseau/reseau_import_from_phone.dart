import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_model.dart';
import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_widget.dart';
import 'package:pharmabox/reseau/reseau_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../constant.dart';
import '/composants/card_pharmacie/card_pharmacie_widget.dart';
import '/composants/card_user/card_user_widget.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:contacts_service/contacts_service.dart';

class ReseauImportFromPhone extends StatefulWidget {
  ReseauImportFromPhone({Key? key, String? type})
      : this.type = type ?? '',
        super(key: key);
  final String type;

  @override
  _ReseauImportFromPhoneState createState() => _ReseauImportFromPhoneState();
}

class _ReseauImportFromPhoneState extends State<ReseauImportFromPhone> {
  late ReseauModel _model;
  final _unfocusNode = FocusNode();
  List<String> _contacts = [];
  List _usersFounded = [];
  bool _isLoading = false;
  List<String> _userSelected = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String formatNumber(String number) {
    String cleaned = number.replaceAll(' ', '').replaceFirst('+33', '0');
    return cleaned.replaceAllMapped(RegExp(r"(\d{2})(?=\d{1,8})"), (match) => "${match.group(1)} ");
  }

  Future<List<String>> fetchContactsPhoneNumbers() async {
    Set<String> uniquePhoneNumbers = Set<String>();

    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
      if (permission != PermissionStatus.granted) {
        return uniquePhoneNumbers.toList(); // Return empty list if permission not granted
      }
    }

    List<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    for (Contact contact in contacts) {
      if (contact.phones != null) {
        for (Item phoneNumber in contact.phones!) {
          if (phoneNumber.value != null) {
            uniquePhoneNumbers.add(formatNumber(phoneNumber.value!));
          }
        }
      }
    }

    return uniquePhoneNumbers.toList();
  }

  Future<List<String>> fetchContactsEmails() async {
    Set<String> uniqueEmail = Set<String>();

    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
      if (permission != PermissionStatus.granted) {
        return uniqueEmail.toList(); // Return empty list if permission not granted
      }
    }

    List<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    for (Contact contact in contacts) {
      if (contact.emails != null) {
        for (Item email in contact.emails!) {
          if (email.value != null) {
            uniqueEmail.add(email.value!);
          }
        }
      }
    }

    return uniqueEmail.toList();
  }

  Future<List<DocumentSnapshot>> fetchUsersByPhone(List<String> phoneNumbers) async {
    final firestore = FirebaseFirestore.instance;

    if (phoneNumbers.isEmpty) {
      return []; // Return empty list if no phone numbers are provided
    }

    // Segment the list into chunks of 10 due to Firestore limitations
    final chunks = [];
    for (var i = 0; i < phoneNumbers.length; i += 10) {
      chunks.add(phoneNumbers.sublist(i, i + 10 > phoneNumbers.length ? phoneNumbers.length : i + 10));
    }

    final List<DocumentSnapshot> users = [];
    for (var chunk in chunks) {
      final querySnapshot = await firestore.collection('users').where('telephone', whereIn: chunk).get();

      users.addAll(querySnapshot.docs);
    }

    return users;
  }

  Future<List<DocumentSnapshot>> fetchUsersByEmails(List<String> emails) async {
    final firestore = FirebaseFirestore.instance;

    if (emails.isEmpty) {
      return []; // Return empty list if no phone numbers are provided
    }

    // Segment the list into chunks of 10 due to Firestore limitations
    final chunks = [];
    for (var i = 0; i < emails.length; i += 10) {
      chunks.add(emails.sublist(i, i + 10 > emails.length ? emails.length : i + 10));
    }

    final List<DocumentSnapshot> users = [];
    for (var chunk in chunks) {
      final querySnapshot = await firestore.collection('users').where('email', whereIn: chunk).get();

      users.addAll(querySnapshot.docs);
    }

    return users;
  }

  Future<List> fetchAndDisplayUsers() async {
    setState(() {
      _isLoading = true;
    });

    var users;

    if (widget.type == 'phone') {
      final phoneNumbers = await fetchContactsPhoneNumbers();
      users = await fetchUsersByPhone(phoneNumbers);
    }

    if (widget.type == 'email') {
      final emails = await fetchContactsEmails();
      users = await fetchUsersByEmails(emails);
    }

    for (var user in users) {
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      data['userId'] = user.id;
      print(data);
      if (!_usersFounded.contains(data['userId'])) {
        _usersFounded.add(data);
      }
    }

    setState(() {
      _isLoading = false;
    });
    return users;
    // Update your widget's state or display the data as needed
  }

  void selectUserToAdd(user) {
    if (_userSelected.contains(user)) {
      _userSelected.remove(user);
    } else {
      _userSelected.add(user);
    }
    setState(() {});
  }

  void _selectAllUsers() {
    for (var _user in _usersFounded) {
      _userSelected.add(_user['userId']);
    }
    setState(() {});
  }

  Future<void> _addToNetwork() async {
    setState(() {
      _isLoading = true;
    });
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference usersRef = _firestore.collection('users');
    final currentUserId = await getCurrentUserId();
    // 1. Loop through the _userSelected list
    for (String userId in _userSelected) {
      // 2. Fetch the corresponding document and update
      await usersRef.doc(userId).update({
        'reseau': FieldValue.arrayUnion([currentUserId])
      });
    }

    // 3. Update the current user's document with the entire _userSelected list
    await usersRef.doc(currentUserId).update({
      'reseau': FieldValue.arrayUnion(_userSelected) // Add the entire list to the reseau field
    });
    setState(() {
      _isLoading = false;
    });
    context.pushNamed('Reseau');
    showCustomSnackBar(context, 'Vos contacts ont été importé');
  }

  @override
  void initState() {
    print('TYPE PARAM / ' + widget.type);
    super.initState();
    _model = createModel(context, () => ReseauModel());
    fetchAndDisplayUsers().then((value) => print('CONTACT FOUND / ' + value.toString()));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ProgressIndicatorPharmabox();
    } else {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.headerAppModel,
                updateCallback: () => setState(() {}),
                child: HeaderAppWidget(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Importer depuis le répertoire',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if(_usersFounded.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Aucun contact de votre répertoire ne fait partie du réseau Pharmabox',
                          style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: FlutterFlowTheme.of(context).primaryText, fontSize: 18, ),
                        ),
                      ),
                      if(_usersFounded.isNotEmpty)
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _selectAllUsers();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check, // This is just an example icon, you can choose any other icon
                                              color: blueColor,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Tout séléctionner', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: blueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _addToNetwork();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 2.0,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: GradientText(
                                              'Ajouter',
                                              radius: 5.0,
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),
                                              colors: [Color(0xff7CEDAC), Color(0xFF42D2FF)],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  for (var contact in _usersFounded)
                                    GestureDetector(
                                      onTap: () {
                                        selectUserToAdd(contact['userId'].toString());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            color: _userSelected.contains(contact['userId']) ? Color(0xFFEFF6F7) : Colors.white,
                                            shape: _userSelected.contains(contact['userId'])
                                                ? RoundedRectangleBorder(
                                                    side: BorderSide(width: 1, color: Color(0xFF42D2FF)),
                                                    borderRadius: BorderRadius.circular(5),
                                                  )
                                                : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x261F5C67),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(5, 10, 5, 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: FadeInImage.assetNetwork(
                                                      image: contact['photoUrl'],
                                                      placeholder: 'assets/images/Group_18.png',
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder: (context, error, stackTrace) {
                                                        return Image.asset('assets/images/Group_18.png');
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          widget.type == 'phone' ? contact['telephone'] : contact['email'],
                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                        ),
                                                        Text(
                                                          contact['nom'] + ' ' + contact['prenom'],
                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
