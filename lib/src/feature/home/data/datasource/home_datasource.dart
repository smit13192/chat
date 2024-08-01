

import 'package:chat/src/api/api_client.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/api/exception/api_exception.dart';
import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/core/model/common_model.dart';
import 'package:chat/src/feature/auth/data/model/login_model.dart';
import 'package:chat/src/feature/home/data/model/chat_message_model.dart';
import 'package:chat/src/feature/home/data/model/chat_model.dart';
import 'package:chat/src/feature/home/data/model/message_model.dart';

class ApiHomeDataSource {
  final ApiClient _apiClient;

  ApiHomeDataSource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<UserModel>> getAllUser({
    required int skip,
    required int limit,
  }) async {
    final response = await _apiClient.get(
      Endpoints.getAllUser,
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) =>
          List.from(data).map((e) => UserModel.fromMap(e)).toList(),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<ChatModel> accessChat({
    required String recieverId,
  }) async {
    final response = await _apiClient.post(
      Endpoints.chat,
      data: {'recieverId': recieverId},
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) => ChatModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<List<ChatModel>> getAllUserChat() async {
    final response = await _apiClient.get(Endpoints.chat);
    final result = CommonModel.fromMap(
      response,
      handler: (data) =>
          List.from(data).map((e) => ChatModel.fromMap(e)).toList(),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<ChatMessageModel> getAllChatMessage({
    required String chatId,
    String? lastMessageId,
    int? skip,
    int? limit,
  }) async {
    final response = await _apiClient.get(
      '${Endpoints.getAllChatMessage}/$chatId',
      queryParameters: {
        'lastMessageId': lastMessageId ?? '',
        'skip': skip ?? '',
        'limit': limit ?? '',
      },
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) => ChatMessageModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<MessageModel> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final response = await _apiClient.post(
      Endpoints.sendMessage,
      data: {
        'chat': chatId,
        'message': message,
      },
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) => MessageModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }

  Future<MessageModel> deleteMessage({
    required String messageId,
  }) async {
    final response = await _apiClient.delete(
      '${Endpoints.chat}/$messageId',
    );
    final result = CommonModel.fromMap(
      response,
      handler: (data) => MessageModel.fromMap(data),
    );
    if (result.success) {
      return result.data!;
    } else {
      throw ApiException(Failure.failure(result.statusCode, result.message));
    }
  }
}
