import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../model/fb_user.dart';

class FbManager {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance;
  final _storage = FirebaseStorage.instance;

  User? getUser() => _auth.currentUser;

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }
  /// File -> dart:io dan bo'sin
  Future<bool> register(String email, String password, String fullName, String bio, File image) async {
    try {
      final registerResponse =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(registerResponse.user == null) {
        return false;
      }
      final imageId = DateTime.now().microsecondsSinceEpoch.toString();
      final uploadTask = await _storage.ref('user_images/$imageId').putFile(image);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      final newUser = {
        'uid': registerResponse.user?.uid,
        'image': imageUrl,
        'email': email,
        'username': fullName,
        'bio': bio,
        'password': password,
        'post_count': 0,
        'following_count': 0,
        'follower_count': 0
      };
      await _db.ref('users/${registerResponse.user?.uid}').set(newUser);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }
  Future<FbUser?> getSelf() async {
    final uid = getUser()?.uid;
    final map = await _db.ref('users').child('$uid').get();
    return FbUser.fromJson(map.value as Map<Object?, Object?>);
  }
}
