import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_qlone/manager/chat_manager.dart';
import 'package:insta_qlone/model/fb_user.dart';
import 'package:insta_qlone/widget/loading.dart';
import 'package:insta_qlone/widget/message_bar.dart';
import 'package:insta_qlone/widget/receiver_message.dart';
import 'package:insta_qlone/widget/sender_message.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.user});

  final FbUser? user;
  final TextEditingController _controller = TextEditingController();
  final _chatManager = ChatManager();

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
            Expanded(
              child: FutureBuilder(
                future: _chatManager.getMessages(user?.uid),
                builder: (context,snapshot) {
                  if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return SenderMessage(message: snapshot.data?[index], onMessageClicked: () {}, onVideoOpen: () {}, onImageOpen: () {});
                        // if(index % 2 == 0) {
                        //   return ReceiverMessage(message: null, onImageOpen: () {}, onVideoOpen: () {}, onUserImageClicked: () {});
                        // } else {
                        //   return SenderMessage(message: null, onMessageClicked: () {}, onVideoOpen: () {}, onImageOpen: () {});
                        // }
                      },
                    );
                  }
                  return Loading();
                }
              ),
            ),
            MessageBar(controller: _controller ,onOpenCamera: () {}, onOpenGallery: () {}, onSend: _sendTextMsg),
            const Gap(8)
          ],
        ),
      ),
    );
  }
  void _sendTextMsg() {
    _chatManager.sendTextMessage(_controller.text, user?.uid);
    _controller.text = '';
  }
}
