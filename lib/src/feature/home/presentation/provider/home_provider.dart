import 'dart:async';

import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/extension/context_extension.dart';
import 'package:chat/src/core/services/socket_service.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/utils/screen_loading_controller.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/data/model/chat_model.dart';
import 'package:chat/src/feature/home/data/model/message_model.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/usecase/access_chat_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_user_chat_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_user_usecase.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  GetAllUserUseCase getAllUserUseCase;
  AccessChatUseCase accessChatUseCase;
  GetAllUserChatUseCase getAllUserChatUseCase;

  StreamController<MessageEntity> liveMessage = StreamController.broadcast();
  StreamController<MessageEntity> removeMessage = StreamController.broadcast();

  HomeProvider({
    required this.getAllUserUseCase,
    required this.accessChatUseCase,
    required this.getAllUserChatUseCase,
  });

  List<String> activeUser = [];

  List<UserEntity> users = [];
  bool isDataOver = false;
  Failure? failure;
  FormzStatus _status = FormzStatus.loading;
  FormzStatus get status => _status;
  set status(FormzStatus status) {
    _status = status;
    notifyListeners();
  }

  List<ChatEntity> chatList = [];
  Failure? getAllChatFailure;
  FormzStatus _getAllChatStatus = FormzStatus.loading;
  FormzStatus get getAllChatStatus => _getAllChatStatus;
  set getAllChatStatus(FormzStatus status) {
    _getAllChatStatus = status;
    notifyListeners();
  }

  void emitActiveUser() {
    SocketService.instance.add(
      SocketListner(
        event: 'active-user',
        listner: (data) {
          activeUser = (data as List<dynamic>).map((e) => e as String).toList();
          notifyListeners();
        },
      ),
    );
    SocketService.instance.addEmitter(
      SocketEmitter(
        event: 'send-user-id',
        callBack: () => Storage.instance.getId() ?? '',
      ),
    );
  }

  Future<void> getAllUser({
    bool isFromMain = false,
  }) async {
    if (isFromMain) {
      status = FormzStatus.loading;
      isDataOver = false;
      users.clear();
    }
    if (isDataOver) return;
    final result = await getAllUserUseCase(
      GetAllUserParams(skip: users.length, limit: 10),
    );
    if (result.isSuccess) {
      if (result.data.length < 10) isDataOver = true;
      users.addAll(result.data);
      status = FormzStatus.success;
      return;
    }
    if (isFromMain) {
      failure = result.failure;
      status = FormzStatus.failed;
    }
  }

  Future<void> accessChat(
    BuildContext context, {
    required String recieverId,
  }) async {
    final navigatorState = Navigator.of(context);
    ScreenLoadingController.instance.show(context);
    final result = await accessChatUseCase(recieverId);
    ScreenLoadingController.instance.hide();
    if (result.isFailure) {
      if (!context.mounted) return;
      context.showErrorSnackBar(result.failure.message);
      return;
    }
    navigatorState.pushNamed(
      Routes.chat,
      arguments: ChatScreenParmas(chatEnity: result.data),
    );
  }

  Future<void> getAllUserChat() async {
    getAllChatStatus = FormzStatus.loading;
    final result = await getAllUserChatUseCase();
    if (result.isSuccess) {
      chatList = result.data;
      getAllChatStatus = FormzStatus.success;
      return;
    }
    getAllChatFailure = result.failure;
    getAllChatStatus = FormzStatus.failed;
  }

  Future<void> changeLastSendMessage(
    MessageEntity? message, {
    String? chatId,
  }) async {
    chatList = List<ChatEntity>.from(chatList).map<ChatEntity>((e) {
      if (e.chatId == (chatId ?? message!.chat)) {
        return e.copyWith(lastMessage: message);
      }
      return e;
    }).toList();
    notifyListeners();
  }

  void listenNewMessage() {
    SocketService.instance.add(
      SocketListner(
        event: 'new-message',
        listner: (data) {
          if (data == null) return;
          final message = MessageModel.fromMap(data as Map<String, dynamic>);
          liveMessage.add(message);
          changeLastSendMessage(message);
        },
      ),
    );
  }

  void listenDeleteMessage() {
    SocketService.instance.add(
      SocketListner(
        event: 'delete-message',
        listner: (data) {
          if (data == null) return;
          final message =
              MessageModel.fromMap((data as Map<String, dynamic>)['message']);
          final chat = ChatModel.fromMap(data['chat']);
          final chatId = message.chat;
          removeMessage.add(message);
          changeLastSendMessage(chat.lastMessage, chatId: chatId);
        },
      ),
    );
  }
}
