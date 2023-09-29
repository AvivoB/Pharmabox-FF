import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/custom_code/widgets/button_network_manager.dart';
import 'package:pharmabox/index.dart';
import 'package:pharmabox/popups/popup_signalement/popup_signalement_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class CarouselPharmacieSliderSelect extends StatefulWidget {
  final Function(List<String>) onImagesSelected;
  final List<String>? initialImagesSelected;
  final bool isEditable;
  final String? pharmacieId;
  var data;
  var userData;

  CarouselPharmacieSliderSelect({required this.onImagesSelected, this.initialImagesSelected, this.isEditable = true, this.pharmacieId, this.data, this.userData});

  @override
  _CarouselPharmacieSliderSelectState createState() => _CarouselPharmacieSliderSelectState();
}

class _CarouselPharmacieSliderSelectState extends State<CarouselPharmacieSliderSelect> {
  final List<File> _selectedImages = [];
  List<String>? _initialImagesSelected;
  List<String> urls = <String>[];

  @override
  void initState() {
    super.initState(); // Don't forget to call super.initState()
    urls = widget.initialImagesSelected ?? <String>[]; // Assign value to urls here
  }

  Future<void> _selectImages() async {
    final option = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Prendre une photo', style: FlutterFlowTheme.of(context).bodyMedium),
              onTap: () {
                Navigator.pop(context, 'camera');
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Sélectionner depuis la galerie', style: FlutterFlowTheme.of(context).bodyMedium),
              onTap: () {
                Navigator.pop(context, 'gallery');
              },
            ),
          ],
        );
      },
    );

    List<XFile>? pickedImages;

    if (option == 'camera') {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 800,
      );
      if (pickedImage != null) pickedImages = [pickedImage];
    } else if (option == 'gallery') {
      pickedImages = await ImagePicker().pickMultiImage(
        imageQuality: 50,
        maxWidth: 800,
      );
    }

    if (pickedImages != null) {
      for (var imageFile in pickedImages.map((pickedImage) => File(pickedImage.path))) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(toolbarTitle: 'Redimensionner l\'image', toolbarColor: blueColor, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
            IOSUiSettings(
              title: 'Redimensionner l\'image',
            ),
          ],
        );

        if (croppedImage != null) {
          setState(() {
            _selectedImages.add(File(croppedImage.path));
          });
        }
      }

      if (_selectedImages.isNotEmpty) {
        final storage = FirebaseStorage.instance;

        for (var image in _selectedImages) {
          final ref = storage.ref().child('pharmacie_pictures/${DateTime.now().millisecondsSinceEpoch}');
          await ref.putFile(image);
          final url = await ref.getDownloadURL();
          urls.add(url);
        }

        widget.onImagesSelected(urls);

        setState(() {
          _selectedImages.clear();
        });
      }
    }
  }

  // Future<void> _selectImages() async {
  //   final pickedImages = await ImagePicker().pickMultiImage(imageQuality: 50, maxWidth: 800);

  //   if (pickedImages != null) {
  //     for (var imageFile in pickedImages.map((pickedImage) => File(pickedImage.path))) {
  //       final croppedImage = await ImageCropper().cropImage(
  //         sourcePath: imageFile.path,
  //         aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //         compressQuality: 50,
  //         compressFormat: ImageCompressFormat.jpg,
  //         uiSettings: [
  //           AndroidUiSettings(toolbarTitle: 'Redimensionner l\'image', toolbarColor: blueColor, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
  //           IOSUiSettings(
  //             title: 'Redimensionner l\'image',
  //           ),
  //         ],
  //       );

  //       if (croppedImage != null) {
  //         setState(() {
  //           _selectedImages.add(File(croppedImage.path));
  //         });
  //       }
  //     }

  //     if (_selectedImages.isNotEmpty) {
  //       final storage = FirebaseStorage.instance;

  //       for (var image in _selectedImages) {
  //         final ref = storage.ref().child('pharmacie_pictures/${DateTime.now().millisecondsSinceEpoch}');
  //         await ref.putFile(image);
  //         final url = await ref.getDownloadURL();
  //         urls.add(url);
  //       }

  //       widget.onImagesSelected(urls);

  //       setState(() {
  //         _selectedImages.clear();
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        urls.isEmpty
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                    stops: [0, 0.5, 1],
                    begin: AlignmentDirectional(1, 0),
                    end: AlignmentDirectional(-1, 0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isEditable == false)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.chevron_left),
                                iconSize: 30,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.flag_outlined,
                                        color: redColor,
                                      ),
                                      iconSize: 30,
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: true,
                                          context: context,
                                          builder: (bottomSheetContext) {
                                            return Padding(padding: MediaQuery.of(bottomSheetContext).viewInsets, child: PopupSignalement(docId: widget.pharmacieId ?? '', collectionName: 'pharmacies'));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 250,
                              height: 150,
                              child: Stack(
                                alignment: AlignmentDirectional(0, 1),
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Color(0x00FFFFFF),
                                      borderRadius: BorderRadius.circular(95),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/images/Group_19.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (widget.isEditable)
                                    Align(
                                      alignment: AlignmentDirectional(0.65, 1),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30,
                                        borderWidth: 1,
                                        buttonSize: 60,
                                        fillColor: Colors.white,
                                        icon: Icon(
                                          Icons.add_a_photo_outlined,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          size: 30,
                                        ),
                                        onPressed: _selectImages,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isEditable == false)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                      stops: [0.0, 1.0],
                                      begin: AlignmentDirectional(1.0, 0.0),
                                      end: AlignmentDirectional(-1.0, 0),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                    child: FlutterFlowIconButton(
                                      borderColor: Color(0x0042D2FF),
                                      borderRadius: 30.0,
                                      borderWidth: 0.0,
                                      buttonSize: 40.0,
                                      fillColor: Colors.white,
                                      icon: Icon(
                                        Icons.phone,
                                        color: Color(0xFF42D2FF),
                                        size: 24.0,
                                      ),
                                      onPressed: () async {
                                        if (widget.data['contact_pharma']['preference_contact'] == 'Pharmacie') {
                                          await launch('tel:' + widget.data['contact_pharma']['telephone'].toString());
                                        } else {
                                          await launch('tel:' + widget.userData['telephone']);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                      stops: [0.0, 1.0],
                                      begin: AlignmentDirectional(1.0, 0.0),
                                      end: AlignmentDirectional(-1.0, 0),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                    child: FlutterFlowIconButton(
                                      borderColor: Color(0x0042D2FF),
                                      borderRadius: 30.0,
                                      borderWidth: 0.0,
                                      buttonSize: 40.0,
                                      fillColor: Colors.white,
                                      icon: Icon(
                                        Icons.mail_outline_rounded,
                                        color: Color(0xFF42D2FF),
                                        size: 24.0,
                                      ),
                                      onPressed: () async {
                                        if (widget.data['contact_pharma']['preference_contact'] == 'Pharmacie') {
                                          await launch('mailto:' + widget.data['contact_pharma']['email'].toString());
                                        } else {
                                          await launch('mailto:' + widget.userData['email'].toString());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                    stops: [0.0, 1.0],
                                    begin: AlignmentDirectional(1.0, 0.0),
                                    end: AlignmentDirectional(-1.0, 0),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                  child: FlutterFlowIconButton(
                                    borderColor: Color(0x0042D2FF),
                                    borderRadius: 30.0,
                                    borderWidth: 0.0,
                                    buttonSize: 40.0,
                                    fillColor: Colors.white,
                                    icon: Icon(
                                      Icons.message_outlined,
                                      color: Color(0xFF42D2FF),
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DiscussionUserWidget(toUser: widget.data['user_id']),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.network(
                          urls[index],
                          width: MediaQuery.of(context).size.width * 1,
                          fit: BoxFit.cover,
                        ),
                        if (widget.isEditable == false)
                          Positioned(
                              top: 10,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.chevron_left),
                                          iconSize: 30,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.flag_outlined,
                                                  color: redColor,
                                                ),
                                                iconSize: 30,
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor: Colors.transparent,
                                                    enableDrag: true,
                                                    context: context,
                                                    builder: (bottomSheetContext) {
                                                      return Padding(padding: MediaQuery.of(bottomSheetContext).viewInsets, child: PopupSignalement(docId: widget.pharmacieId ?? '', collectionName: 'pharmacies'));
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        if (widget.isEditable == false)
                          Positioned(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                            stops: [0.0, 1.0],
                                            begin: AlignmentDirectional(1.0, 0.0),
                                            end: AlignmentDirectional(-1.0, 0),
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Color(0x0042D2FF),
                                            borderRadius: 30.0,
                                            borderWidth: 0.0,
                                            buttonSize: 40.0,
                                            fillColor: Colors.white,
                                            icon: Icon(
                                              Icons.phone,
                                              color: Color(0xFF42D2FF),
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              if (widget.data['contact_pharma']['preference_contact'] == 'Pharmacie') {
                                                await launch('tel:' + widget.data['contact_pharma']['telephone'].toString());
                                              } else {
                                                await launch('tel:' + widget.userData['telephone'].toString());
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                            stops: [0.0, 1.0],
                                            begin: AlignmentDirectional(1.0, 0.0),
                                            end: AlignmentDirectional(-1.0, 0),
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Color(0x0042D2FF),
                                            borderRadius: 30.0,
                                            borderWidth: 0.0,
                                            buttonSize: 40.0,
                                            fillColor: Colors.white,
                                            icon: Icon(
                                              Icons.mail_outline_rounded,
                                              color: Color(0xFF42D2FF),
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              if (widget.data['contact_pharma']['preference_contact'] == 'Pharmacie') {
                                                await launch('mailto:' + widget.data['contact_pharma']['email'].toString());
                                              } else {
                                                await launch('mailto:' + widget.userData['email'].toString());
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF42D2FF), Color(0xFF7CEDAC)],
                                          stops: [0.0, 1.0],
                                          begin: AlignmentDirectional(1.0, 0.0),
                                          end: AlignmentDirectional(-1.0, 0),
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                                        child: FlutterFlowIconButton(
                                          borderColor: Color(0x0042D2FF),
                                          borderRadius: 30.0,
                                          borderWidth: 0.0,
                                          buttonSize: 40.0,
                                          fillColor: Colors.white,
                                          icon: Icon(
                                            Icons.message_outlined,
                                            color: Color(0xFF42D2FF),
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DiscussionUserWidget(toUser: widget.data['user_id']),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              bottom: 10,
                              left: 10),
                        Positioned(
                            bottom: 10,
                            left: 10,
                            child: Row(
                              children: [
                                if (widget.isEditable)
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30,
                                    borderWidth: 1,
                                    buttonSize: 45,
                                    fillColor: Colors.white,
                                    icon: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      size: 22,
                                    ),
                                    onPressed: _selectImages,
                                  ),
                                if (widget.isEditable)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: FlutterFlowIconButton(
                                      borderColor: Colors.transparent,
                                      borderRadius: 30,
                                      borderWidth: 1,
                                      buttonSize: 45,
                                      fillColor: Colors.white,
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        size: 22,
                                      ),
                                      onPressed: () async {
                                        try {
                                          await FirebaseStorage.instance.refFromURL(urls[index].toString()).delete();
                                          urls.removeAt(index);
                                        } catch (e) {
                                          print('Error deleting photo: $e');
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ),
                              ],
                            ))
                      ],
                    );
                  },
                ),
              ),
      ],
    );
  }
}
