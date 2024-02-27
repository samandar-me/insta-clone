import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/model/message.dart';

class ChatManager {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;

  final _fb = FbManager();

  Future<void> sendTextMessage(String text, String? receiverId) async {
    final messageId = _db.ref('chats').push().key;
    final myId = _fb.getUser()?.uid;
    final senderRoom = "$myId$receiverId";
    final receiverRoom = "$receiverId$myId";
    final me = await _fb.getSelf();
    final myImage = me.user?.image;
    final newMessage = Message(
        id: messageId,
        ownerId: myId,
        ownerImage: myImage,
        receiverId: receiverId,
        type: MessageType.text,
        text: text,
        image: null,
        video: null,
        time: getTime(),
        videoId: null,
        imageId: null);
    await _db
        .ref('chats/$senderRoom/messages/$messageId')
        .set(newMessage.toJson())
        .asStream();
    await _db
        .ref('chats/$receiverRoom/messages/$messageId')
        .set(newMessage.toJson())
        .asStream();
  }

  Future<void> editText(Message? message, String newText) async {
    final newMessage = {'text': newText};
    final room = "${message?.ownerId}${message?.receiverId}";
    await _db.ref('chats/$room/messages/${message?.id}').update(newMessage);
  }

  Future<void> deleteText(Message? message) async {
    final room = "${message?.ownerId}${message?.receiverId}";
    await _db.ref('chats/$room/messages/${message?.id}').remove();
  }

  Stream<DataSnapshot> getMessages(String? receiverId) {
    final myId = _fb.getUser()?.uid;
    final room = "$myId$receiverId";
    return _db.ref("chats/$room/messages").get().asStream();
  }

  String getTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute}, ${now.day}-${now.month}-${now.year}";
  }

  Future<void> sendImage(File imageFile, String? receiverId) async {
    final imageId = DateTime.now().microsecondsSinceEpoch.toString();
    final uploadTask =
        await _storage.ref('chat_images/$imageId').putFile(imageFile);
    final imageUrl = await uploadTask.ref.getDownloadURL();
    final me = await _fb.getSelf();
    final myId = me.user?.uid;
    final senderRoom = "$myId$receiverId";
    final receiverRoom = "$receiverId$myId";
    final messageId = _db.ref('chats').push().key;
    final message = Message(
        id: messageId,
        ownerId: myId,
        ownerImage: me.user?.image,
        receiverId: receiverId,
        type: MessageType.photo,
        text: null,
        image: imageUrl,
        video: null,
        time: getTime(),
        imageId: imageId,
        videoId: null);
    await _db
        .ref('chats/$senderRoom/messages/$messageId')
        .set(message.toJson());
    await _db
        .ref('chats/$receiverRoom/messages/$messageId')
        .set(message.toJson());
  }

  Future<void> sendVideo(File videoFile, String? receiverId) async {
    final videoId = DateTime.now().microsecondsSinceEpoch.toString();
    final uploadTask =
        await _storage.ref('chat_videos/$videoId').putFile(videoFile);
    final videoUrl = await uploadTask.ref.getDownloadURL();
    final me = await _fb.getSelf();
    final myId = me.user?.uid;
    final senderRoom = "$myId$receiverId";
    final receiverRoom = "$receiverId$myId";
    final messageId = _db.ref('chats').push().key;
    final message = Message(
        id: messageId,
        ownerId: myId,
        ownerImage: me.user?.image,
        receiverId: receiverId,
        type: MessageType.video,
        text: null,
        image: null,
        video: videoUrl,
        time: getTime(),
        imageId: null,
        videoId: videoId);
    await _db
        .ref('chats/$senderRoom/messages/$messageId')
        .set(message.toJson());
    await _db
        .ref('chats/$receiverRoom/messages/$messageId')
        .set(message.toJson());
  }
}
