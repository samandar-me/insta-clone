import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                  padding: EdgeInsets.all(15),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white12.withOpacity(.1)
                  ),
                  placeholder: "Fullname",
                ),
                const Gap(20),
                CupertinoTextField(
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
                CupertinoTextField(
                  padding: EdgeInsets.all(15),
                  cursorColor: Colors.white,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white12.withOpacity(.1)
                  ),
                  placeholder: "Password Confirm",
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
                  child: CupertinoButton(child: Text("Register",style: TextStyle(
                      color: Colors.white
                  )), onPressed: () {},color: Colors.blue,),
                ),
                const Gap(30),
                CupertinoButton(child: Text("Already have an account? Login"), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
