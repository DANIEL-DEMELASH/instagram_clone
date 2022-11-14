import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final List likes;
  final String postId;
  // final DateTime datePublished;
  final String postUrl;

  const PostModel({
    required this.description,
    required this.uid,
    required this.likes,
    required this.postId,
    // required this.datePublished,
    required this.postUrl,
  });

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      // datePublished: snapshot["datePublished"],
      postUrl: snapshot['postUrl'],
    );
  }

  static PostModel fromMap(Map<String, dynamic> map) {
    return PostModel(
        description: map['description'],
        uid: map['uid'],
        likes: map['likes'],
        postId: map['postId'],
        // datePublished: map['datePublished'],
        postUrl: map['postUrl']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "postId": postId,
        // "datePublished": datePublished,
        'postUrl': postUrl,
      };
}
