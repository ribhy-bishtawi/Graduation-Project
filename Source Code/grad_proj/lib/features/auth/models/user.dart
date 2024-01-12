import 'dart:convert';

class User {
  String? userName;
  String? password;
  String? type;
  String? phoneNumber;
  String? gender;
  User(
      {this.userName, this.password, this.type, this.phoneNumber, this.gender});

  factory User.fromMap(Map<String, dynamic> data) => User(
        userName: data['userName'] as String?,
        password: data['password'] as String?,
        type: data['type'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        gender: data['gender'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'userName': userName,
        'password': password,
        'type': type,
        'phoneNumber': phoneNumber,
        'gender': gender,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());
}
