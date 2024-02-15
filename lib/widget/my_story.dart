import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyStory extends StatelessWidget {
  const MyStory({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                foregroundImage: NetworkImage(image),
              ),
              Positioned(child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle
                ),
                child: const Icon(CupertinoIcons.add,size: 12,),
              ),
                right: 2,
                bottom: 2,
              )
            ],
          ),
          const Gap(5),
          Text('My story')
        ],
      )
    );
  }
}
