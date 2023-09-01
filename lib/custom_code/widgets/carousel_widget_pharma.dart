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
    if (widget.imageNames.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          enableInfiniteScroll: true,
        ),
        items: widget.imageNames.map((imageName) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageName,
                width: MediaQuery.of(context).size.width * 1,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
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
                      // width: 250,
                      // height: 150,
                      child: Stack(
                        alignment: AlignmentDirectional(0, 1),
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0x00FFFFFF),
                              borderRadius: BorderRadius.circular(95),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
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
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
