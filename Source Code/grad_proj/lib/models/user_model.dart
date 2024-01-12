// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// The datatype is string to store the urls of things in the database
class UserModel {
  final String name;
  final String profilePic;
  final int phoneNum;
  final String uid;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.phoneNum,
    required this.uid,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    int? phoneNum,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      phoneNum: phoneNum ?? this.phoneNum,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'phoneNum': phoneNum,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      phoneNum: map['phoneNum'] as int,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, phoneNum: $phoneNum, uid: $uid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.phoneNum == phoneNum &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        phoneNum.hashCode ^
        uid.hashCode;
  }
}
