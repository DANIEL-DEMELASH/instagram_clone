import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/post_firebase.dart';

enum Status { intial, loading, done, error }

class PostProvider extends ChangeNotifier {
  final Status _status = Status.intial;

  Status get status => _status;

  final Post _post = Post();

  Future<void> uploadPost(
      {required File image, required String description}) async {
    await _post.uploadPost(image: image, description: description);
    notifyListeners();
  }

  Stream<QuerySnapshot> getPosts() {
    return _post.getPosts();
  }
}
