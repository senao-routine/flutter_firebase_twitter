import 'package:cloud_firestore/cloud_firestore.dart';

import '../../account.dart';

class UsersFirestore {
  static final _firestoreIncetance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreIncetance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'users_id': newAccount.userId,
        'self_introducion': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('新規ユーザー作成エラー');
      return false;
    }
  }
}
