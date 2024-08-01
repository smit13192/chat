

import 'package:chat/src/feature/auth/data/model/login_model.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.messageId,
    required super.message,
    required super.sender,
    required super.chat,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['_id'],
      message: map['message'],
      sender: UserModel.fromMap(map['sender']),
      chat: map['chat'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: DateTime.parse(map['updatedAt']).toLocal(),
    );
  }
}
