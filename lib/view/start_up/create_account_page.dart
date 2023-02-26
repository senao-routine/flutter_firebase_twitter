import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_twitter/model/account.dart';
import 'package:flutter_firebase_twitter/model/utils/authentication.dart';
import 'package:flutter_firebase_twitter/model/utils/firestore/users.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController namelController = TextEditingController();
  TextEditingController userIdlController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController passlController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emaillController = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        image = File(PickedFile.path);
      });
    }
  }

  Future<String> uploadImage(String uid) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image!);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    print('image_path: $downloadUrl');
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '新規登録',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                getImageFromGallery();
              },
              child: CircleAvatar(
                foregroundImage: image == null ? null : FileImage(image!),
                radius: 40,
                child: Icon(Icons.add),
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: namelController,
                decoration: InputDecoration(hintText: '名前'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                width: 300,
                child: TextField(
                  controller: userIdlController,
                  decoration: InputDecoration(hintText: 'ユーザID'),
                ),
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: selfIntroductionController,
                decoration: InputDecoration(hintText: '自己紹介'),
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: emaillController,
                decoration: InputDecoration(hintText: 'メールアドレス'),
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: passController,
                decoration: InputDecoration(hintText: 'パスワード'),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
                onPressed: () async {
                  if (namelController.text.isNotEmpty &&
                      userIdlController.text.isNotEmpty &&
                      selfIntroductionController.text.isNotEmpty &&
                      emaillController.text.isNotEmpty &&
                      passController.text.isNotEmpty &&
                      image != null) {
                    var result = await Authentication.signUp(
                        email: emaillController.text,
                        pass: passController.text);
                    if (result is UserCredential) {
                      String imagePath = await uploadImage(result.user!.uid);
                      Account newAccount = Account(
                        id: result.user!.uid,
                        name: namelController.text,
                        userId: userIdlController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath,
                      );
                      var _result = await UsersFirestore.setUser(newAccount);
                      if (_result == true) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text('アカウント作成'))
          ]),
        ),
      ),
    );
  }
}
