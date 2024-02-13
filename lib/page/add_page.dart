import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/page/main_page.dart';
import 'package:insta_qlone/util/message.dart';
import 'package:insta_qlone/util/navigator.dart';
import 'package:insta_qlone/widget/loading.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  final _picker = ImagePicker();
  XFile? xFile;
  final _desc = TextEditingController();
  final _manager = FbManager();

  bool _isLoading = false;

  void _uploadNewPost() {
    if(xFile == null || _desc.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _manager.uploadPost(File(xFile?.path ?? ""), _desc.text).then((value) {
      if(value) {
        showSuccess(context, 'Successfully uploaded');
        navigateAndRemove(context, const MainPage());
      } else {
        showError(context, 'An unknown error occurred');
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("New Post"),
        actions: [
         _isLoading ? Loading() : IconButton(onPressed: _uploadNewPost, icon: const Icon(CupertinoIcons.checkmark_alt))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _imageSection(),
            const Gap(20),
            CupertinoTextField(
              controller: _desc,
              padding: EdgeInsets.all(15),
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white12.withOpacity(.1)
              ),
              placeholder: "Description for your post (optional)",
            ),
          ],
        ),
      ),
    );
  }
  _imageSection() {
    return InkWell(
        onTap: () => _launchGallery(),
        child: Ink(
          height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12)
          ),
          child: xFile == null ? const Icon(CupertinoIcons.photo,color: Colors.white) :
          ClipRRect(borderRadius: BorderRadius.circular(12),child: Image.file(File(xFile?.path ?? ""),fit: BoxFit.cover)),
        )
    );
  }
  void _launchGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if(file != null) {
      setState(() {
        xFile = file;
      });
    }
  }
}
