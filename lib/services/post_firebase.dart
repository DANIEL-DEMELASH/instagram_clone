import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:uuid/uuid.dart';

class Post {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<String> uploadPost(
      {required File image, required String description}) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String postId = const Uuid().v1();
      final ref = FirebaseStorage.instance
          .ref()
          .child('postImages')
          .child('$postId.jpg');
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      PostModel postModel = PostModel(
          description: description,
          uid: uid,
          likes: [],
          postId: postId,
          // datePublished: DateTime.now(),
          postUrl: imageUrl);
      posts.doc(postId).set(postModel.toJson());
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getPosts() {
    return posts.snapshots();
  }
}
