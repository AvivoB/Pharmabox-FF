import 'package:flutter_svg/svg.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

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
  DiscussionUserWidget({
    Key? key,
    required this.toUser,
  }) : super(key: key);

  final String toUser;

  @override
  _DiscussionUserWidgetState createState() => _DiscussionUserWidgetState();
}

class _DiscussionUserWidgetState extends State<DiscussionUserWidget> {
  late DiscussionUserModel _model;
  final TextEditingController _message = TextEditingController();
  Map userMessage = {};
  String currentUser = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiscussionUserModel());
    getUserById(widget.toUser);
  }

  @override
  void dispose() {
    _model.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    List<String> ids = [currentUser, widget.toUser];
    ids.sort();
    final String conversationId = ids.join('-');

    final DocumentReference conversationDoc = FirebaseFirestore.instance.collection('messages').doc(conversationId);

    try {
      if (_message.text.isNotEmpty) {
        conversationDoc.set({'last_message': _message.text, 'last_message_from': currentUser, 'timestamp': FieldValue.serverTimestamp()});
        // Add a new document to the 'message' subcollection.
        await conversationDoc.collection('message').add({
          'fromId': currentUser,
          'isViewed': false,
          'message': _message.text,
          'receiverId': widget.toUser,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _message.text = '';
        });
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> getUserById(String userId) async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    String currentUserId = await getCurrentUserId();

    setState(() {
      userMessage = userData;
      currentUser = currentUserId;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> ids = [currentUser, widget.toUser];
    ids.sort(); // This ensures that the conversationId will be the same regardless of which user starts the conversation
    final String conversationId = ids.join('-');

    if (_isLoading) {
      return Center(child: ProgressIndicatorPharmabox()); // or another loading widget
    } else {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent, // Définissez la couleur de fond de l'AppBar sur transparent
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
                          elevation: 10,
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
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0x00FFFFFF),
                        borderRadius: BorderRadius.circular(95.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userMessage != null ? userMessage['photoUrl'] : '',
                          ),
                          maxRadius: 25,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            userMessage['prenom'] + ' ' + userMessage['nom'],
                            style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            userMessage['poste'],
                            style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (userMessage['afficher_tel'])
                      ClipOval(
                        child: Material(
                          elevation: 2,
                          color: greenColor, // Couleur de l'arrière-plan
                          child: IconButton(
                            onPressed: () async {
                              await launch('tel:' + userMessage['telephone']);
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
                      .collection('messages')
                      .doc(conversationId)
                      .collection('message')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Une erreur s\'est produite'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Démarrez une conversation avec ce membre',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: blackColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    final mergedList = snapshot.data!.docs;

                    // Grouper les messages par jour
                    Map<String, List<DocumentSnapshot>> groupedMessages = {};
                    mergedList.forEach((doc) {
                      String date = doc['timestamp'] != null ? DateFormat('dd/MM/yyyy', 'fr_FR').format(doc['timestamp']?.toDate()) : '';

                      if (!groupedMessages.containsKey(date)) {
                        groupedMessages[date] = [];
                      }

                      groupedMessages[date]?.add(doc);
                    });

                    // Créer une liste d'éléments à afficher
                    List<Widget> messageWidgets = [];

                    groupedMessages.forEach((date, messages) {
                      

                      

                      // Ajouter les messages pour cette date
                      messageWidgets.addAll(messages.map<Widget>((doc) {
                        bool isCurrentUser = doc['fromId'] == currentUser;

                        if (doc['receiverId'] == currentUser) {
                          FirebaseFirestore.instance.collection('messages').doc(conversationId).collection('message').doc(doc.id).update({'isViewed': true}).then((value) {}).catchError((error) {
                            print('Error updating document: $error');
                          });
                        }

                        return Container(
                          padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
                          child: Align(
                            alignment: (isCurrentUser ? Alignment.topRight : Alignment.topLeft),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (isCurrentUser ? greenColor : Colors.grey.shade200),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc['message'],
                                        style : FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: isCurrentUser ? Colors.white : blackColor, fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          
                                          Text(
                                            doc['timestamp'] != null ? DateFormat('HH:mm', 'fr_FR').format(doc['timestamp']?.toDate()) : '',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: greyColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          if(isCurrentUser) SizedBox(width: 10),
                                          if(isCurrentUser) Icon(Icons.done_all, size: 18, color: doc['isViewed'] ? blueColor : greyColor),
                                          
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList());

                      // Ajouter la date en tant que séparateur
                      messageWidgets.add(
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              date,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    });

                    

                    

                    return ListView(
                      reverse: true,
                      padding: EdgeInsets.all(12.0),
                      children: messageWidgets,
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
                      textCapitalization: TextCapitalization.sentences,
                      controller: _message,
                      minLines: 1,
                      maxLines: null,
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
                        // setState(() {
                        //   _message.text = value;
                        // })
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
                            sendMessage();
                            // _message.text = '';
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
}
