import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/widget/loading.dart';
import 'package:insta_qlone/widget/reel_video.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final _fbManager = FbManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text("Reels", style: TextStyle(color: Colors.white)
        )
        ,
        actions
            :
        [
          IconButton
            (
              onPressed
                  :
                  () {}, icon: Icon(CupertinoIcons.camera, color: Colors.white))
        ],
      ),
      body: FutureBuilder(
        future: _fbManager.getReelsVideos(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data?.isNotEmpty == true) {
            final postList = snapshot.data ?? [];
            return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ReelVideo(video: postList[index].video),
                        Positioned(
                            bottom: 10,
                            right: 10,
                            child: _icons())
                      ],
                    );
                  },
                ));
          } else {
            return Loading();
          }
        },
      ),
    );
  }
    _icons() {
      return Column(
        children: [
          IconButton(onPressed: () {},
              icon: Icon(CupertinoIcons.heart, color: Colors.white,)),
          const Gap(12),
          IconButton(onPressed: () {},
              icon: Icon(CupertinoIcons.chat_bubble, color: Colors.white,)),
          const Gap(12),
          IconButton(onPressed: () {},
              icon: Icon(CupertinoIcons.paperplane, color: Colors.white,)),
          const Gap(12),
          IconButton(onPressed: () {},
              icon: Icon(Icons.more_horiz, color: Colors.white,)),
        ],
      );
    }
  }
