import 'dart:convert';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/core/network/networkhelper.dart';
import 'package:grad_proj/core/network/status_code.dart';

class NotificationAPIs {
  static Future<List<T>> fetchNotificationByPageNumber<T>(
      String endPoint,
      String token,
      Function(String) fromJson,
      int pageNumber,
      int notificationsPerPage) async {
    List<T> notifications = [];
    String pagingUrl =
        "$endPoint?pageNumber=$pageNumber&pageSize=$notificationsPerPage";
    CustomResponse customResponse = await NetworkHelper.instance
        .get(url: pagingUrl, token: token, setAuthToken: true);
    if (customResponse.statusCode == StatusCode.success) {
      var notificationsData = customResponse.data["notifications"];
      for (var notification in notificationsData) {
        try {
          String jsonData = json.encode(notification);
          notifications.add(fromJson(jsonData) as T);
        } catch (e, sk) {
          print(e);
          print(sk);
        }
      }
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return notifications;
  }

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
}
