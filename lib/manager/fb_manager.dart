import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_qlone/model/post.dart';
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
  Future<bool> uploadPost(File imageFile, String desc) async {
    try {
      final imageId = DateTime.now().microsecondsSinceEpoch.toString(); /// identification for post image
      final uploadTask = await _storage.ref('post_images').child(imageId).putFile(imageFile); /// task of uploading image to storage
      final imageUrl = await uploadTask.ref.getDownloadURL(); /// getting image access url from uploaded image storage

      final postId = _db.ref('posts').push().key; /// this code generates new id like "3fFadajhdaH12" for our new post
      final user = await getSelf(); /// getting self from db
      final currentDate = DateTime.now().toLocal().toString(); /// getting current time from system
      final postBody = Post(  /// creating new post to upload real time database
          id: postId,
          image: imageUrl,
          desc: desc,
          ownerName: user?.username,
          ownerImage: user?.image,
          ownerId: user?.uid,
          date: currentDate,
          imageId: imageId);

      await _db.ref('posts/$postId').set(postBody.toJson()); /// upload to realtime database our new post
      return true; /// if these operations becomes success, returns true
    } catch(e) {
      print(e.toString());
      return false; /// or returns error
    }
  }
  Future<List<Post>> getMyPosts() async { /// getting all my posts
    final List<Post> postList = []; /// creating empty list with Post type
    final map = await _db.ref('posts').get(); /// get all posts from realtime database
    for(var post in map.children) { /// runs in post list
      final mapValue = Post.fromJson(post.value as Map<Object?, Object?>); /// converts map to post class
      if(mapValue.ownerId == getUser()?.uid) { /// checks each post that belong to self
        postList.add(mapValue); /// adds each post after that post is self
      }
    }
    return postList; /// returns filtered post list
  }
  Future<void> logOut() async {
    await _auth.signOut(); /// the end
  }
  Future<bool> deletePost(Post? post) async {
    await _storage.ref('post_images/${post?.imageId}');
    await _db.ref('posts/${post?.id}').remove();
    return true;
  }
}
