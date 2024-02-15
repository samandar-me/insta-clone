import 'package:insta_qlone/model/fb_user.dart';

class MeAndFriends {
  final FbUser? me;
  final List<FbUser>? friends;

  MeAndFriends(this.me, this.friends);
}