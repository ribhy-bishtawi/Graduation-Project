import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/core/network/networkhelper.dart';
import 'package:grad_proj/core/network/status_code.dart';

class UsersAPIs {
  static Future<CustomResponse> postMethod<T>(T field,
      String Function(T) toJson, String endpoint, String? token) async {
    CustomResponse customResponse = await NetworkHelper.instance
        .post(token: token, url: endpoint, body: toJson(field));
    if (customResponse.statusCode == StatusCode.created ||
        customResponse.statusCode == StatusCode.success) {
    } else {
      throw customResponse.errorMessage ?? "something went wrongdsadsads";
    }
    return customResponse;
  }

  static Future<CustomResponse> updateEntity<T>(T field,
      String? Function(T) toJson, String endpoint, String? token) async {
    CustomResponse customResponse =
        await NetworkHelper.instance.put(url: endpoint, body: toJson(field));
    if (customResponse.statusCode == StatusCode.created ||
        customResponse.statusCode == StatusCode.updated) {
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return customResponse;
  }
}
