import 'package:chat/src/api/api_client.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/api/exception/api_exception.dart';
import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/core/model/common_model.dart';
import 'package:chat/src/feature/auth/data/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class ApiAuthenticationDataSource {
  final ApiClient _apiClient;

  ApiAuthenticationDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) => LoginModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<String> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      Endpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    final result = CommonModel.fromMap(response);
    if (result.success) {
      return result.message!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<UserModel> profile() async {
    final response = await _apiClient.get(Endpoints.profile);
    final result = CommonModel.fromMap(
      response,
      handler: (data) => UserModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<UserModel> updateProfile({
    required String username,
    String? image,
  }) async {
    Map<String, dynamic> map = {'username': username};
    if (image != null) {
      map['image'] = await MultipartFile.fromFile(
        image,
        contentType: MediaType.parse('image/jpg'),
      );
    }
    FormData data = FormData.fromMap(map);
    final response = await _apiClient.put(
      Endpoints.updateProfile,
      data: data,
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) => UserModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }
}

class LocalAuthenticationDataSource {}
