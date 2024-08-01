import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final ChatEntity chat;
  final Set<MessageEntity> messages;
  final bool isDataOver;

  const ChatMessageEntity({
    required this.chat,
    required this.messages,
    this.isDataOver = false,
  });

  @override
  List<Object?> get props => [chat, messages];

  ChatMessageEntity copyWith({
    ChatEntity? chat,
    Set<MessageEntity>? messages,
    bool? isDataOver,
  }) {
    return ChatMessageEntity(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      isDataOver: isDataOver ?? this.isDataOver,
    );
  }
}
