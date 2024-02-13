import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({super.key, required this.image});

  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        onVerticalDragStart: (v) => Navigator.of(context).pop(),
        child: InteractiveViewer(
          child: CircleAvatar(
            foregroundImage: NetworkImage(image),
          ),
        ),
      ),
    );
  }
}
