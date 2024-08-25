import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/auth/domain/repository/authentication_repository.dart';

class UpdateProfileUseCase
    extends UserCase<UpdateProfileParams, DataState<UserEntity>> {
  final AuthenticationRepository _authenticationRepository;

  UpdateProfileUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  @override
  Future<DataState<UserEntity>> call(UpdateProfileParams params) async {
    return _authenticationRepository.updateProfile(
      username: params.username,
      image: params.image,
    );
  }
}

class UpdateProfileParams {
  String username;
  String? image;

  UpdateProfileParams({
    required this.username,
    this.image,
  });
}
