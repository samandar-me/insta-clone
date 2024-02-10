import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/model/fb_user.dart';
import 'package:insta_qlone/widget/loading.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

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
        IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.list_bullet))
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    foregroundImage: NetworkImage(user?.image ?? "")
                  ),
                  _buildText(user?.postCount, 'Posts'),
                  _buildText(user?.followerCount, 'Followers'),
                  _buildText(user?.followingCount, 'Following'),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
}
