import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class ReelVideo extends StatefulWidget {
  const ReelVideo({super.key, required this.video});
  final String? video;

  @override
  State<ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends State<ReelVideo> {
  late VideoPlayerController _controller;


  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video ?? ""));
    _controller.setLooping(true);
    _controller.initialize();
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }
}
