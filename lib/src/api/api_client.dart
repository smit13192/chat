import 'dart:async';
import 'dart:io';

import 'package:chat/src/api/api_introceptor.dart';
import 'package:chat/src/api/exception/api_exception.dart';
import 'package:chat/src/api/failure/failure.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;
  late ApiInterceptors _apiInterceptors;

  ApiClient() {
    _dio = Dio();
    _apiInterceptors = ApiInterceptors();
    _dio.options = BaseOptions(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        if (status == null) return false;
        if (status >= 200 && status < 300) return true;
        if (status == 400 || status == 401 || status == 403) return true;
        return false;
      },
    );
    _dio.interceptors.add(_apiInterceptors.interceptorsWrapper);
  }

  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Response response = await _request(() async {
      Response response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    });
    return response.data;
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Response response = await _request(() async {
      Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    });
    return response.data;
  }

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Response response = await _request(() async {
      Response response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    });
    return response.data;
  }

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Response response = await _request(() async {
      Response response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    });
    return response.data;
  }

  Future<Response> _request(Future<Response> Function() handler) async {
    try {
      Response response = await handler();
      return response;
    } on DioException catch (e) {
      throw ApiException(Failure.failure(e.response?.statusCode ?? 500));
    } on TimeoutException {
      throw ApiException(Failure.failure(408));
    } on SocketException {
      throw ApiException(Failure.failure(500));
    } catch (e) {
      throw ApiException(Failure.failure(500));
    }
  }
}
