import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/popups/popup_liked/popup_liked_model.dart';

import '../../constant.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopupLikedWidget extends StatefulWidget {
  PopupLikedWidget({Key? key, this.documentId = ''}) : super(key: key);

  String documentId = '';

  @override
  _PopupLikedWidgetState createState() => _PopupLikedWidgetState();
}

class _PopupLikedWidgetState extends State<PopupLikedWidget> {
  late PopupLikedModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupLikedModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Aimé par',
                        style: FlutterFlowTheme.of(context).displaySmall,
                      ),
                      FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderWidth: 0.0,
                        buttonSize: 60.0,
                        icon: Icon(
                          Icons.close,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('likes').where('document_id', isEqualTo: widget.documentId).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: ProgressIndicatorPharmabox()); // or another loading widget
                        }

                        // Filtering out documents where 'for' does not equal the current user's ID.
                        List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data != null ? snapshot.data!.docs : [];

                        if (documents.isEmpty) {
                          return Center(
                            child: Text('Aucun like pour le moment', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w600)),
                          );
                        }

                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            // Get data for this document
                            Map<String, dynamic>? data = documents[index].data();

                            Future<Map<String, dynamic>?> getUserData(String userId) async {
                              DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
                              return doc.data();
                            }

                            return FutureBuilder<Map<String, dynamic>?>(
                                future: getUserData(data!['liked_by']),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    Map<String, dynamic>? userData = snapshot.data;

                                    // Now use 'userData' to build your widget. {
                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                          ),
                                          child: Container(
                                            width: 120.0,
                                            height: 120.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child:
                                            (userData != null && userData['photoUrl'] != null && userData['photoUrl'].isNotEmpty)
                                                      ? Image.network(
                                                          userData['photoUrl'],
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/Group_18.png',
                                                          fit: BoxFit.cover,
                                                        )),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 10.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (userData != null)
                                                  Text(
                                                    userData != null ? userData!['prenom'] + ' ' + userData['nom'] : 'Utilisateur',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Poppins',
                                                          color: Color(0xFF595A71),
                                                        ),
                                                  ),
                                                Text(
                                                  DateFormat('dd/MM/yyyy', 'fr_FR').format(data!['like_time'].toDate()) ?? 'N/A', // Assuming your notification timestamp is a DateTime type stored with key 'timestamp'
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        fontFamily: 'Poppins',
                                                        color: Color(0xFF8D8D97),
                                                        fontSize: 11.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                });
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
