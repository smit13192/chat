import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class SendMessageUseCase
    extends UserCase<SendMessageParams, DataState<MessageEntity>> {
  final HomeRepository _homeRepository;

  SendMessageUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<DataState<MessageEntity>> call(
    SendMessageParams params,
  ) async {
    return _homeRepository.sendMessage(
      chatId: params.chatId,
      message: params.message,
    );
  }
}

class SendMessageParams {
  String chatId;
  String message;

  SendMessageParams({
    required this.chatId,
    required this.message,
  });
}
