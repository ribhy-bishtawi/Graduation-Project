import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:grad_proj/core/network/apis_constants.dart';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/core/network/networkhelper.dart';
import 'package:grad_proj/core/network/status_code.dart';

class ShopsAPIs {
  static Future<List<T>> fetchAll<T>(
      String endpoint, String responseFieldName, T Function(String) fromJson,
      {Map<String, dynamic>? queryParameters}) async {
    List<T> elementsList = [];
    CustomResponse customResponse = await NetworkHelper.instance
        .get(url: endpoint, queryParameters: queryParameters);
    if (customResponse.statusCode == StatusCode.success) {
      var categoryData = customResponse.data[responseFieldName];
      for (var category in categoryData) {
        try {
          String jsonData = json.encode(category);
          elementsList.add(fromJson(jsonData));
        } catch (e, sk) {
          print("$e");
          print("$sk");
        }
      }
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return elementsList;
  }

  static Future<List<T>> fetchShopsByPageNumber<T>(String endPoint,
      Function(String) fromJson, int pageNumber, int shopsPerPage) async {
    List<T> shops = [];
    String pagingUrl =
        "$endPoint?pageNumber=$pageNumber&pageSize=$shopsPerPage";
    CustomResponse customResponse =
        await NetworkHelper.instance.get(url: pagingUrl);
    if (customResponse.statusCode == StatusCode.success) {
      var shopsData = customResponse.data["entitys"];
      for (var shop in shopsData) {
        try {
          String jsonData = json.encode(shop);
          shops.add(fromJson(jsonData) as T);
        } catch (e, sk) {
          print(e);
          print(sk);
        }
      }
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return shops;
  }

  static Future<List<T>> fetchListById<T>(String endpoint,
      T Function(String) fromJson, String responseFieldName) async {
    List<T> elementsList = [];
    CustomResponse customResponse =
        await NetworkHelper.instance.get(url: endpoint);
    if (customResponse.statusCode == StatusCode.success) {
      var workingDays = customResponse.data[responseFieldName];

      for (var workingDay in workingDays) {
        try {
          String jsonData = json.encode(workingDay);
          elementsList.add(fromJson(jsonData));
        } catch (e, sk) {
          print("$e");
          print("$sk");
        }
      }
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return elementsList;
  }

  static Future<CustomResponse> updateField(List<int> ids,
      String requestBodyValue, String endpoint, String token) async {
    Map<String, dynamic> requestBody = {
      requestBodyValue: ids,
    };
    String requestBodyJson = json.encode(requestBody);
    CustomResponse customResponse = await NetworkHelper.instance
        .put(url: endpoint, body: requestBodyJson, token: token);
    if (customResponse.statusCode! >= StatusCode.created &&
        customResponse.statusCode! < 300) {
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return customResponse;
  }

  static Future<CustomResponse> addField<T>(T field, String Function(T) toJson,
      String endpoint, String? token) async {
    CustomResponse customResponse = await NetworkHelper.instance
        .post(url: endpoint, body: toJson(field), token: token);
    if (customResponse.statusCode == StatusCode.created) {
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return customResponse;
  }

  static Future<CustomResponse> updateEntity<T>(T field,
      String? Function(T) toJson, String endpoint, String token) async {
    CustomResponse customResponse = await NetworkHelper.instance
        .put(url: endpoint, body: toJson(field), token: token);
    if (customResponse.statusCode == StatusCode.created ||
        customResponse.statusCode == StatusCode.updated) {
    } else {
      throw customResponse.errorMessage ?? "something went wrong";
    }
    return customResponse;
  }

  static Future<String> uploadImage(String path) async {
    String fileName = path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        path,
        filename: fileName,
        contentType: MediaType("image", "jpeg"),
      ),
    });
    CustomResponse customResponse = await NetworkHelper.instance
        .post(url: APIsConstants.uploadImage, formData: formData);
    return customResponse.data['imageName'];
  }

  static Future<T> fetchById<T>(
      String endpoint, T Function(Map<String, dynamic>) fromMap) async {
    T? element;
    CustomResponse customResponse =
        await NetworkHelper.instance.get(url: endpoint);
    if (customResponse.statusCode == StatusCode.success) {
      var data = customResponse.data;
      if (data != null && data.isNotEmpty) {
        element = fromMap(data);
      }
    } else {
      throw customResponse.errorMessage ?? "Something went wrong";
    }
    return element!;
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
