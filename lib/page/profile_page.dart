import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/model/fb_user.dart';
import 'package:insta_qlone/page/full_screen_image.dart';
import 'package:insta_qlone/page/login_page.dart';
import 'package:insta_qlone/util/message.dart';
import 'package:insta_qlone/util/navigator.dart';
import 'package:insta_qlone/widget/loading.dart';

import '../model/post.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _manager = FbManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _manager.getSelf(),
      builder: (context, snapshot) {
        if(snapshot.data != null) {
          return _successField(snapshot.data);
        }
        return const Loading();
      },
    );
  }

  Widget _successField(FbUser? user) {
    return Scaffold(
      appBar: AppBar(title: Text(user?.username ?? ""),centerTitle: true,actions: [
        IconButton(onPressed: _logOut, icon: const Icon(Icons.exit_to_app,color: Colors.red))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => FullScreenImage(image: user?.image ?? "")
                    ));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    foregroundImage: NetworkImage(user?.image ?? "")
                  ),
                ),
                _buildText(user?.postCount, 'Posts'),
                _buildText(user?.followerCount, 'Followers'),
                _buildText(user?.followingCount, 'Following'),
              ],
            ),
            const Gap(30),
            FutureBuilder(
              future: _manager.getMyPosts(),
              builder: (context, snapshot) {
                if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
                  return _successGrid(snapshot.data ?? []);
                } else if(snapshot.data?.isEmpty == true) {
                  return Center(child: Icon(CupertinoIcons.battery_empty));
                }
                return const Loading();
              },
            )
          ],
        ),
      ),
    );
  }
  /// do import
  _successGrid(List<Post> postList) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: postList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () => _deletePost(postList[index]),
              child: ClipRRect(borderRadius: BorderRadius.circular(12),child: Image.network(postList[index].image ?? "",height: 120)));
        },
      ),
    );
  }

  void _deletePost(Post post) {
    _manager.deletePost(post).then((value) {
      showSuccess(context, 'Post deleted');
      setState(() {});
    });
  }

  _buildText(int? count, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(count.toString(), style: GoogleFonts.baloo2(
          fontSize: 19,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        const Gap(4),
        Text(title)
      ],
    );
  }
  void _logOut() {
    showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
      title: Text("Log out?"),
      actions: [
        CupertinoDialogAction(child: Text("No"),onPressed: () => Navigator.of(context).pop()),
        CupertinoDialogAction(child: Text("Yes"), isDestructiveAction: true,onPressed: () {
          _manager.logOut().then((value) {
            navigateAndRemove(context, const LoginPage());
          });
        }),
      ],
    ));
  }
}
