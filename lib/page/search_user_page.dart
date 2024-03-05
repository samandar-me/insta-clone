import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/model/fb_user.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final _controller = TextEditingController();
  Timer? _timer;
  final _userList = <FbUser>[];
  final _cachedList = <FbUser>[];
  final _fb = FbManager();

  @override
  void initState() {
    _getAllUsers();
    super.initState();
  }

  _getAllUsers() async {
    final meAndFriends = await _fb.getMeAndFriends();
    _userList.clear();
    _userList.addAll(meAndFriends.friends ?? []);
  }

  void _search(String query) {
    if(_timer?.isActive == true) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 700), () {
      _cachedList.clear();
      print('timer');
      final filteredList = _userList.where((e) => e.username?.toLowerCase().trim().contains(query.trim().toLowerCase()) ?? false).toList();
      _cachedList.addAll(filteredList);
      setState(() {
        print("@@@${_cachedList.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchSection(),
      body: ListView.builder(
        itemCount: _cachedList.length,
        itemBuilder: (context, index) {
          final user = _cachedList[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              foregroundImage: NetworkImage(user.image ?? ""),
            ),
            title: Text(user.username ?? ""),
          );
        },
      ),
    );
  }
  _searchSection() {
    return AppBar(
      leadingWidth: 24,
      title: CupertinoTextField(
        controller: _controller,
        onChanged: _search,
        style: TextStyle(color: Colors.white),
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(CupertinoIcons.search,color: CupertinoColors.systemGrey),
        ),
        placeholder: "Search",
        decoration: BoxDecoration(
            color: Colors.white12.withOpacity(.1),
            borderRadius: BorderRadius.circular(12)
        ),
        suffix: _controller.text.trim().isNotEmpty ? IconButton(
          onPressed: () {
            _cachedList.clear();
            _controller.text = '';
            setState(() {

            });
          },
          icon: const Icon(CupertinoIcons.clear,color: CupertinoColors.systemGrey),
        ) : null,
      ),
    );
  }
}
