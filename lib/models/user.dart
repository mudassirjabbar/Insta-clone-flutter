import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String password;
  final String photoURL;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.password,
    required this.photoURL,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'password': password,
        'bio': bio,
        'photoURL': photoURL,
        'followers': [],
        'following': [],
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      password: snapshot['password'],
      bio: snapshot['bio'],
      photoURL: snapshot['photoURL'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
