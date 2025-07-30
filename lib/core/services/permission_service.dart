// ignore_for_file: unreachable_switch_default

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/services/local_storage/shared_pref_service.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';

class PermissionService {
  PermissionService._();

  static void requestPermission({
    required PermissionFor permissionFor,
    required void Function() onGrantedCallback,
    required void Function() onDeniedCallback,
    // required void Function(Future<bool> Function() openAppSettings)
    // onPermanentlyDeniedCallback,
    void Function(Future<bool> Function() openAppSettings)?
    onOthersDeniedCallback,
  }) async {
    double osVersion = 0;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      osVersion = double.tryParse(androidInfo.version.release) ?? 0;
    } else {
      IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      osVersion = double.tryParse(iosDeviceInfo.systemVersion) ?? 0;
    }

    Permission permission = Permission.storage;
    switch (permissionFor) {
      case PermissionFor.camera:
        permission = Permission.camera;
        break;

      case PermissionFor.contact:
        permission = Permission.contacts;
        break;

      case PermissionFor.microphone:
        permission = Permission.microphone;
        break;

      case PermissionFor.location:
        permission = Permission.location;
        break;

      case PermissionFor.storage:
      case PermissionFor.gallery:
      default:
        if (Platform.isAndroid) {
          if (osVersion <= 12) {
            permission = Permission.accessMediaLocation;
          } else {
            permission = Permission.photos;
          }
        }
        break;
    }

    int deniedPermissionCount =
        getIt<SharedPrefsServices>().getInt(key: permissionFor.toString()) ?? 0;

    getIt<SharedPrefsServices>().setInt(
      key: permissionFor.toString(),
      value: deniedPermissionCount + 1,
    );

    if (await permission.isGranted) {
      onGrantedCallback();
    } else {
      await permission
          .onDeniedCallback(() async {
            DebugLoggerService().log(
              "::: $permissionFor permission status: permission denied :::",
            );
            onDeniedCallback();
          })
          .onGrantedCallback(() {
            getIt<SharedPrefsServices>().setInt(
              key: permissionFor.toString(),
              value: 0,
            );
            DebugLoggerService().log(
              "::: $permissionFor permission status: permission granted :::",
            );
            onGrantedCallback();
          })
          .onPermanentlyDeniedCallback(() {
            DebugLoggerService().log(
              "::: $permissionFor permission status: permission permanently denied :::",
            );
            if (deniedPermissionCount >= 2) {
              getIt<NavigationService>()
                  .getNavigationContext()
                  .showPermissionConfirmDialog(
                    message:
                        "Please provide the permission for ${permission.toString().split('.')[1]}",
                    onConfirmed: () => openAppSettings(),
                  );
            }
          })
          .onRestrictedCallback(() {
            log(
              "::: $permissionFor permission status: permission restricted :::",
            );
            if (onOthersDeniedCallback != null) {
              onOthersDeniedCallback(openAppSettings);
            }
          })
          .onLimitedCallback(() {
            DebugLoggerService().log(
              "::: $permissionFor permission status: permission limited :::",
            );
            if (onOthersDeniedCallback != null) {
              onOthersDeniedCallback(openAppSettings);
            }
          })
          .onProvisionalCallback(() {
            DebugLoggerService().log(
              "::: $permissionFor permission status: permission provisional :::",
            );
            if (onOthersDeniedCallback != null) {
              onOthersDeniedCallback(openAppSettings);
            }
          })
          .request();
    }
  }
}

extension on BuildContext {
  void showPermissionConfirmDialog({
    required String message,
    required Future<bool> Function() onConfirmed,
  }) {}
}
