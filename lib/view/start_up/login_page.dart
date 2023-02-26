import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_twitter/model/utils/authentication.dart';
import 'package:flutter_firebase_twitter/view/screen.dart';
import 'package:flutter_firebase_twitter/view/start_up/create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Flutterラボ SNS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'メールアドレス',
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passlController,
                  decoration: InputDecoration(
                    hintText: 'パスワード',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text:
                    TextSpan(style: TextStyle(color: Colors.black), children: [
                  TextSpan(text: 'アカウントを作成していない方は'),
                  TextSpan(
                      text: 'こちら',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountPage()));
                        }),
                ]),
              ),
              SizedBox(
                height: 70,
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await Authentication.emailSignIn(
                      email: emailController.text, pass: passlController.text);
                  // if (result == true) {}
                  //条件の中に入れるとページ遷移が起こらない
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Screen()));
                },
                child: Text('emailでログイン'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
