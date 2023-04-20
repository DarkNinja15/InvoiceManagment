import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String email;
  String name;
  User({
    required this.uid,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'email': email});
    result.addAll({'name': name});

    return result;
  }

  static User fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data()! as Map<String, dynamic>;
    return User(
      name: snapshot['name'] ?? "",
      email: snapshot['email'] ?? "",
      uid: snapshot['uid'] ?? "",
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
