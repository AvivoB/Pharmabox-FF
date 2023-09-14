import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pharmabox/constant.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class CarouselPharmacieSliderSelect extends StatefulWidget {
  final Function(List<String>) onImagesSelected;
  final List<String>? initialImagesSelected;
  final bool isEditable;

  CarouselPharmacieSliderSelect({required this.onImagesSelected, this.initialImagesSelected, this.isEditable = true});

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
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
                    stops: [0, 0.5, 1],
                    begin: AlignmentDirectional(1, 0),
                    end: AlignmentDirectional(-1, 0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
