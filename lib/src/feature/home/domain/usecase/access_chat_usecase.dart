import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class AccessChatUseCase extends UserCase<String, DataState<ChatEntity>> {
  final HomeRepository _homeRepository;

  AccessChatUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<DataState<ChatEntity>> call(String params) async {
    return _homeRepository.accessChat(recieverId: params);
  }
}
