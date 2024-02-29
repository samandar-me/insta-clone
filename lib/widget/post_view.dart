import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_qlone/model/post.dart';

import 'loading.dart';

class PostView extends StatelessWidget {
  const PostView({super.key, required this.post, required this.onLiked});
  final Post post;
  final void Function() onLiked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                foregroundImage: NetworkImage(post.ownerImage ?? ""),
              ),
              const Gap(18),
              Expanded(child: Text(post.ownerName ?? "")),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
            ],
          ),
        ),
        const Gap(5),
        CachedNetworkImage(
          height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          imageUrl: post.image ?? "",
          placeholder: (context, url) =>
          const Loading(),
          errorWidget: (context, url, error) =>
          const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        const Gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: [
              Expanded(child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
                  IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.chat_bubble)),
                  IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.paperplane)),
                ],
              )),
              IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bookmark))
              // Align(
              //   alignment: AlignmentDirectional.centerEnd,
              //   child: ,
              // )
            ],
          ),
        ),
        const Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("20321 likes"),
              const Gap(5),
              Text(post.desc ?? "")
            ],
          ),
        )
      ],
    );
  }
}
