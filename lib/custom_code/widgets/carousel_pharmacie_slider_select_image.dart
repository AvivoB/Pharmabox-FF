import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CarouselPharmacieSliderSelect extends StatefulWidget {
  @override
  _CarouselPharmacieSliderSelectState createState() => _CarouselPharmacieSliderSelectState();
}

class _CarouselPharmacieSliderSelectState extends State<CarouselPharmacieSliderSelect> {
  List<String> _imageUrls = [];

  Future<void> _selectAndUploadImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = file.path.split('/').last;
      final firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      await firebaseStorageRef.putFile(file);
      final downloadUrl = await firebaseStorageRef.getDownloadURL();
      setState(() {
        _imageUrls.add(downloadUrl);
      });
    }
  }

  Future<void> _deleteImage(String imageUrl) async {
    final firebaseStorageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await firebaseStorageRef.delete();
    setState(() {
      _imageUrls.remove(imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text('Select and upload image'),
          onPressed: _selectAndUploadImage,
        ),
        SizedBox(height: 20),
        _imageUrls.isEmpty
            ? Text('No images selected')
            : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            _imageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteImage(_imageUrls[index]),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ],
    );
  }
}
