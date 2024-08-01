import 'package:chat/src/api/failure/failure.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/extension/context_extension.dart';
import 'package:chat/src/core/services/socket_service.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/utils/screen_loading_controller.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/domain/usecase/access_chat_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_user_usecase.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  GetAllUserUseCase getAllUserUseCase;
  AccessChatUseCase accessChatUseCase;

  List<UserEntity> users = [];
  List<String> activeUser = [];
  bool isDataOver = false;

  Failure? failure;

  FormzStatus _status = FormzStatus.pure;
  FormzStatus get status => _status;
  set status(FormzStatus status) {
    _status = status;
    notifyListeners();
  }

  HomeProvider({
    required this.getAllUserUseCase,
    required this.accessChatUseCase,
  });

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
    SocketService.instance.emit('send-user-id', Storage.instance.getId());
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
}