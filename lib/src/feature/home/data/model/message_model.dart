import 'package:chat/src/feature/auth/data/model/login_model.dart';
import 'package:chat/src/feature/home/data/model/attachment_model.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.messageId,
    required super.message,
    required super.sender,
    required super.chat,
    required super.messageIv,
    required super.attachment,
    super.replyToMessage,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['_id'],
      message: map['message'] ?? '',
      sender: UserModel.fromMap(map['sender']),
      chat: map['chat'],
      messageIv: map['messageIv'] ?? '',
      attachment:
          map['attachment'] != null && map['attachment'] is Map
              ? AttachmentModel.fromMap(map['attachment'])
              : null,
      replyToMessage:
          map['replyToMessage'] != null && map['replyToMessage'] is Map
              ? MessageModel.fromMap(map['replyToMessage'])
              : null,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: DateTime.parse(map['updatedAt']).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': messageId,
      'message': message,
      'sender': (sender as UserModel).toMap(),
      'chat': chat,
      'messageIv': messageIv,
      'replyToMessage': (replyToMessage as MessageModel?)?.toMap(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }
}
