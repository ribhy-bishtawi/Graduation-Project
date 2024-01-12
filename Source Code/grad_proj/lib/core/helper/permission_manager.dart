import 'dart:io';

import 'package:location/location.dart' as l;
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> requestCamera() async {
    bool hasPermission = await Permission.camera.isGranted;
    if (hasPermission) return true;
    PermissionStatus permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) return true;
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  static Future<bool> requestStorage() async {
    bool hasPermission = await Permission.storage.isGranted;
    if (hasPermission) return true;
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) return true;
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  static Future<bool> requestMicrophone() async {
    bool hasPermission = await Permission.microphone.isGranted;
    if (hasPermission) return true;
    PermissionStatus permissionStatus = await Permission.microphone.request();
    if (permissionStatus.isGranted) return true;
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  static Future<bool> requestLocation() async {
    bool hasPermission = await Permission.location.isGranted;
    if (hasPermission) return true;
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    if (permissionStatus.isGranted) return true;
    if (permissionStatus.isRestricted || permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  static Future<bool> requestLocationServiceEnabled() async {
    if (Platform.isIOS) return true;
    l.Location location = l.Location();
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }
}
