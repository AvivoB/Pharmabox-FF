import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderWidget extends StatefulWidget {
  final List imageNames;

  ImageSliderWidget({required this.imageNames});

  @override
  _ImageSliderWidgetState createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enableInfiniteScroll: false,
      ),
      items: widget.imageNames.map((imageName) {
        return Image.network(
          imageName,
          fit: BoxFit.cover,
        );
      }).toList(),
    );
  }
}
