import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_model.dart';
import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_widget.dart';
import 'package:pharmabox/reseau/reseau_model.dart';

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
  const ReseauImportFromPhone({Key? key}) : super(key: key);

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
    return cleaned.replaceAllMapped(
        RegExp(r"(\d{2})(?=\d{1,8})"), (match) => "${match.group(1)} ");
  }

  Future<List<String>> fetchContactsEmails() async {
    List<String> emails = [];

    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
      if (permission != PermissionStatus.granted) {
        return emails; // Return empty list if permission not granted
      }
    }

    List<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    for (Contact contact in contacts) {
      if (contact.emails != null) {
        for (Item email in contact.phones!) {
          if (email.value != null) {
            emails.add(formatNumber(email.value!));
          }
        }
      }
    }

    return emails;
  }

  Future<List<DocumentSnapshot>> fetchUsersByPhone(
      List<String> phoneNumbers) async {
    final firestore = FirebaseFirestore.instance;

    if (phoneNumbers.isEmpty) {
      return []; // Return empty list if no phone numbers are provided
    }

    // Segment the list into chunks of 10 due to Firestore limitations
    final chunks = [];
    for (var i = 0; i < phoneNumbers.length; i += 10) {
      chunks.add(phoneNumbers.sublist(
          i, i + 10 > phoneNumbers.length ? phoneNumbers.length : i + 10));
    }

    final List<DocumentSnapshot> users = [];
    for (var chunk in chunks) {
      final querySnapshot = await firestore
          .collection('users')
          .where('telephone', whereIn: chunk)
          .get();

      users.addAll(querySnapshot.docs);
    }

    return users;
  }

  Future<List> fetchAndDisplayUsers() async {
    setState(() {
      _isLoading = true;
    });
    final phoneNumbers = await fetchContactsEmails();
    final users = await fetchUsersByPhone(phoneNumbers);

    for (var user in users) {
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      data['userId'] = user.id;
      _usersFounded.add(data);
      print(_usersFounded.toString());
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReseauModel());
    fetchContactsEmails().then((emails) => _contacts = emails);
    fetchAndDisplayUsers().then((value) => print(value));
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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 15.0, 15.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Importer depuis le répertoire',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(15),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tout séléctionner', style: TextStyle(
                                    color: Color(0xFF42D2FF),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),),
                                  for (var contact in _usersFounded)
                                    GestureDetector(
                                      onTap: () {
                                        selectUserToAdd(
                                            contact['userId'].toString());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Container(
                                          decoration:   
                                          ShapeDecoration(
                                            color: _userSelected.contains(contact['userId']) ? Color(0xFFEFF6F7) : Colors.white,
                                            shape: _userSelected.contains(contact['userId']) ? RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFF42D2FF)),
              borderRadius: BorderRadius.circular(5),
            ) : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5, 10, 5, 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 10.0, 0.0),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      image:
                                                          contact['photoUrl'],
                                                      placeholder:
                                                          'assets/images/Group_18.png',
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                            'assets/images/Group_18.png');
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          contact['telephone'],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
                                                        ),
                                                        Text(
                                                          contact['nom'] +
                                                              ' ' +
                                                              contact['prenom'],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
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
