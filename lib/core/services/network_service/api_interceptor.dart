import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({this.dioInstance});

  final Dio? dioInstance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String accessToken = '';

    if (accessToken.isNotEmpty) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $accessToken');
    }
    return super.onRequest(options, handler);
  }
}
