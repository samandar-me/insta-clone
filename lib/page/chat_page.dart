import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_qlone/manager/chat_manager.dart';
import 'package:insta_qlone/model/fb_user.dart';
import 'package:insta_qlone/model/message.dart';
import 'package:insta_qlone/page/receiver_profile_page.dart';
import 'package:insta_qlone/util/message.dart';
import 'package:insta_qlone/util/navigator.dart';
import 'package:insta_qlone/widget/loading.dart';
import 'package:insta_qlone/widget/message_bar.dart';
import 'package:insta_qlone/widget/receiver_message.dart';
import 'package:insta_qlone/widget/sender_message.dart';

import '../manager/fb_manager.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.user});

  final FbUser? user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  final _chatManager = ChatManager();
  late ScrollController _scrollController;
  bool _isFabVisible = false;
  final _picker = ImagePicker();
  XFile? _cameraImage;
  XFile? _galleryVideo;

  bool _isEdited = false;
  Message? _editedMessage;

  late DatabaseReference _reference;
  final _fb = FbManager();
  bool _isImageLoading = false;
  bool _isVideoLoading = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _reference = FirebaseDatabase.instance
        .ref('chats/${_fb.getUser()?.uid}${widget.user?.uid}/messages');
    _listener();
    super.initState();
  }

  void _listener() {
    _scrollController.addListener(() {
      setState(() {
        _isFabVisible = _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  //
  // void _listen() {
  //   final check = _reference.onChildAdded;
  //   check.listen((event) {
  //     _scrollList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => navigate(context, ReceiverProfilePage(user: widget.user)),
              child: CircleAvatar(
                radius: 20,
                foregroundImage: NetworkImage(widget.user?.image ?? ""),
              ),
            ),
            const Gap(12),
            Text(widget.user?.username ?? ""),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.phone)),
          IconButton(
              onPressed: () {}, icon: const Icon(CupertinoIcons.video_camera)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _reference.onValue,
                  // _chatManager.getMessages(widget.user?.uid),
                  builder: (context, s) {
                    final snapshot = s.data?.snapshot;
                    final messageList = snapshot?.children
                        .map((e) =>
                            Message.fromJson(e.value as Map<Object?, Object?>))
                        .toList();
                    if (snapshot != null && messageList?.isNotEmpty == true) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messageList?.length,
                        itemBuilder: (context, index) {
                          if (widget.user?.uid != messageList?[index].ownerId) {
                            return SenderMessage(
                                message: messageList?[index],
                                onMessageClicked: (details) {
                                  _showMenu(details, messageList?[index]);
                                },
                                onVideoOpen: () {},
                                onImageOpen: () {});
                          } else {
                            return ReceiverMessage(
                                message: messageList?[index],
                                onUserImageClicked: () => navigate(context, ReceiverProfilePage(user: widget.user)),
                                onVideoOpen: () {},
                                onImageOpen: () {});
                          }
                        },
                      );
                    } else if (messageList?.isEmpty == true) {
                      return const Center(
                          child: Text(
                        "Say Hello",
                        style: TextStyle(fontSize: 22),
                      ));
                    }
                    return Loading();
                  }),
            ),
            if(_isEdited)
              ListTile(
                leading: Icon(CupertinoIcons.pencil),
                title: Text(_editedMessage?.text ?? ""),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _isEdited = false;
                      _editedMessage = null;
                      _controller.text = '';
                    });
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            MessageBar(
                isImageLoading: _isImageLoading,
                isVideoLoading: _isVideoLoading,
                controller: _controller,
                onOpenCamera: _openCamera,
                onOpenGallery: _openVideo,
                onSend: _sendOrEdit),
            const Gap(8)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isFabVisible
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: FloatingActionButton.small(
                onPressed: _scrollList2,
                shape: CircleBorder(),
                child: const Icon(CupertinoIcons.down_arrow),
                backgroundColor: Colors.blue,
              ),
            )
          : null,
    );
  }

  void _showMenu(TapDownDetails details, Message? message) {
    final offset = details.globalPosition;
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy,
          MediaQuery.of(context).size.width - offset.dx,
          MediaQuery.of(context).size.height - offset.dy,
        ),
        items: [
          PopupMenuItem(
            child: ListTile(trailing: Icon(Icons.copy), title: Text("Copy")),
            onTap: () {
              Clipboard.setData(ClipboardData(text: message?.text ?? ""))
                  .then((value) {
                showSuccess(context, 'Copied');
              });
            },
          ),
          PopupMenuItem(
            child: ListTile(trailing: Icon(Icons.edit), title: Text("Edit")),
            onTap: () {
              setState(() {
                _controller.text = message?.text ?? "";
                _isEdited = true;
                _editedMessage = message;
              });
            },
          ),
          PopupMenuItem(
            onTap: () {
              _deleteText(message);
            },
              child: ListTile(
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text("Delete", style: TextStyle(color: Colors.red))))
        ]);
  }

  void _openVideo() async {
    setState(() {
      _isVideoLoading = true;
    });
    final media = await _picker.pickMedia();
    if (media?.name.endsWith(".mp4") == true) {
      _galleryVideo = media;
      _chatManager
          .sendVideo(File(_galleryVideo?.path ?? ""), widget.user?.uid)
          .then((value) {
        _scrollList();
      });
    } else {
      _cameraImage = media;
      _chatManager
          .sendImage(File(_cameraImage?.path ?? ""), widget.user?.uid)
          .then((value) {
        _scrollList();
      });
    }
  }

  _sendImageMsg() {
    _chatManager
        .sendImage(File(_cameraImage?.path ?? ""), widget.user?.uid)
        .then((value) {
      _scrollList();
    });
  }

  void _deleteText(Message? message) async {
    await _chatManager.deleteText(message);
    setState(() {

    });
  }

  void _sendOrEdit() {
    if(_isEdited) {
      _chatManager
          .editText(_editedMessage, _controller.text)
          .then((value) {
     setState(() {
       _controller.text = '';
       _isEdited = false;
       _editedMessage = null;
     });
      });
    } else {
      _chatManager
          .sendTextMessage(_controller.text, widget.user?.uid)
          .then((value) {
        _scrollList();
      });
      _controller.text = '';
    }
  }

  void _openCamera() async {
    _cameraImage = await _picker.pickImage(source: ImageSource.camera);
    if (_cameraImage != null) {
      setState(() {
        _isImageLoading = true;
      });
      _sendImageMsg();
    }
  }

  void _scrollList() {
    setState(() {});
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      _isImageLoading = false;
      _isVideoLoading = false;
    });
  }

  void _scrollList2() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
