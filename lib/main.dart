import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/page/login_page.dart';
import 'package:insta_qlone/page/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _manager = FbManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: _manager.getUser() == null ? LoginPage() : const MainPage(),
    );
  }
}

