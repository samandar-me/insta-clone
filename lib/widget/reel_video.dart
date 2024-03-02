import 'package:flutter/cupertino.dart';
import 'package:insta_qlone/widget/loading.dart';
import 'package:video_player/video_player.dart';

class ReelVideo extends StatefulWidget {
  const ReelVideo({super.key, required this.video});

  final String? video;

  @override
  State<ReelVideo> createState() => _ReelVideoState();
}

class _ReelVideoState extends State<ReelVideo> {
  late VideoPlayerController _controller;
  double _oldValue = 0;

  @override
  void initState() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video ?? ""));
    _controller.setLooping(true);
    _controller.initialize();
    _controller.play();
    _oldValue = _controller.value.volume;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (_controller.value.volume == 0) {
            _controller.setVolume(_oldValue);
          } else {
            _controller.setVolume(0);
          }
          setState(() {});
        },
        child: Stack(
          children: [
            VideoPlayer(_controller),
            Positioned(
              left: 20,
                top: 80,
                child: Icon(
                _controller.value.volume == 0
                    ? CupertinoIcons.volume_off
                    : CupertinoIcons.volume_up,
                size: 24))
          ],
        ));
  }
}
