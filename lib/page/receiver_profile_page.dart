import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_qlone/model/fb_user.dart';

import '../manager/fb_manager.dart';
import '../model/post.dart';
import '../widget/loading.dart';
import 'full_screen_image.dart';

class ReceiverProfilePage extends StatelessWidget {
  ReceiverProfilePage({super.key, required this.user});

  final FbUser? user;
  final _manager = FbManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(user?.username ?? ""), centerTitle: true),
        body: FutureBuilder(
          future: _manager.getInfo(user),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return _successField(
                  snapshot.data?.user, snapshot.data?.posts ?? [], context);
            }
            return const Loading();
          },
        ));
  }

  Widget _successField(FbUser? user, List<Post> posts, BuildContext context) {
    return Padding(
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
                    foregroundImage: NetworkImage(user?.image ?? "")),
              ),
              _buildText(posts.length, 'Posts'),
              _buildText(user?.followerCount, 'Followers'),
              _buildText(user?.followingCount, 'Following'),
            ],
          ),
          const Gap(30),
          _successGrid(posts)
        ],
      ),
    );
  }

  _buildText(int? count, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.baloo2(
              fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const Gap(4),
        Text(title)
      ],
    );
  }

  _successGrid(List<Post> postList) {
    print(postList.length);
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
              //    onLongPress: () => _deletePost(postList[index]),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(postList[index].image ?? "",
                      height: 130, fit: BoxFit.fill)));
        },
      ),
    );
  }
}
