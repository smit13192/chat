import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final ChatEntity chat;
  final Set<MessageEntity> messages;
  final bool isDataOver;
  final bool isFirst;
  final bool isLast;
  final bool isFromMain;
  final Set<MessageEntity> liveChatMessage;

  const ChatMessageEntity({
    required this.chat,
    required this.messages,
    this.isDataOver = false,
    required this.isFirst,
    required this.isLast,
    required this.isFromMain,
    this.liveChatMessage = const {},
  });

  @override
  List<Object?> get props => [
        chat,
        messages,
        isDataOver,
        isFirst,
        isLast,
        isFromMain,
        liveChatMessage,
      ];

  ChatMessageEntity copyWith({
    ChatEntity? chat,
    Set<MessageEntity>? messages,
    bool? isDataOver,
    bool? isFirst,
    bool? isLast,
    bool? isFromMain,
    Set<MessageEntity> liveChatMessage = const {},
  }) {
    return ChatMessageEntity(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      isDataOver: isDataOver ?? this.isDataOver,
      isFirst: isFirst ?? this.isFirst,
      isLast: isLast ?? this.isLast,
      isFromMain: isFromMain ?? this.isFromMain,
      liveChatMessage: liveChatMessage,
    );
  }

  Set<MessageEntity> get allMessages => {...liveChatMessage, ...messages};
}
