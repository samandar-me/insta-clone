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
    final newMessage = Message(id: messageId, ownerId: myId, ownerImage: myImage, receiverId: receiverId, type: MessageType.text, text: text, image: null, video: null, time: getTime());
    await _db.ref('chats/$senderRoom/$messageId').set(newMessage.toJson());
    await _db.ref('chats/$receiverRoom/$messageId').set(newMessage.toJson());
  }
  Future<List<Message>> getMessages(String? receiverId) async {
    final myId = _fb.getUser()?.uid;
    final room = "$myId$receiverId";
    final snapshot = await _db.ref('chats/$room').get();
    return snapshot.children.map((e) => Message.fromJson(e.value as Map<Object?, Object?>)).toList();
  }
  String getTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute}, ${now.day}-${now.month}-${now.year}";
  }
}