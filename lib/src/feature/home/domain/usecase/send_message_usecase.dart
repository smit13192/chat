import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class SendMessageUseCase
    extends UseCase<SendMessageParams, DataState<MessageEntity>> {
  final HomeRepository _homeRepository;

  SendMessageUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  @override
  Future<DataState<MessageEntity>> call(SendMessageParams params) async {
    return _homeRepository.sendMessage(
      chatId: params.chatId,
      message: params.message,
      messageIv: params.messageIv,
      replyToMessage: params.replyToMessage,
      attachment: params.attachment,
      height: params.height,
      width: params.width,
    );
  }
}

class SendMessageParams {
  String chatId;
  String message;
  String messageIv;
  String? replyToMessage;
  String? attachment;
  double? height;
  double? width;

  SendMessageParams({
    required this.chatId,
    required this.message,
    required this.messageIv,
    this.replyToMessage,
    this.attachment,
    this.height,
    this.width,
  });
}
