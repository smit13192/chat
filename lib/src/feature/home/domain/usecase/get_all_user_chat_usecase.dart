import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/no_param_usecase.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class GetAllUserChatUseCase
    extends NoParamUseCase<DataState<List<ChatEntity>>> {
  final HomeRepository _homeRepository;

  GetAllUserChatUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<DataState<List<ChatEntity>>> call() async {
    return _homeRepository.getAllUserChat();
  }
}
