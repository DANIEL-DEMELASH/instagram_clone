import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

enum Status { intial, loading, done, error }

class UserProvider extends ChangeNotifier {
  Status _status = Status.intial;

  UserModel? _user;

  UserModel get getUser => _user!;

  Status get status => _status;

  Future<void> getUserData() async {
    try {
      _status = Status.loading;
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      _user = UserModel.fromMap(data);
      _status = Status.done;
    } catch (e) {
      _status = Status.error;
    }
    notifyListeners();
  }
}
