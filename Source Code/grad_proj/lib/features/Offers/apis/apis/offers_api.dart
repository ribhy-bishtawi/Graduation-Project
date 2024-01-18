import 'dart:convert';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/core/network/networkhelper.dart';
import 'package:grad_proj/core/network/status_code.dart';

class OffersAPI {
  static Future<List<T>> fetchOffersByPageNumber<T>(
      String endPoint,
      String token,
      Function(String) fromJson,
      int pageNumber,
      int notificationsPerPage) async {
    List<T> offers = [];
    String pagingUrl =
        "$endPoint?pageNumber=$pageNumber&pageSize=$notificationsPerPage";
    CustomResponse customResponse = await NetworkHelper.instance
        .get(url: pagingUrl, token: token, setAuthToken: true);
    if (customResponse.statusCode == StatusCode.success) {
      var offersData = customResponse.data["deals"];
      for (var offer in offersData) {
        try {
          String jsonData = json.encode(offer);
          offers.add(fromJson(jsonData) as T);
        } catch (e, sk) {
          print(e);
          print(sk);
        }
      }
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return offers;
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

  static Future<CustomResponse> deleteById<T>(
      String endpoint, String token) async {
    CustomResponse response =
        await NetworkHelper.instance.delete(url: endpoint, token: token);
    if (response.statusCode == StatusCode.success ||
        response.statusCode == StatusCode.updated) {
      return response;
    } else {
      throw response.errorMessage ?? "Something went wrong";
    }
  }
}
