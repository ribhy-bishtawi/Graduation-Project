import 'package:flutter/cupertino.dart';
import 'package:grad_proj/core/firebase/firebase_view_model.dart';
import 'package:grad_proj/core/network/apis_constants.dart';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/features/auth/apis/users_api.dart';
import 'package:grad_proj/features/auth/models/user.dart';
import 'package:provider/provider.dart';

class AuthViewModel extends ChangeNotifier {
  bool loading = false;
  bool isPhoneNumberAlreadyUsed = false;

  String? adminUserToken;
  int? userID;
  String? phoneNum;
  final GlobalKey<FormState> mainFormKey = GlobalKey<FormState>();

  Future<void> loginToSuperUser() async {
    loading = true;
    User user = User(
      userName: "ribhi",
      password: "123456",
    );
    notifyListeners();
    try {
      var shopsData = await UsersAPIs.postMethod(
          user, (obj) => obj.toJson(), APIsConstants.userLogin, adminUserToken);
      adminUserToken = shopsData.data["token"];
    } catch (e) {
      print("$e");
    }
    loading = false;
    notifyListeners();
  }

  Future<void> userRegister(User user) async {
    loading = true;
    notifyListeners();
    try {
      var shopsData = await UsersAPIs.postMethod(user, (obj) => obj.toJson(),
          APIsConstants.userRegister, adminUserToken);
      int id = shopsData.data["id"];
    } catch (e) {
      print("$e");
    }
    loading = false;
    notifyListeners();
  }

  Future<CustomResponse> loginToUser(String? username) async {
    loading = true;
    User user = User(
      userName: username,
      password: "123456",
    );
    notifyListeners();
    var shopsData;
    try {
      shopsData = await UsersAPIs.postMethod(
          user, (obj) => obj.toJson(), APIsConstants.userLogin, adminUserToken);
      adminUserToken = shopsData.data["token"];
      userID = shopsData.data["userId"];
    } catch (e) {
      print("$e");
    }
    loading = false;
    notifyListeners();
    return shopsData;
  }

  bool validateForm(bool isUserExist) {
    if (mainFormKey.currentState!.validate() && !isUserExist) {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateUser(User user) async {
    loading = true;
    List<Future> futureActions = [];
    notifyListeners();
    try {
      int id = userID!;
      await UsersAPIs.updateEntity(user, (obj) => obj.toJson(),
          "${APIsConstants.users}/$id", adminUserToken!);
    } catch (e) {
      print("$e");
    }
    loading = false;
    notifyListeners();
  }
}
