import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';

import '../model/message.dart';
import 'loading.dart';

class SenderMessage extends StatefulWidget {
  const SenderMessage({super.key, required this.message, required this.onMessageClicked, required this.onVideoOpen, required this.onImageOpen});
  final Message? message;
  final void Function(TapDownDetails) onMessageClicked;
  final void Function() onVideoOpen;
  final void Function() onImageOpen;

  @override
  State<SenderMessage> createState() => _SenderMessageState();
}

class _SenderMessageState extends State<SenderMessage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.message?.video ?? ""));
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
    return GestureDetector(
      onTapDown: widget.message?.type == MessageType.text ? widget.onMessageClicked : null,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(8.0),
          decoration: widget.message?.type == MessageType.text ? const BoxDecoration(
            color: CupertinoColors.activeBlue, // Color for sender messages
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
                topRight: Radius.circular(4)
            ),
          ) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.message?.type == MessageType.text)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: Text(widget.message?.text ?? "",
                      style: const TextStyle(fontSize: 18, color: Colors.white)),
                )
              else if (widget.message?.type == MessageType.photo)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 100.0,
                      minWidth: 100.0,
                      maxHeight: 300.0,
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: GestureDetector(
                    onTap: widget.onImageOpen,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.message?.image ?? "",
                        placeholder: (context, url) =>
                        const Loading(),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else if (widget.message?.type == MessageType.video)
                  GestureDetector(
                    onTap: widget.onVideoOpen,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // width: MediaQuery.of(context).size.width - 100,
                        // height: 300,
                        child: ClipRRect(borderRadius: BorderRadius.circular(12),child: VideoPlayer(_controller)),
                      ),
                    ),
                  ),
              const Gap(5),
              Text(widget.message?.time ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}