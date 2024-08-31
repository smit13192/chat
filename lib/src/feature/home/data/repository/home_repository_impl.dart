import 'package:chat/src/api/exception/api_exception.dart';
import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/api/state/data_state.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/data/datasource/home_datasource.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/chat_message_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiHomeDataSource _apiHomeDataSource;

  HomeRepositoryImpl({
    required ApiHomeDataSource apiHomeDataSource,
  }) : _apiHomeDataSource = apiHomeDataSource;

  @override
  Future<DataState<List<UserEntity>>> getAllUser({
    required int skip,
    required int limit,
  }) async {
    try {
      final response =
          await _apiHomeDataSource.getAllUser(skip: skip, limit: limit);
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<ChatEntity>> accessChat({required String recieverId}) async {
    try {
      final response =
          await _apiHomeDataSource.accessChat(recieverId: recieverId);
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<List<ChatEntity>>> getAllUserChat() async {
    try {
      final response = await _apiHomeDataSource.getAllUserChat();
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<ChatMessageEntity>> getAllChatMessage({
    required String chatId,
    String? lastMessageId,
    String? firstMessageId,
    int? skip,
    int? limit,
  }) async {
    try {
      final response = await _apiHomeDataSource.getAllChatMessage(
        chatId: chatId,
        lastMessageId: lastMessageId,
        firstMessageId: firstMessageId,
        skip: skip,
        limit: limit,
      );
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<MessageEntity>> sendMessage({
    required String chatId,
    required String message,
    required String messageIv,
    required String? replyToMessage,
  }) async {
    try {
      final response = await _apiHomeDataSource.sendMessage(
        chatId: chatId,
        message: message,
        messageIv: messageIv,
        replyToMessage: replyToMessage,
      );
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }

  @override
  Future<DataState<MessageEntity>> deleteMessage({
    required String messageId,
  }) async {
    try {
      final response = await _apiHomeDataSource.deleteMessage(
        messageId: messageId,
      );
      return DataState.success(response);
    } on ApiException catch (e) {
      return DataState.failure(e.failure);
    } catch (e) {
      return DataState.failure(Failure.failure(500));
    }
  }
}
