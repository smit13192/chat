import 'package:chat/src/feature/home/data/model/chat_model.dart';
import 'package:chat/src/feature/home/data/model/message_model.dart';
import 'package:chat/src/feature/home/domain/entity/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.chat,
    required super.messages,
    required super.isFirst,
    required super.isLast,
    required super.isFromMain,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      chat: ChatModel.fromMap(map['chat']),
      messages: map['messages'] == null
          ? {}
          : List.from(map['messages'])
              .map((e) => MessageModel.fromMap(e))
              .toSet(),
      isFirst: map['isFirst'],
      isLast: map['isLast'],
      isFromMain: map['isFromMain'],
    );
  }
}
