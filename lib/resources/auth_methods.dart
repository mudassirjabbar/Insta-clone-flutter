import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:insta_clone/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getCurrentUser() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoURL = await StorageMethos()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          password: password,
          bio: bio,
          photoURL: photoURL,
          followers: [],
          following: [],
        );

        //add user to firestore
        _firebaseFirestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging in users

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'enter all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
