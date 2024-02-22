import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmabox/auth/firebase_auth/auth_util.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_model.dart';
import 'package:pharmabox/popups/popup_import_contact/popup_import_contact_widget.dart';

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
import 'reseau_model.dart';
export 'reseau_model.dart';

class ReseauWidget extends StatefulWidget {
  const ReseauWidget({Key? key}) : super(key: key);

  @override
  _ReseauWidgetState createState() => _ReseauWidgetState();
}

class _ReseauWidgetState extends State<ReseauWidget> {
  late ReseauModel _model;
  bool isExpanded_Titu = false;
  bool isExpanded_NonTitu = false;
  bool isExpanded_Pharma = false;
  final _unfocusNode = FocusNode();
  int demandesPending = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List titulairesNetwork = [];
  List userNetwork = [];

  Future<void> getNetworkData() async {
    String currentUserId = await getCurrentUserId();

    // Use collection group to make query across all collections
    QuerySnapshot queryUsers = await FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: currentUserId).get();

    List listUserNetwork = [];

    // Split users based on their 'poste' field
    for (var doc in queryUsers?.docs ?? []) {
      var data = doc.data();
      data['type'] = 'user';
      listUserNetwork.add(data);
    }

    print(listUserNetwork);

    setState(() {
      userNetwork = listUserNetwork;
    });
  }

  Future<void> _acceptInvite(userToAdd, invitId) async {
    String currentUserId = await getCurrentUserId();

    final documentRef = FirebaseFirestore.instance
        .collection('users') // replace with your collection name
        .doc(userToAdd);

    final currentUserRef = FirebaseFirestore.instance
        .collection('users') // replace with your collection name
        .doc(currentUserId);

    String currentuserid = await getCurrentUserId();

    await documentRef.update({
      'reseau': FieldValue.arrayUnion([currentuserid]),
    });
    await currentUserRef.update({
      'reseau': FieldValue.arrayUnion([userToAdd]),
    });

    final invitRef = FirebaseFirestore.instance
        .collection('demandes_network') // replace with your collection name
        .doc(invitId);

    invitRef.delete();
  }

  Future<void> _declineInvite(invitId) async {
    final documentRef = FirebaseFirestore.instance
        .collection('demandes_network') // replace with your collection name
        .doc(invitId);

    documentRef.delete();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReseauModel());
    getNetworkData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Mon réseau',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x33000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      gradient: LinearGradient(
                        colors: [Color(0xFF7CEDAC), Color(0xFF42D2FF)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(1.0, -1.0),
                        end: AlignmentDirectional(-1.0, 1.0),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.add,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        size: 20.0,
                      ),
                      onPressed: () async {
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
                                child: PopupImportContact(
                                  onTap: (lgo) => {},
                                ),
                              ),
                            );
                          },
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('demandes_network').where('for', isEqualTo: currentUserUid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container();
                          }

                          if (snapshot.hasData) {
                            final documents = snapshot.data!.docs;

                            return Column(
                              children: [
                                if (documents.length > 0)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Demandes d\'ajout (' + documents.length.toString() + ')',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Poppins',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: documents.length,
                                    itemBuilder: (context, index) {
                                      final demande = documents[index].data() as Map<String, dynamic>;
                                      final invitId = documents[index].id;
                                      // Utilisez les données de l'utilisateur ici
                                      return FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance.collection('users').doc(demande['by_user']).get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Container();
                                            }

                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Container();
                                            }

                                            final userData = snapshot.data!;
                                            return Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 1.0,
                                                    // height: MediaQuery.of(context).size.height * 0.65,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      borderRadius: BorderRadius.circular(15.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color.fromRGBO(31, 92, 103, 0.17),
                                                          offset: Offset(10.0, 10.0),
                                                          blurRadius: 12.0,
                                                          spreadRadius: -6.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                                          image: userData != null && userData['photoUrl'] != null ? userData['photoUrl'] : '',
                                                                          placeholder: 'assets/images/Group_18.png',
                                                                          fit: BoxFit.cover,
                                                                          imageErrorBuilder: (context, error, stackTrace) {
                                                                            return Image.asset('assets/images/Group_18.png');
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () => {
                                                                        context.pushNamed('ProfilView',
                                                                            queryParameters: {
                                                                              'userId': userData['id']
                                                                            })
                                                                      },
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width: MediaQuery.of(context).size.width * 0.40,
                                                                            child: Text(
                                                                              userData['nom'] + ' ' + userData['prenom'],
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: MediaQuery.of(context).size.width * 0.44,
                                                                            child: Text(
                                                                              userData['poste'] ?? '',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Color(0xFF8D8D97),
                                                                                    fontSize: 13.0,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 10.0),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(
                                                                Icons.location_on_outlined,
                                                                color: Color(0xFF595A71),
                                                                size: 35.0,
                                                              ),
                                                              if (userData['country'] != null)
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                  child: Text(
                                                                    userData['city'] + ', ' + userData['country'],
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                          fontFamily: 'Poppins',
                                                                          color: Color(0xFF595A71),
                                                                        ),
                                                                  ),
                                                                ),
                                                              if (userData['country'] == null)
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                  child: Text(
                                                                    userData['city'],
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                          fontFamily: 'Poppins',
                                                                          color: Color(0xFF595A71),
                                                                        ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 1.0,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFEFF6F7),
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(15.0),
                                                              bottomRight: Radius.circular(15.0),
                                                              topLeft: Radius.circular(0.0),
                                                              topRight: Radius.circular(0.0),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: TextButton(
                                                                      onPressed: () async {
                                                                        await _acceptInvite(demande['by_user'], invitId);
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(Icons.check, color: blueColor),
                                                                          Text('ACCEPTER', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blueColor, fontWeight: FontWeight.w600)),
                                                                        ],
                                                                      )),
                                                                ),
                                                                Container(
                                                                  child: TextButton(
                                                                      onPressed: () async {
                                                                        await _declineInvite(invitId);
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(Icons.close, color: redColor),
                                                                          Text('REFUSER', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: redColor, fontWeight: FontWeight.w600)),
                                                                        ],
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          });
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').where('reseau', arrayContains: currentUserUid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            Container();
                          }

                          if (snapshot.hasData) {
                            final documents = snapshot.data!.docs;
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dans mon réseau (' + documents.length.toString() + ')',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: documents.length,
                                    itemBuilder: (context, index) {
                                      final userData = documents[index].data() as Map<String, dynamic>;
                                      // Utilisez les données de l'utilisateur ici
                                      if (userData['nom'] != null && userData['prenom'] != null)
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: CardUserWidget(data: userData),
                                        );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
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
