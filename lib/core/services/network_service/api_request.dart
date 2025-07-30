// ignore_for_file: unused_field

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

  // Constructor injection: ApiManager will be injected automatically by injectable
  ApiRequestImpl(this._apiManager);

  @override
  ApiManager get apiManager => _apiManager;

  @override
  FutureDynamicResponse decodeHttpRequestResponse(
    Response? response, {
    String message = "",
  }) async {
    AppToasts toastHelper = AppToasts();
    List<int> successStatusCode = [200, 201];
    if (successStatusCode.contains(response?.statusCode)) {
      return Left({'data': response?.data, 'message': message});
    } else if (response?.statusCode == 500) {
      toastHelper.showToast(
        message: 'Server Error',
        toastType: ToastType.ERROR,
      );
      logger.log(
        'Server Error',
        level: LogLevel.error,
        tag: response?.realUri.path,
      );
      return Left(response?.data);
    } else if (response?.statusCode == 401) {
      toastHelper.showToast(
        message: 'Unauthorized',
        toastType: ToastType.ERROR,
      );
      logger.log(
        'Unauthorized',
        level: LogLevel.error,
        tag: response?.realUri.path,
      );
    } else if (response?.statusCode == 400) {
      logger.log(
        'Data Not Fount StatusCode : 400',
        level: LogLevel.error,
        tag: response?.realUri.path,
      );
      return Right(Failure.fromJson(response?.data));
    } else if (response?.statusCode == 422) {
      logger.log(
        'Something went wrong StatusCode : 422',
        level: LogLevel.error,
        tag: response?.realUri.path,
      );
      return Right(Failure.fromJson(response?.data));
    } else if (response?.data == null) {
      logger.log(
        'Data Not Fount',
        level: LogLevel.error,
        tag: response?.realUri.path,
      );
      return Right(response?.data);
    } else {
      logger.log(
        'Something went wrong',
        level: LogLevel.error,
        tag: response?.realUri.path,
      );
      return Right(Failure(message: 'Something went wrong'));
    }
    return response?.data;
  }

  @override
  FutureDynamicResponse getResponse({
    required String endPoint,
    required ApiMethods apiMethods,
    Map<String, dynamic>? queryParams,
    body,
    Options? options,
    String? errorMessage,
  }) async {
    Response? response;
    try {
      if (apiMethods == ApiMethods.post) {
        response = await apiManager.dio!.post(
          endPoint,
          data: body,
          queryParameters: queryParams,
          options: options,
        );
      } else if (apiMethods == ApiMethods.delete) {
        response = await apiManager.dio!.delete(
          endPoint,
          data: body,
          queryParameters: queryParams,
          options: options,
        );
      } else if (apiMethods == ApiMethods.put) {
        response = await apiManager.dio!.put(
          endPoint,
          data: body,
          queryParameters: queryParams,
          options: options,
        );
      } else {
        response = await apiManager.dio!.get(
          endPoint,
          queryParameters: queryParams,
          options: options,
        );
      }
      return decodeHttpRequestResponse(response, message: errorMessage ?? "");
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        logger.log(
          'Unauthorized (401) - triggering logout...',
          level: LogLevel.error,
        );
        AppToasts().showToast(
          message: 'Unauthorized access. Please log in again.',
          toastType: ToastType.ERROR,
        );
      } else {
        logger.log(
          'DioException [$statusCode] - ${e.message}',
          level: LogLevel.error,
        );
      }
      return Right(
        Failure(
          message: e.message ?? 'Network error',
          statusCode: e.response?.statusCode.toString(),
        ),
      );
    } catch (e) {
      logger.log('Unknown error: $e', level: LogLevel.error);
      return Right(Failure(message: errorMessage ?? 'Something went wrong'));
    }
  }
}
