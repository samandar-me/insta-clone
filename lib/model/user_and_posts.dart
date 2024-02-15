import 'package:insta_qlone/model/fb_user.dart';
import 'package:insta_qlone/model/post.dart';

class UserAndPosts {
  FbUser? user;
  List<Post>? posts;

  UserAndPosts(this.user, this.posts);
}