import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/page/chat_page.dart';
import 'package:insta_qlone/util/navigator.dart';
import 'package:insta_qlone/widget/loading.dart';
import 'package:insta_qlone/widget/my_story.dart';
import 'package:insta_qlone/widget/post_view.dart';
import 'package:insta_qlone/widget/story_view.dart';

import '../model/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _manager = FbManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/img/insta_text.png',height: 33,),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.chat_bubble)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: SizedBox(
            width: double.infinity,
            height: 120,
            child: FutureBuilder(
              future: _manager.getMeAndFriends(),
              builder: (context, snapshot) {
                if(snapshot.data != null && snapshot.data?.friends?.isNotEmpty == true) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (snapshot.data?.friends?.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if(index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.5),
                          child: MyStory(image: snapshot.data?.me?.image ?? ""),
                        );
                      }
                      return StoryView(user: snapshot.data?.friends?[index -1], onClick: () {
                        navigate(context, ChatPage(user: snapshot.data?.friends?[index -1]));
                      },);
                    },
                  );
                }
                return const Loading();
              },
            )
          ),
        ),
      ),
      body: FutureBuilder(
        future: _manager.getAllPosts(),
        builder: (context, snapshot) {
          if(snapshot.data?.isNotEmpty == true) {
            return _successField(snapshot.data ?? []);
          } else if (snapshot.data == null) {
            return const Center(child: Icon(CupertinoIcons.hourglass));
          }
          return const Loading();
        },
      ),
    );
  }
  Widget _successField(List<Post> postList) {
    return ListView.separated(
      itemCount: postList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 25),
      itemBuilder: (context, index) {
        return PostView(post: postList[index], onLiked: () {});
      },
    );
  }
}
