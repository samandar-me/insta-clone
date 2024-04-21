import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/widget/loading.dart';
import 'package:insta_qlone/widget/reel_video.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final _fbManager = FbManager();
  bool _isLiked = false;
  bool _isLiked2 = false;
  String? _currentVideo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text("Reels", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.camera, color: Colors.white))
        ],
      ),
      body: FutureBuilder(
        future: _fbManager.getReelsVideos(),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data?.isNotEmpty == true) {
            final postList = snapshot.data ?? [];
            print(postList[0].video);
            return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    _currentVideo = postList[index].video;
                    return GestureDetector(
                      onDoubleTap: () async {
                        setState(() {
                          _isLiked = true;
                          _isLiked2 = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 1100));
                        setState(() {
                          _isLiked = false;
                        });
                        },
                      child: Stack(
                        children: [
                          ReelVideo(video: "https://firebasestorage.googleapis.com/v0/b/instaqlone.appspot.com/o/post_images%2F1709201250690577?alt=media&token=de16dbc3-9220-4a4b-9c65-2891f0a54bf7"),
                          Positioned(bottom: 10, right: 10, child: _icons()),
                          Center(
                            child: _isLiked ? Lottie.asset('assets/json/anim.json',repeat: false) : null
                          )
                        ],
                      ),
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
        IconButton(
            onPressed: () {},
            icon: _isLiked2 ? Icon(CupertinoIcons.heart_fill,color: Colors.red) : Icon(
              CupertinoIcons.heart,
              color: Colors.white,
            )),
        const Gap(12),
        IconButton(
            onPressed: _showCommentSection,
            icon: Icon(
              CupertinoIcons.chat_bubble,
              color: Colors.white,
            )),
        const Gap(12),
        IconButton(
            onPressed: _share,
            icon: Icon(
              CupertinoIcons.paperplane,
              color: Colors.white,
            )),
        const Gap(12),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            )),
      ],
    );
  }

  _share() async {
    if(_currentVideo != null) {
      await Share.shareUri(Uri.parse(_currentVideo ?? ""));
    }
  }

  void _showCommentSection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: DraggableScrollableSheet(
            expand: false,
            builder: (
              BuildContext context,
              ScrollController controller,
            ) {
              return MyBottomSheet(
                scrollController: controller,
              );
            },
          ),
        );
      },
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  final ScrollController scrollController;

  const MyBottomSheet({
    super.key,
    required this.scrollController,
  });

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constaints) {
        return SingleChildScrollView(
          controller: widget.scrollController,
          child: SizedBox(
            height: constaints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(index.toString()),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemCount: 100,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Text Here',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
