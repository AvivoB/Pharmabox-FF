import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderWidget extends StatefulWidget {
  @override
  _ImageSliderWidgetState createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  final CollectionReference _imagesRef =
      FirebaseFirestore.instance.collection('images');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _imagesRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur de chargement des images');
        }

        if (!snapshot.hasData) {
          return Text('Aucune image disponible');
        }

        final images = snapshot.data!.docs;

        return CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enableInfiniteScroll: false,
          ),
          items: images.map((image) {
            final imageUrl = image.get('url') as String;
            return Image.network(
              imageUrl,
              fit: BoxFit.cover,
            );
          }).toList(),
        );
      },
    );
  }
}
