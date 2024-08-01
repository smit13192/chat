import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class DeleteMessageUseCase
    extends UserCase<DeleteMessageParams, DataState<MessageEntity>> {
  final HomeRepository _homeRepository;

  DeleteMessageUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<DataState<MessageEntity>> call(
    DeleteMessageParams params,
  ) async {
    return _homeRepository.deleteMessage(messageId: params.messageId);
  }
}

class DeleteMessageParams {
  String messageId;

  DeleteMessageParams({
    required this.messageId,
  });
}
