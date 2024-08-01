

import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';

abstract interface class AuthenticationRepository {
  Future<DataState<LoginEnity>> login({
    required String email,
    required String password,
  });

  Future<DataState<String>> register({
    required String username,
    required String email,
    required String password,
  });

  Future<DataState<UserEntity>> profile();
}
