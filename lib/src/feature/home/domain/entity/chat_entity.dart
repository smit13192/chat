import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final String? chatName;
  final bool isGroupChat;
  final List<UserEntity> users;
  final UserEntity? groupAdmin;
  final String groupImage;
  final MessageEntity? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatEntity({
    required this.chatId,
    this.chatName,
    required this.isGroupChat,
    required this.users,
    this.groupAdmin,
    required this.groupImage,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  ChatEntity copyWith({
    String? chatId,
    String? chatName,
    bool? isGroupChat,
    List<UserEntity>? users,
    UserEntity? groupAdmin,
    String? groupImage,
    MessageEntity? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatEntity(
      chatId: chatId ?? this.chatId,
      chatName: chatName ?? this.chatName,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      users: users ?? this.users,
      groupAdmin: groupAdmin ?? this.groupAdmin,
      groupImage: groupImage ?? this.groupImage,
      lastMessage: lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        chatId,
        chatName,
        isGroupChat,
        users,
        groupAdmin,
        groupImage,
        lastMessage,
        createdAt,
        updatedAt,
      ];
}
