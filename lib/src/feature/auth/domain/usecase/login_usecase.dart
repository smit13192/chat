import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/auth/domain/repository/authentication_repository.dart';

class LoginUseCase extends UseCase<LoginParams, DataState<LoginEnity>> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  @override
  Future<DataState<LoginEnity>> call(LoginParams params) async {
    return _authenticationRepository.login(
      email: params.email,
      password: params.password,
      fcmToken: params.fcmToken,
    );
  }
}

class LoginParams {
  String email;
  String password;
  String fcmToken;


  LoginParams({
    required this.email,
    required this.password,
    required this.fcmToken,
  });
}
