import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmabox/composants/card_user/card_user_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmabox/custom_code/widgets/pharmabox_logo.dart';
import 'package:pharmabox/custom_code/widgets/progress_indicator.dart';
import 'package:pharmabox/custom_code/widgets/snackbar_message.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_drop_down.dart';
import 'package:pharmabox/flutter_flow/form_field_controller.dart';
import 'package:pharmabox/pharma_job/pharmaJobSearchData.dart';
import 'package:pharmabox/pharmablabla/pharmablabla_model.dart';
import 'package:pharmabox/popups/popup_groupement/popup_groupement_widget.dart';
import 'package:pharmabox/popups/popup_lgo/popup_lgo_widget.dart';
import 'package:pharmabox/popups/popup_pharmablabla/popup_pharmablabla_widget.dart';
import 'package:pharmabox/popups/popup_themes_pharmablabla/popup_theme_pharmablabla_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;
import '../composants/card_pharmacie/card_pharmacie_widget.dart';
import '../composants/card_pharmacie_offre_recherche/card_pharmacie_offre_recherche_widget.dart';
import '../custom_code/widgets/box_in_draggable_scroll.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../popups/popup_offre/popup_offre_widget.dart';
import '../popups/popup_recherche/popup_recherche_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/composants/header_app/header_app_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stopwordies/stopwordies.dart';

class PharmaBlablaEditPost extends StatefulWidget {
  const PharmaBlablaEditPost({Key? key, this.theme, this.postId, this.content, this.network, this.poste}) : super(key: key);
  final String? theme;
  final String? postId;
  final String? content;
  final String? network;
  final String? poste;

  @override
  _PharmaBlablaEditPostState createState() => _PharmaBlablaEditPostState();
}

class _PharmaBlablaEditPostState extends State<PharmaBlablaEditPost> {
  late PharmaBlablaModel _model;
  bool isTitulaire = false;
  Map<String, dynamic> updateData = {};
  List<VideoPlayerController> videosControllers = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void changeReseauType() {
    if (_model.reseauType == 'Tout Pharmabox') {
      setState(() {
        _model.reseauType = 'Mon réseau';
      });
    } else {
      setState(() {
        _model.reseauType = 'Tout Pharmabox';
      });
    }
  }

  @override
  void initState() {
    if (widget.postId != null) {
      updateData = {'content': widget.content.toString(), 'postId': widget.postId.toString(), 'theme':widget.theme.toString(), 'network': widget.network.toString(), 'poste': widget.poste.toString()};
    }

    super.initState();
    _model = createModel(context, () => PharmaBlablaModel());
    _model.postContent ??= TextEditingController(text: updateData['content']);
    _model.selectedTheme = updateData.isNotEmpty && updateData['theme'] != 'Thème' ? updateData['theme'] : 'Thème';
    _model.reseauType = updateData.isNotEmpty && updateData['network'] != 'Tout Pharmabox' ? 'Mon réseau' : 'Tout Pharmabox';
    checkIsTitulaire().then((isTitulaire) {
      setState(() {
        this.isTitulaire = isTitulaire;
      });
    });
  }

  List<XFile>? _pickedImages;
  List<VideoPlayerController> documentsMedia = [];
  List<XFile> documentsImage = [];
  bool _loading = false;
  List<String> urlsFiles = [];

