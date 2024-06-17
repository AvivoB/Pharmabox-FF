import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:pharmabox/constant.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget({required this.videoUrl});
  final String videoUrl;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
      // Gérer les erreurs d'initialisation ici
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoInitialized) {
      return Center(child: Container());
    }

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: false,
      allowPlaybackSpeedChanging: false,
      allowMuting: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: blueColor,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.transparent,
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
