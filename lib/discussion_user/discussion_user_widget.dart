import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';

import '/backend/backend.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'discussion_user_model.dart';
export 'discussion_user_model.dart';

class DiscussionUserWidget extends StatefulWidget {
  const DiscussionUserWidget({
    Key? key,
    this.chatUser,
    this.chatRef,
  }) : super(key: key);

  // final UsersRecord? chatUser;
  // final DocumentReference? chatRef;
  final String? chatUser;
  final String? chatRef;

  @override
  _DiscussionUserWidgetState createState() => _DiscussionUserWidgetState();
}

class _DiscussionUserWidgetState extends State<DiscussionUserWidget> {
  late DiscussionUserModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiscussionUserModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors
            .transparent, // Définissez la couleur de fond de l'AppBar sur transparent
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFF7F7FD5), // Couleur de départ du dégradé
                Color(0xFF86A8E7), // Couleur de fin du dégradé
                Color(0xFF91EAE4), // Couleur de fin du dégradé
              ],
            ),
          ),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Material(
                        elevation: 2,
                        color: Colors.white, // Couleur de l'arrière-plan
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.chevron_left, color: blackColor),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/5.jpg"),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Isabelle Retig",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Pharmacien(ne)",
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      elevation: 2,
                      color: greenColor, // Couleur de l'arrière-plan
                      child: IconButton(
                        onPressed: () {
                          // Logique de l'appel téléphonique
                        },
                        icon: Icon(Icons.phone, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  // .collection('chats')
                  // .doc(memberId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Une erreur s\'est produite'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucun message à afficher'));
                }

                return ListView(
                  reverse: true,
                  padding: EdgeInsets.all(16.0),
                  children: snapshot.data!.docs.map((doc) {
                    final message = doc['message'] as String;

                    return ListTile(
                      title: Text(message),
                      // Personnalisez l'affichage des messages ici
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // controller: _model.groupementFilterController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Message',
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
                          color: FlutterFlowTheme.of(context).focusColor,
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
                    ),
                    onChanged: (value) => {
                      setState(() {
                        // _searchText = value;
                      })
                    },
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
                SizedBox(width: 8.0),
                ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          blueColor,
                          greenColor,
                        ],
                      ),
                    ),
                    child: Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          print('send message');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            'assets/icons/Message.svg',
                            color: Colors.white,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
