import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String phoneNumber;
  final String name;
  final String profileImage;
  final List followers;
  final List following;

  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.bio,
      required this.phoneNumber,
      required this.name,
      required this.profileImage,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'name': name,
        'phoneNumber': phoneNumber,
        'profileImage': profileImage,
        'followers': followers,
        'following': following
      };

  factory UserModel.fromMap(DocumentSnapshot data) {
    var map = data.data() as Map<String, dynamic>;
    return UserModel(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        bio: map['bio'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        name: map['name'] ?? '',
        profileImage: map['profileImage'] ?? '',
        followers: map['followers'],
        following: map['following']);
  }
}
