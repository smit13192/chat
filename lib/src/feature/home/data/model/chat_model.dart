import 'package:chat/src/feature/auth/data/model/login_model.dart';
import 'package:chat/src/feature/home/data/model/message_model.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.chatId,
    super.chatName,
    required super.isGroupChat,
    required super.users,
    super.groupAdmin,
    required super.groupImage,
    super.lastMessage,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['_id'],
      chatName: map['chatName'],
      isGroupChat: map['isGroupChat'] ?? false,
      users: List<UserModel>.from(
        map['users'].map((x) => UserModel.fromMap(x)),
      ),
      groupAdmin:
          map['groupAdmin'] != null
              ? UserModel.fromMap(map['groupAdmin'])
              : null,
      groupImage: map['groupImage'],
      lastMessage:
          map['lastMessage'] != null
              ? MessageModel.fromMap(map['lastMessage'])
              : null,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: DateTime.parse(map['updatedAt']).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': chatId,
      'chatName': chatName,
      'isGroupChat': isGroupChat,
      'users': users.map((user) => (user as UserModel).toMap()).toList(),
      'groupAdmin': (groupAdmin as UserModel?)?.toMap(),
      'groupImage': groupImage,
      'lastMessage': (lastMessage as MessageModel?)?.toMap(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }
}
