import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget({required this.videoUrl});
  final String videoUrl;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          setState(() {});
        }),
      autoPlay: false,
    );
  }

  void killVidPlayer() {
    setState(() {});
    flickManager.dispose();
  }

  // @override
  // void dispose() {
  //   flickManager.dispose();
  //   // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        killVidPlayer();
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
        ),
      ),
    );
  }
}
