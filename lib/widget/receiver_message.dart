import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/message.dart';
import 'loading.dart';

class ReceiverMessage extends StatelessWidget {
  const ReceiverMessage(
      {super.key,
        required this.message,
        required this.onImageOpen,
        required this.onVideoOpen,
        required this.onUserImageClicked});

  final Message? message;
  final void Function() onImageOpen;
  final void Function() onVideoOpen;
  final VoidCallback onUserImageClicked;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: onUserImageClicked,
            child: CircleAvatar(
              radius: 20,
              foregroundImage: NetworkImage(message?.ownerImage ?? ""),
              backgroundImage: const AssetImage("assets/img/img_2.png"),
            ),
          ),
          const Gap(10),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFF262323), // Color for sender messages
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(16)),
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
        ],
      ),
    );
  }
}