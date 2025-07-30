// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/services/permission_service.dart';

mixin LocationMixin {
  Future<LocationModel> getCurrentLocation() async {
    final completer = Completer<LocationModel>();

    PermissionService.requestPermission(
      permissionFor: PermissionFor.location,
      onGrantedCallback: () async {
        try {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
          );

          completer.complete(
            LocationModel(
              isPermissionGranted: true,
              gps: "${position.latitude},${position.longitude}",
            ),
          );
        } catch (e) {
          completer.complete(
            LocationModel(
              isPermissionGranted:
                  true, // Permission granted, but location failed
            ),
          );
        }
      },
      onDeniedCallback: () {
        completer.complete(LocationModel(isPermissionGranted: false));
      },
      onOthersDeniedCallback: (_) {
        completer.complete(LocationModel(isPermissionGranted: false));
      },
    );

    return completer.future;
  }
}

class LocationModel {
  bool? isPermissionGranted;
  String? gps;

  LocationModel({this.isPermissionGranted, this.gps});
}
