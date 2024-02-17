import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_qlone/model/fb_user.dart';
import 'package:insta_qlone/widget/message_bar.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.user});

  final FbUser? user;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 20,
                foregroundImage: NetworkImage(user?.image ?? ""),
              ),
            ),
            const Gap(12),
            Text(user?.username ?? ""),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.phone)),
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.video_camera)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: Container()),
            MessageBar(controller: _controller ,onOpenCamera: () {}, onOpenGallery: () {}, onSend: () {})
          ],
        ),
      ),
    );
  }
}