  Future<void> _selectVideoAndImage() async {
    _pickedImages?.clear();
    videosControllers.clear();
    documentsMedia.clear();
    _pickedImages = await ImagePicker().pickMultipleMedia();

    setState(() {
      _loading = true;
    });
    try {
      for (int index = 0; index < _pickedImages!.length; index++) {
        if (_pickedImages![index].path.toLowerCase().endsWith('.mp4')) {
          documentsMedia.add(VideoPlayerController.file(File(_pickedImages![index].path.toString()))..initialize().then((_) => setState(() {})));
        } else {
          documentsImage.add(_pickedImages![index]);
        }
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error selecting images: $e');
    }
  }

  deleteMedia(int index, String type) {
    if (type == 'video') {
      documentsMedia.removeAt(index);
    }
    if (type == 'image') {
      documentsImage.removeAt(index);
    }
    setState(() {});
  }

  // Méthode pour téléverser les images sélectionnées vers Firebase Storage
  Future<List<String>> uploadImages() async {
    List<String> urls = [];
    if (_pickedImages != null) {
      for (var image in _pickedImages!) {
        final Reference storageRef = FirebaseStorage.instance.ref().child('pharmablabla/${DateTime.now()}${p.basename(image.path)}');
        final UploadTask uploadTask = storageRef.putFile(File(image.path));
        final TaskSnapshot downloadUrl = (await uploadTask);

        String url = (await downloadUrl.ref.getDownloadURL());

        urls.add(url);
      }

      return urls;
    }

    return urls;
  }

  Future<bool> savePostPharmablabla(type) async {
    CollectionReference pharmablablaCollection = FirebaseFirestore.instance.collection('pharmablabla');
    String currentuserId = await getCurrentUserId();

    if (_model.postContent.text != '') {
      List searchTerms = [];
      final stopWords = await StopWordies.getFor(locale: SWLocale.fr);

      List words = _model.postContent.text.toLowerCase().split(' ');

      for (var word in words) {
        if (!stopWords.contains(word) && word.length > 3) {
          searchTerms.add(word);
        }
      }

      if (type == 'create') {
        try {
          List<String> url = await uploadImages();
          await pharmablablaCollection.add({
            'users_viewed': [],
            'post_content': _model.postContent.text,
            'userId': currentuserId,
            'search_terms': searchTerms,
            'network': _model.reseauType,
            'theme': _model.selectedTheme,
            'poste': _model.posteValue,
            'media': url,
            'date_created': DateTime.now()
          });
          return true;
        } catch (e) {
          print('Erreur lors de l\'ajout du document: $e');
          return false;
        }
      }

      if (type == 'update') {
        try {
          await pharmablablaCollection.doc(updateData['postId']).update({
            'post_content': _model.postContent.text,
            'userId': currentuserId,
            'search_terms': searchTerms,
            'network': _model.reseauType,
            'theme': _model.selectedTheme,
            'poste': _model.posteValue,
          });
          return true;
        } catch (e) {
          print('Erreur lors de l\'ajout du document: $e');
          return false;
        }
      }
    } else {
      return false;
    }

    return false;
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
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wrapWithModel(
              model: _model.headerAppModel,
              updateCallback: () => setState(() {}),
              child: HeaderAppWidget(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            updateData.isNotEmpty ? 'Modifier votre post' : 'Ajouter un post',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                      child: Text(
                        'Où souhaitez-vous publier ?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.black, fontSize: 14),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 0.0, 5.0),
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width * 0.9,
                    //         height: 50.0,
                    //         decoration: BoxDecoration(
                    //           color: FlutterFlowTheme.of(context).secondaryBackground,
                    //           borderRadius: BorderRadius.circular(4.0),
                    //           border: Border.all(
                    //             color: Color(0xFFD0D1DE),
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.max,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                    //               child: Icon(
                    //                 Icons.work_outline,
                    //                 color: FlutterFlowTheme.of(context).secondaryText,
                    //                 size: 24.0,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(15.0, 5.0, 15.0, 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: Color(0xFFD0D1DE),
                                ),
                              ),
                              height: 50,
                              child: TextButton(
                                  onPressed: () {
                                    changeReseauType();
                                  },
                                  child: Row(
                                    children: [
                                      _model.reseauType == 'Tout Pharmabox'
                                          ? PharmaboxLogo(width: 25)
                                          : Icon(
                                              Icons.group_outlined,
                                              color: greyColor,
                                            ),
                                      SizedBox(width: 5),
                                      Text(_model.reseauType, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.black, fontSize: 11)),
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 15.0, 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                  color: Color(0xFFD0D1DE),
                                ),
                              ),
                              height: 50,
                              child: TextButton(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (bottomSheetContext) {
                                        return DraggableScrollableSheet(
                                            initialChildSize: 0.75,
                                            builder: (BuildContext context, ScrollController scrollController) {
                                              return GestureDetector(
                                                onTap: () => '',
                                                child: Padding(
                                                  padding: MediaQuery.of(bottomSheetContext).viewInsets,
                                                  child: PopupThemePharmablablaWidget(
                                                    onTap: (theme) {
                                                      setState(() {
                                                        _model.selectedTheme = theme;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ).then((value) => setState(() {}));
                                  },
                                  child: Row(
                                    children: [
                                      _model.selectedTheme == 'Thème' ? PharmaboxLogo(width: 25) : Container(),
                                      SizedBox(width: 5),
                                      Flexible(child: Container(child: Text(updateData.isNotEmpty ? updateData['theme'] : _model.selectedTheme, overflow: TextOverflow.ellipsis, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Poppins', color: Colors.black, fontSize: 11)))),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: Color(0x2B1F5C67),
                              offset: Offset(10, 10),
                            )
                          ],
                          borderRadius: BorderRadius.circular(0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    updateData.isNotEmpty ? 'Réécrivez votre post ...' : 'Lancez un sujet ...',
                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  if (updateData.isEmpty)
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _selectVideoAndImage();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Couleur de fond blanche
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add_circle_outlined, color: greyColor), // Icône de média
                                          SizedBox(width: 8), // Espace entre l'icône et le texte
                                          Text('Photos & Vidéos', style: FlutterFlowTheme.of(context).headlineMedium.override(fontFamily: 'Poppins', color: blackColor, fontSize: 11, fontWeight: FontWeight.w400)), // Texte du bouton
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              if (_pickedImages != null)
                                Container(
                                  height: (documentsMedia.length > 0 || documentsImage.length > 0) ? 100 : 0, // Ajustez la hauteur en fonction du nombre d'éléments affichés
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                      for (final video in documentsMedia)
                                        Stack(
                                          children: [
                                            Container(
                                                // ajustez la hauteur selon vos besoins
                                                child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: AspectRatio(
                                                aspectRatio: video.value.aspectRatio,
                                                child: VideoPlayer(video),
                                              ),
                                            )),
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(color: redColor, borderRadius: BorderRadius.all(Radius.circular(50.0))),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                onPressed: () => deleteMedia(documentsMedia.indexOf(video), 'video'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      for (final image in documentsImage)
                                        Stack(
                                          children: [
                                            Container(
                                              // ajustez la hauteur selon vos besoins
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.file(File(image.path)),
                                              ),
                                            ),
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(color: redColor, borderRadius: BorderRadius.all(Radius.circular(50.0))),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                onPressed: () => deleteMedia(documentsImage.indexOf(image), 'image'),
                                              ),
                                            ),
                                          ],
                                        )
                                    ]),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  minLines: 12,
                                  controller: _model.postContent,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    filled: true, //<-- SEE HERE
                                    fillColor: Colors.white,
                                    labelText: 'Ecrivez votre message ici',
                                    hintStyle: FlutterFlowTheme.of(context).bodySmall,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFD0D1DE),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).focusColor,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
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
                                    onPressed: () async {
                                      if (await savePostPharmablabla(updateData.isNotEmpty ? 'update' : 'create')) {
                                        showCustomSnackBar(context, 'Votre publication est en ligne !');
                                        context.pushNamed('PharmaBlabla');
                                      } else {
                                        showCustomSnackBar(context, 'Erreur de publication', isError: true);
                                      }
                                    },
                                    text: updateData.isNotEmpty ? 'Enregistrer' : 'Publier',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 40.0,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
