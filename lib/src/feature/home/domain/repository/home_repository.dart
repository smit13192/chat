

import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/chat_message_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';

abstract interface class HomeRepository {
  Future<DataState<List<UserEntity>>> getAllUser({
    required int skip,
    required int limit,
  });

  Future<DataState<ChatEntity>> accessChat({
    required String recieverId,
  });

  Future<DataState<List<ChatEntity>>> getAllUserChat();

  Future<DataState<ChatMessageEntity>> getAllChatMessage({
    required String chatId,
    String? lastMessageId,
    String? firstMessageId,
    int? skip,
    int? limit,
  });

  Future<DataState<MessageEntity>> sendMessage({
    required String chatId,
    required String message,
    required String messageIv,
    required String? replyToMessage,
  });

  Future<DataState<MessageEntity>> deleteMessage({
    required String messageId,
  });
}
