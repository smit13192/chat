import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/no_param_usecase.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/auth/domain/repository/authentication_repository.dart';

class ProfileUseCase extends NoParamUseCase<DataState<UserEntity>> {
  final AuthenticationRepository _authenticationRepository;

  ProfileUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  @override
  Future<DataState<UserEntity>> call() async {
    return _authenticationRepository.profile();
  }
}
