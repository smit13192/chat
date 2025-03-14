import 'package:chat/src/api/exception/api_exception.dart';
import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/feature/auth/data/datasource/authentication_datasource.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/auth/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final ApiAuthenticationDataSource _apiAuthenticationDataSource;

  AuthenticationRepositoryImpl({
    required ApiAuthenticationDataSource apiAuthenticationDataSource,
  }) : _apiAuthenticationDataSource = apiAuthenticationDataSource;

  @override
  Future<DataState<LoginEnity>> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final response = await _apiAuthenticationDataSource.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<String>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiAuthenticationDataSource.register(
        username: username,
        email: email,
        password: password,
      );
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<UserEntity>> profile() async {
    try {
      final response = await _apiAuthenticationDataSource.profile();
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<UserEntity>> updateProfile({
    required String username,
    String? image,
  }) async {
    try {
      final response = await _apiAuthenticationDataSource.updateProfile(
        username: username,
        image: image,
      );
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }
}
