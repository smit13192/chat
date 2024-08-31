import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/core/services/aes_cipher_service.dart';
import 'package:chat/src/core/services/socket_service.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/feature/home/data/model/chat_model.dart';
import 'package:chat/src/feature/home/data/model/message_model.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/chat_message_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/usecase/delete_message_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_chat_message.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_user_chat_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/send_message_usecase.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  GetAllChatMessageUseCase getAllChatMessageUseCase;
  SendMessageUseCase sendMessageUseCase;
  GetAllUserChatUseCase getAllUserChatUseCase;
  DeleteMessageUseCase deleteMessageUseCase;

  ChatProvider({
    required this.getAllChatMessageUseCase,
    required this.sendMessageUseCase,
    required this.getAllUserChatUseCase,
    required this.deleteMessageUseCase,
  });

  FormzStatus _status = FormzStatus.pure;
  FormzStatus get status => _status;
  set status(FormzStatus status) {
    _status = status;
    notifyListeners();
  }

  Map<String, ChatMessageEntity> chatData = {};

  FormzStatus _getAllChatStatus = FormzStatus.pure;
  FormzStatus get getAllChatStatus => _getAllChatStatus;
  set getAllChatStatus(FormzStatus status) {
    _getAllChatStatus = status;
    notifyListeners();
  }

  Failure? getAllChatFailure;
  List<ChatEntity> chatList = [];

  Future<void> getAllUserChat({bool checkIsEmpty = false}) async {
    if (checkIsEmpty && chatList.isNotEmpty) return;
    getAllChatStatus = FormzStatus.loading;
    final result = await getAllUserChatUseCase();
    if (result.isSuccess) {
      chatList = result.data;
      getAllChatStatus = FormzStatus.success;
      return;
    }
    getAllChatFailure = result.failure;
    getAllChatStatus = FormzStatus.failed;
  }

  Future<void> changeLastSendMessage(
    MessageEntity? message, {
    String? chatId,
  }) async {
    chatList = List<ChatEntity>.from(chatList).map<ChatEntity>((e) {
      if (e.chatId == (chatId ?? message!.chat)) {
        return e.copyWith(lastMessage: message);
      }
      return e;
    }).toList();
    notifyListeners();
  }

  Future<void> getChatMessage(String chatId, {bool isFromMain = false}) async {
    int limit = 100;
    String? lastMessageId;
    String? firstMessageId;
    ChatMessageEntity? data = chatData[chatId];

    if (isFromMain && data != null && data.messages.isNotEmpty) {
      firstMessageId = data.messages.first.messageId;
    }

    if ((data?.isDataOver ?? false) && !isFromMain) return;
    if (data != null && !isFromMain) {
      lastMessageId =
          data.messages.isNotEmpty ? data.messages.last.messageId : null;
    }
    if (isFromMain) status = FormzStatus.loading;
    final result = await getAllChatMessageUseCase(
      GetAllChatMessageParams(
        chatId: chatId,
        lastMessageId: lastMessageId,
        firstMessageId: firstMessageId,
        limit: limit,
      ),
    );
    if (result.isFailure) {
      if (isFromMain) status = FormzStatus.failed;
      return;
    }
    if (data == null) {
      chatData[chatId] = result.data.copyWith(
        isDataOver: result.data.messages.length < limit ? true : false,
      );
      status = FormzStatus.success;
      return;
    }
    chatData[chatId] = data.copyWith(
      chat: result.data.chat,
      messages: result.data.isLast
          ? {...data.messages, ...result.data.messages}
          : {...result.data.messages, ...data.messages},
      isDataOver: result.data.isLast
          ? result.data.messages.length < limit
              ? true
              : false
          : data.isDataOver,
    );
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
      ),
    );
    if (result.isFailure) return;
  }

  void listenNewMessage() {
    SocketService.instance.add(
      SocketListner(
        event: 'new-message',
        listner: (data) {
          if (data == null) return;
          final message = MessageModel.fromMap(data as Map<String, dynamic>);
          final chatId = message.chat;
          final chatMessage = chatData[chatId];
          if (chatMessage == null) return;
          chatData[chatId] = chatMessage.copyWith(
            liveChatMessage: {message, ...chatMessage.liveChatMessage},
          );
          changeLastSendMessage(message);
          notifyListeners();
        },
      ),
    );
  }

  Future<void> deleteMessage({
    required String messageId,
  }) async {
    final result = await deleteMessageUseCase(
      DeleteMessageParams(messageId: messageId),
    );
    if (result.isFailure) return;
  }

  void listenDeleteMessage() {
    SocketService.instance.add(
      SocketListner(
        event: 'delete-message',
        listner: (data) {
          if (data == null) return;
          final message =
              MessageModel.fromMap((data as Map<String, dynamic>)['message']);
          final chat = ChatModel.fromMap(data['chat']);
          final chatId = message.chat;
          final chatMessage = chatData[chatId];
          if (chatMessage == null) return;
          Set<MessageEntity> messages = Set.of(chatMessage.messages);
          Set<MessageEntity> liveChatMessage =
              Set.of(chatMessage.liveChatMessage);
          messages.remove(message);
          liveChatMessage.remove(message);
          chatData[chatId] = chatMessage.copyWith(
            chat: chat,
            messages: messages,
            liveChatMessage: liveChatMessage,
          );
          changeLastSendMessage(chat.lastMessage, chatId: chatId);
          notifyListeners();
        },
      ),
    );
  }
}
