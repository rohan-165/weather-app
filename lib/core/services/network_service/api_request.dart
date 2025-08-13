import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/common/failure_state.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/constants/typedef.dart';
import 'package:weather_app/core/services/network_service/api_manager.dart';
import 'package:weather_app/core/utils/app_toast.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';

enum ApiMethods { get, post, delete, put }

abstract class ApiRequest {
  ApiManager get apiManager;

  FutureDynamicResponse decodeHttpRequestResponse(
    Response? response, {
    String message = "",
  });

  FutureDynamicResponse getResponse({
    required String endPoint,
    required ApiMethods apiMethods,
    Map<String, dynamic>? queryParams,
    dynamic body,
    Options? options,
    String? errorMessage,
  });
}

@LazySingleton(as: ApiRequest)
class ApiRequestImpl implements ApiRequest {
  final ApiManager _apiManager;
  final DebugLoggerService logger = DebugLoggerService();
  final toastHelper = AppToasts();
  ApiRequestImpl(this._apiManager);
  @override
  ApiManager get apiManager => _apiManager;

  @override
  FutureDynamicResponse decodeHttpRequestResponse(
    Response? response, {
    String message = "",
  }) async {
    final statusCode = response?.statusCode;
    final path = response?.realUri.path;
    final data = response?.data;

    void logError(String msg) =>
        logger.log(msg, level: LogLevel.error, tag: path);

    // ✅ Success case
    if (statusCode == 200 || statusCode == 201) {
      return Left({'data': data, 'message': message});
    }

    // ✅ Common error handling
    switch (statusCode) {
      case 500:
        toastHelper.showToast(
          message: 'Server Error',
          toastType: ToastType.ERROR,
        );
        logError('Server Error');
        return Right(
          Failure(message: 'Unauthorized', statusCode: statusCode.toString()),
        );

      case 401:
        toastHelper.showToast(
          message: 'Unauthorized',
          toastType: ToastType.ERROR,
        );
        logError('Unauthorized');
        // AppClearService().clearAllData();
        return Right(
          Failure(message: 'Unauthorized', statusCode: statusCode.toString()),
        );

      case 400:
        logError('Bad Request (400)');
        return Right(Failure.fromJson(data));

      case 403:
        toastHelper.showToast(
          message: 'Forbidden - You do not have permission.',
          toastType: ToastType.ERROR,
        );
        logError('Forbidden (403)');
        return Right(Failure.fromJson(data));

      case 404:
        toastHelper.showToast(message: 'Not Found', toastType: ToastType.ERROR);
        logError('Resource Not Found (404)');
        return Right(Failure.fromJson(data));

      case 422:
        logError('Unprocessable Entity (422)');
        return Right(Failure.fromJson(data));

      default:
        if (data == null) {
          logError('Data Not Found');
          return Right(Failure(message: 'Data Not Found'));
        }
        logError('Unknown Error - Status: $statusCode');
        return Right(Failure(message: 'Something went wrong'));
    }
  }

  @override
  FutureDynamicResponse getResponse({
    required String endPoint,
    required ApiMethods apiMethods,
    Map<String, dynamic>? queryParams,
    dynamic body,
    Options? options,
    String? errorMessage,
  }) async {
    try {
      final dioInstance = apiManager.dio!;
      final Response response;

      switch (apiMethods) {
        case ApiMethods.post:
          response = await dioInstance.post(
            endPoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;

        case ApiMethods.delete:
          response = await dioInstance.delete(
            endPoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;

        case ApiMethods.put:
          response = await dioInstance.put(
            endPoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;

        case ApiMethods.get:
          response = await dioInstance.get(
            endPoint,
            queryParameters: queryParams,
            options: options,
          );
          break;
      }

      return decodeHttpRequestResponse(response, message: errorMessage ?? '');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      String errorMessage;

      switch (statusCode) {
        case 401:
          errorMessage = 'Unauthorized access. Please log in again.';
          logger.log(
            'Unauthorized (401) - triggering logout...',
            level: LogLevel.error,
          );
          // AppClearService().clearAllData();
          break;

        case 403:
          errorMessage =
              'Forbidden: You don\'t have permission to access this resource.';
          logger.log('Forbidden (403)', level: LogLevel.error);
          break;

        case 404:
          errorMessage = 'Requested resource not found.';
          logger.log('Not Found (404)', level: LogLevel.error);
          break;

        case 500:
          errorMessage = 'Server error. Please try again later.';
          logger.log('Internal Server Error (500)', level: LogLevel.error);
          break;

        default:
          errorMessage = e.message ?? 'Unexpected network error';
          logger.log(
            'DioException [$statusCode] - ${e.message}',
            level: LogLevel.error,
          );
      }

      // Show toast for the error
      toastHelper.showToast(message: errorMessage, toastType: ToastType.ERROR);

      return Right(
        Failure(message: errorMessage, statusCode: statusCode?.toString()),
      );
    } catch (e) {
      logger.log('Something went wrong', level: LogLevel.error);
      return Right(Failure(message: errorMessage ?? 'Something went wrong'));
    }
  }
}
