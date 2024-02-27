import 'package:flutter/material.dart';
import 'package:insta_qlone/model/fb_user.dart';

class ReceiverProfilePage extends StatelessWidget {
  const ReceiverProfilePage({super.key, required this.user});
  final FbUser? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user?.username ?? "")),
    );
  }
}
