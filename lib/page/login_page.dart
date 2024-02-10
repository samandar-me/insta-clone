import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_qlone/manager/fb_manager.dart';
import 'package:insta_qlone/page/main_page.dart';
import 'package:insta_qlone/page/register_page.dart';
import 'package:insta_qlone/util/navigator.dart';
import 'package:insta_qlone/widget/loading.dart';

import '../util/message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  final _manager = FbManager();

  void _login() {
    setState(() {
      _isLoading = true;
    });
    _manager.login(_email.text, _password.text).then((value) {
      setState(() {
        _isLoading = false;
      });
      if(value) {
        showSuccess(context, "Success");
        navigateAndRemove(context, const MainPage());
      } else {
        showError(context, "User not found");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/insta_text.png',width: 200,height: 200),
                CupertinoTextField(
                  controller: _email,
                  padding: EdgeInsets.all(15),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white12.withOpacity(.1)
                  ),
                  placeholder: "Email, phone number or username",
                ),
                const Gap(20),
                CupertinoTextField(
                  controller: _password,
                  padding: EdgeInsets.all(15),
                  cursorColor: Colors.white,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white12.withOpacity(.1)
                  ),
                  placeholder: "Password",
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppleAuthButton(onPressed: () {},text: "Apple",darkMode: true,style: AuthButtonStyle(elevation: 1,iconSize: 25,textStyle: TextStyle(fontSize: 15,color: Colors.white))),
                    const Gap(10),
                    GoogleAuthButton(onPressed: () {}, text: "Google",darkMode: true,style: AuthButtonStyle(elevation: 1,iconSize: 25,textStyle: TextStyle(fontSize: 15,color: Colors.white))),
                    const Gap(10),
                    FacebookAuthButton(onPressed: () {}, text: "Meta",darkMode: true,style: AuthButtonStyle(elevation: 1,iconSize: 25,textStyle: TextStyle(fontSize: 15,color: Colors.white))),
                  ],
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading ? Loading() : CupertinoButton(child: Text("Login",style: TextStyle(
                    color: Colors.white
                  )), onPressed: () {
                   if(_email.text.isNotEmpty && _password.text.isNotEmpty) {
                     _login();
                   } else {
                     showError(context, "Enter data");
                   }
                  },color: Colors.blue,),
                ),
                const Gap(30),
                CupertinoButton(child: Text("Don't have an account? Register"), onPressed: () => navigate(context, const RegisterPage())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
