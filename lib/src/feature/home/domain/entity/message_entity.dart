import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messageId;
  final String message;
  final UserEntity sender;
  final String chat;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MessageEntity({
    required this.messageId,
    required this.message,
    required this.sender,
    required this.chat,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [messageId, message, sender, chat, createdAt, updatedAt];
}
