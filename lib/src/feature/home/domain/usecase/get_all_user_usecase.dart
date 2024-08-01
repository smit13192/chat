import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class GetAllUserUseCase
    extends UserCase<GetAllUserParams, DataState<List<UserEntity>>> {
  final HomeRepository _homeRepository;

  GetAllUserUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<DataState<List<UserEntity>>> call(GetAllUserParams params) async {
    return _homeRepository.getAllUser(
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetAllUserParams {
  int skip;
  int limit;

  GetAllUserParams({
    required this.skip,
    required this.limit,
  });
}
