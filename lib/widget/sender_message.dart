import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/message.dart';
import 'loading.dart';

class SenderMessage extends StatelessWidget {
  const SenderMessage({super.key, required this.message, required this.onMessageClicked, required this.onVideoOpen, required this.onImageOpen});
  final Message? message;
  final void Function() onMessageClicked;
  final void Function() onVideoOpen;
  final void Function() onImageOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onMessageClicked,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: CupertinoColors.activeBlue, // Color for sender messages
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
                topRight: Radius.circular(4)
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message?.type == MessageType.text)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: Text(message?.text ?? "",
                      style: const TextStyle(fontSize: 18, color: Colors.white)),
                )
              else if (message?.type == MessageType.photo)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 100.0,
                      minWidth: 100.0,
                      maxHeight: 300.0,
                      maxWidth: MediaQuery.of(context).size.width - 100),
                  child: GestureDetector(
                    onTap: onImageOpen,
                    child: CachedNetworkImage(
                      imageUrl: message?.image ?? "",
                      placeholder: (context, url) =>
                      const Loading(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              // else if (message?.type == MessageType.video)
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width - 100,
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           IconButton(
              //               onPressed: onFileOpen,
              //               icon: const Icon(
              //                 Icons.file_present_rounded,
              //                 color: Colors.white,
              //               )),
              //           Flexible(
              //               child: Text(message?.fileName ?? "",
              //                   style: const TextStyle(
              //                       fontSize: 15, color: Colors.white),
              //                   maxLines: 1,
              //                   overflow: TextOverflow.ellipsis))
              //         ],
              //       ),
              //     ),
              const Gap(5),
              Text(message?.time ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}