import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBar extends StatefulWidget {
  const MessageBar(
      {super.key,
      required this.controller,
      required this.onOpenCamera,
      required this.onOpenGallery,
      required this.onSend});

  final void Function() onOpenCamera;
  final void Function() onOpenGallery;
  final void Function() onSend;
  final TextEditingController controller;

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Color(0xFF262323)),
      child: TextField(
        onChanged: (v) => setState(() {}),
        controller: widget.controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Message...',
          prefixIcon: Container(
            margin: EdgeInsets.all(4),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconButton(
              onPressed: widget.onOpenCamera,
                icon: const Icon(CupertinoIcons.camera,color: Colors.white)
            ),
          ),
          suffixIcon: widget.controller.text.isEmpty
              ? IconButton(
                  onPressed: widget.onOpenGallery,
                  icon: const Icon(CupertinoIcons.photo,color: Colors.white,))
              : IconButton(
                  onPressed: widget.onSend,
                  icon: const Icon(CupertinoIcons.paperplane,color: Colors.white,)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
