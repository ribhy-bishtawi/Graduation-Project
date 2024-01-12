import 'package:flutter/cupertino.dart';
import 'package:grad_proj/core/network/apis_constants.dart';
import 'package:grad_proj/core/network/custom_response.dart';
import 'package:grad_proj/features/notification/apis/apis/notifications_api.dart';
import 'package:grad_proj/features/notification/models/notification.dart'
    as model;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationViewModel extends ChangeNotifier {
  int? userID;
  String? userToken;
  List<model.Notification> notifications = [];
  static const numberOfShopsPerRequest = 5;
  bool loading = false;

  final PagingController<int, model.Notification> pagingController =
      PagingController(firstPageKey: 0);

  NotificationViewModel() {
    pagingController.addPageRequestListener(fetchShopsWithPagination);
  }

  Future<void> fetchShopsWithPagination(int? pageKey) async {
    try {
      loading = true;
      final notificationList = await NotificationAPIs
          .fetchNotificationByPageNumber<model.Notification>(
              APIsConstants.notification,
              userToken!,
              model.Notification.fromJson,
              pageKey!,
              numberOfShopsPerRequest);
      final filteredNotifications = notificationList
          .where((notification) => notification.senderId == userID)
          .toList();
      notifications = filteredNotifications;

      final isLastPage = filteredNotifications.length < numberOfShopsPerRequest;

      if (isLastPage) {
        pagingController.appendLastPage(filteredNotifications);
      } else {
        final nextPage = pageKey + 1;
        pagingController.appendPage(filteredNotifications, nextPage);
      }
    } catch (error) {
      pagingController.error = error;
      print("$error");
    } finally {
      loading = false;
    }
  }

  Future<CustomResponse> addNotification(
      model.Notification notification) async {
    notification.senderId = userID;
    loading = true;
    notifyListeners();
    var shopsData;
    try {
      shopsData = await NotificationAPIs.postMethod(notification,
          (obj) => obj.toJson(), APIsConstants.notification, userToken);
      notifications.add(notification);
    } catch (e) {
      print("$e");
    }
    loading = false;
    notifyListeners();
    return shopsData;
  }
}
