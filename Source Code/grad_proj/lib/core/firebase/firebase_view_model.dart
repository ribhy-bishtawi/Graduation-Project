// import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/features/auth/models/user.dart' as us;
import 'package:grad_proj/widgets/GenderSelector.dart';

class FirebaseViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  bool isVerified = false;
  bool isLoading = false;
  var verificationId = "";
  var phoneNum = "";
  var username = "";
  var gender;
  bool isUserExist = false;
  bool userNotExist = false;
  bool isUserLoggedIn = false;
  us.User userData = us.User();
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<bool> signUpWithOTP(
      String phoneNo, String username, Gender gender) async {
    isUserExist = await checkUserExists(phoneNo);
    this.username = username;
    this.gender = gender;
    notifyListeners();
    if (!isUserExist) {
      phoneNum = phoneNo;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credentials) async {
          await _auth.signInWithCredential(credentials);
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId = verificationId;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            print("object");
          } else {
            print("Something else ${e}");
          }
        },
      );
      return false;
    } else {
      return true;
    }
  }

  Future<bool> loginWithOTP(String phoneNo) async {
    userNotExist = false;
    isUserExist = await checkUserExists(phoneNo);
    notifyListeners();
    if (isUserExist) {
      phoneNum = phoneNo;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credentials) async {
          await _auth.signInWithCredential(credentials);
          print("yyyyyy");
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId = verificationId;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            print("object");
            return;
          } else {
            print("Something else ${e}");
            return;
          }
        },
      );
      return true;
    } else {
      userNotExist = true;
      notifyListeners();
      return false;
    }
  }

  Future<String?> verifyOTP({required String otp}) async {
    isLoading = true;
    String? username;
    notifyListeners();
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: this.verificationId, smsCode: otp));
    credentials.user != null ? isVerified = true : isVerified = false;
    if (!isUserExist) {
      await createUser(phoneNum);
    } else {
      var apiUserData = await retriveUsername(phoneNum);
      userData.userName = apiUserData['username'];
      username = apiUserData['username'];
      userData.gender = apiUserData['gender'];
      userData.phoneNumber = apiUserData['phoneNumber'];
    }
    isLoading = false;
    notifyListeners();
    return username;
  }

  void changeUserStatus() {
    isUserLoggedIn = true;
    notifyListeners();
  }

  Future<void> createUser(String phoneNumber) async {
    await ref.child("Users").child(phoneNumber).set({
      'phoneNumber': phoneNumber,
      "username": username,
      "gender": gender.toString(),
    });
  }

  Future<Map<String, dynamic>> retriveUsername(String phoneNumber) async {
    DatabaseEvent event = await ref.child("Users").child(phoneNumber).once();
    DataSnapshot dataSnapshot = event.snapshot;

    final Map<String, dynamic> userData =
        Map<String, dynamic>.from(dataSnapshot.value as Map<dynamic, dynamic>);

    var createdUsername = userData['username'];
    return userData;
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    DatabaseEvent event = await ref.child("Users").child(phoneNumber).once();
    DataSnapshot dataSnapshot = event.snapshot;
    return dataSnapshot.value != null;
  }

  Future<bool> updateField(String phoneNumber, String gender) async {
    DatabaseReference userRef = ref.child("Users").child(phoneNumber);
    if (await checkUserExists(phoneNumber)) {
      await userRef.update({"gender": gender});
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
