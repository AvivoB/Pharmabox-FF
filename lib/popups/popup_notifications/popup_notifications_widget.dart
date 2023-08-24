import 'package:firebase_auth/firebase_auth.dart';

import '../../constant.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'popup_notifications_model.dart';
export 'popup_notifications_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopupNotificationsWidget extends StatefulWidget {
  const PopupNotificationsWidget({Key? key}) : super(key: key);

  @override
  _PopupNotificationsWidgetState createState() =>
      _PopupNotificationsWidgetState();
}

class _PopupNotificationsWidgetState extends State<PopupNotificationsWidget> {
  late PopupNotificationsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PopupNotificationsModel());
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
          height: MediaQuery.of(context).size.height * 0.5,
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
                        'Notifications',
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
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('notifications')
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Assuming `currentUserId` contains the ID of the current user.
                        String? currentUserId =
                            FirebaseAuth.instance.currentUser?.uid;

                        // Filtering out documents where 'for' does not equal the current user's ID.
                        List<DocumentSnapshot<Map<String, dynamic>>> documents =
                            snapshot.data!.docs
                                .where(
                                    (doc) => doc.data()['for'] == currentUserId)
                                .toList();

                        if (documents.isEmpty) {
                          return Center(
                            child: Text('Aucune notification',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Poppins',
                                        color: blackColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600)),
                          );
                        }

                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            // Get data for this document
                            Map<String, dynamic>? data =
                                documents[index].data();

                            Future<Map<String, dynamic>?> getUserData(String userId) async {
                                            DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userId)
                                                .get();
                                            return doc.data();
                            }

                            return FutureBuilder<Map<String, dynamic>?>(
                              future: getUserData(data!['by_user']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // or another loading widget
                                } else if (snapshot.hasError) {
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
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: Container(
                                          width: 120.0,
                                          height: 120.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: FadeInImage.assetNetwork(
                                          image: userData!['photoUrl'] != null ? userData!['photoUrl'] : '',
                                          placeholder: 'assets/images/Group_18.png',
                                          fit: BoxFit.cover,
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/images/Group_18.png');
                                          },
                                        ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 0.0, 0.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width * 0.6,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data!['addedToNetwork']
                                                    ? userData!['prenom'] + ' ' + userData['nom'] + ' vous a ajouté à son réseau'
                                                    : userData!['prenom'] + ' ' + userData['nom'] + ' a aimé votre profil',
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFF595A71),
                                                    ),
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy', 'fr_FR')
                                                        .format(data!['timestamp']
                                                            .toDate()) ??
                                                    'N/A', // Assuming your notification timestamp is a DateTime type stored with key 'timestamp'
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFF8D8D97),
                                                      fontSize: 11.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width * 0.15,
                                        height:
                                            MediaQuery.of(context).size.width * 0.15,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          shape: BoxShape.circle,
                                        ),
                                        child: FlutterFlowIconButton(
                                          borderColor: Color(0x0042D2FF),
                                          borderRadius: 100.0,
                                          borderWidth: 0.0,
                                          buttonSize: 40.0,
                                          icon: Icon(
                                            Icons.delete_outline_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            size: 20.0,
                                          ),
                                          onPressed: () {
                                            // Assuming you want to delete the notification when the button is pressed.
                                            FirebaseFirestore.instance
                                                .collection('notifications')
                                                .doc(documents[index].id)
                                                .delete();
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                                      
                                }
                              }
                            );
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
