import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/auth/domain/repository/authentication_repository.dart';

class RegisterUseCase extends UseCase<RegisterParams, DataState<String>> {
  final AuthenticationRepository _authenticationRepository;

  RegisterUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  @override
  Future<DataState<String>> call(RegisterParams params) async {
    return _authenticationRepository.register(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams {
  String username;
  String email;
  String password;

  RegisterParams({
    required this.username,
    required this.email,
    required this.password,
  });
}
