import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:insta_qlone/model/fb_user.dart';

class StoryView extends StatelessWidget {
  const StoryView({super.key, required this.user, required this.onClick});
  
  final FbUser? user;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          InkWell(
            onTap: onClick,
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple,
                    Colors.pink,
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                  ],
                  begin: Alignment.topLeft
                ),
                shape: BoxShape.circle
              ),
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                radius: 34,
                foregroundImage: NetworkImage(user?.image ?? ""),
              ),
            ),
          ),
          const Gap(5),
          Text(user?.username ?? "fafdf")
        ],
      ),
    );
  }
}
