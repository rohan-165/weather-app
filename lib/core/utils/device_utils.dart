import 'package:device_info_plus/device_info_plus.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';

Future<String> getIEMI() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String imei = androidInfo.id;
    return imei;
  } catch (e) {
    DebugLoggerService.log("Error to generate iemi $e", level: LogLevel.error);
    return '';
  }
}
