import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/page/search_user_page.dart';
import 'package:insta_qlone/util/navigator.dart';
import 'package:video_player/video_player.dart';

import '../model/post.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Post> _postList = [];
  final _fb = FbManager();

  void _getPostList() async {
    _postList = await _fb.getAllPosts();
    setState(() {});
  }

  @override
  void initState() {
    _getPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchSection(),
      body: RefreshIndicator(
        color: Colors.white,
        onRefresh: () async {
          _postList.shuffle();
          setState(() {});
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 2, crossAxisSpacing: 2, crossAxisCount: 3),
          itemCount: _postList.length,
          itemBuilder: (context, index) {
            return _searchItem(_postList[index]);
          },
        ),
      ),
    );
  }

  _searchItem(Post? post) {
    final player =
        VideoPlayerController.networkUrl(Uri.parse(post?.video ?? ""));
    player.initialize();
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(2),
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.black, width: 1)),
        child: post?.image != "null"
            ? Image.network(post?.image ?? "", fit: BoxFit.cover)
            : VideoPlayer(player),
      ),
    );
  }

  _searchSection() {
    return AppBar(
      title: CupertinoTextField(
        padding: EdgeInsets.all(10),
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(CupertinoIcons.search,color: CupertinoColors.systemGrey),
        ),
        placeholder: "Search",
        readOnly: true,
        decoration: BoxDecoration(
          color: Colors.white12.withOpacity(.1),
          borderRadius: BorderRadius.circular(12)
        ),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => SearchUserPage(),
                transitionDuration: Duration(milliseconds: 100),
                transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
              ),
            );
          },
      ),
    );
  }
}
