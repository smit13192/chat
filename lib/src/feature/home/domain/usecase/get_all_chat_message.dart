import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/core/usecase/usecase.dart';
import 'package:chat/src/feature/home/domain/entity/chat_message_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class GetAllChatMessageUseCase
    extends UserCase<GetAllChatMessageParams, DataState<ChatMessageEntity>> {
  final HomeRepository _homeRepository;

  GetAllChatMessageUseCase({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<DataState<ChatMessageEntity>> call(
    GetAllChatMessageParams params,
  ) async {
    return _homeRepository.getAllChatMessage(
      chatId: params.chatId,
      lastMessageId: params.lastMessageId,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetAllChatMessageParams {
  String chatId;
  String? lastMessageId;
  int? skip;
  int? limit;

  GetAllChatMessageParams({
    required this.chatId,
    this.lastMessageId,
    this.skip,
    this.limit,
  });
}
