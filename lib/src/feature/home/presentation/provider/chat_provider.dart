import 'package:chat/src/core/services/aes_cipher_service.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/entity/typing_entity.dart';
import 'package:chat/src/feature/home/domain/usecase/delete_message_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_chat_message.dart';
import 'package:chat/src/feature/home/domain/usecase/send_message_usecase.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  GetAllChatMessageUseCase getAllChatMessageUseCase;
  SendMessageUseCase sendMessageUseCase;
  DeleteMessageUseCase deleteMessageUseCase;

  ChatProvider({
    required this.getAllChatMessageUseCase,
    required this.sendMessageUseCase,
    required this.deleteMessageUseCase,
  });

  Set<MessageEntity> messages = {};
  bool isDataOver = false;
  FormzStatus _status = FormzStatus.loading;
  FormzStatus get status => _status;
  set status(FormzStatus status) {
    _status = status;
    notifyListeners();
  }

  TypingEntity? typing;
  void addTyping(TypingEntity typing) {
    this.typing = typing;
    notifyListeners();
  }

  void removeTyping(TypingEntity typing) {
    if (this.typing == null) return;
    if (this.typing! != typing) return;
    this.typing = null;
    notifyListeners();
  }

  MessageEntity? _replayToMessage;
  MessageEntity? get replyToMessage => _replayToMessage;
  set replyToMessage(MessageEntity? message) {
    _replayToMessage = message;
    notifyListeners();
  }

  Future<void> getChatMessage(String chatId, {bool isFromMain = false}) async {
    int limit = 50;
    String? lastMessageId;

    if (isDataOver && !isFromMain) return;
    if (!isFromMain) {
      lastMessageId = messages.last.messageId;
    }
    if (isFromMain) status = FormzStatus.loading;
    final result = await getAllChatMessageUseCase(
      GetAllChatMessageParams(
        chatId: chatId,
        lastMessageId: lastMessageId,
        limit: limit,
      ),
    );
    if (result.isFailure) {
      if (isFromMain) status = FormzStatus.failed;
      return;
    }
    messages = {...messages, ...result.data.allMessages};
    isDataOver = result.data.messages.length < limit;
    status = FormzStatus.success;
  }

  Future<void> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final encryptedData = AESCipherService.encrypt(message);
    final result = await sendMessageUseCase(
      SendMessageParams(
        chatId: chatId,
        message: encryptedData.encryptedData,
        messageIv: encryptedData.iv,
        replyToMessage: _replayToMessage?.messageId,
      ),
    );
    if (result.isFailure) return;
    replyToMessage = null;
  }

  Future<void> deleteMessage({required String messageId}) async {
    final result = await deleteMessageUseCase(
      DeleteMessageParams(messageId: messageId),
    );
    if (result.isFailure) return;
  }

  void addLiveChatMessage(MessageEntity message) {
    messages = {message, ...messages};
    notifyListeners();
  }

  void deleteLiveChatMessage(MessageEntity message) {
    messages.remove(message);
    notifyListeners();
  }
}
