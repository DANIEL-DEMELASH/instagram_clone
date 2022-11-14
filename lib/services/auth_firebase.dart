// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart' as model;

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String imageUrl = '';

  Future<void> sendPasswordResetEmail(
      {required String email, required BuildContext context}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      if (emailValid) {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('invalid email address'),
        ));
      }
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String username,
      required String fullname,
      required File photo,
      required String phoneNumber,
      required BuildContext context}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = _firebaseAuth.currentUser!.uid;
      final ref =
          FirebaseStorage.instance.ref().child('userImages').child('$uid.jpg');
      await ref.putFile(photo);
      imageUrl = await ref.getDownloadURL();

      model.UserModel user = model.UserModel(
          username: username,
          uid: uid,
          email: email,
          bio: '',
          profileImage: imageUrl,
          name: fullname,
          phoneNumber: phoneNumber,
          followers: [],
          following: []);

      await users.doc(uid).set(user.toJson());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<void> signOut(context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const CircularProgressIndicator();
          });
      await _firebaseAuth.signOut();
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
