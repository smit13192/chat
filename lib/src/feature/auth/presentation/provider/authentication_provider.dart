
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/extension/context_extension.dart';
import 'package:chat/src/core/utils/screen_loading_controller.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/auth/domain/usecase/login_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/profile_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/register_usecase.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  LoginUseCase loginUseCase;
  RegisterUseCase registerUseCase;
  ProfileUseCase profileUseCase;

  AuthenticationProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.profileUseCase,
  });

  UserEntity? user;

  Future<void> checkIsLogin(BuildContext context) async {
    String? token = Storage.instance.getToken();
    final navigatorState = Navigator.of(context);
    if (token == null) {
      navigatorState.pushNamedAndRemoveUntil(
        Routes.login,
        (route) => false,
      );
      return;
    }
    final result = await profileUseCase();
    if (result.isFailure) {
      navigatorState.pushNamedAndRemoveUntil(
        Routes.login,
        (route) => false,
      );
      return;
    }
    user = result.data;
    navigatorState.pushNamedAndRemoveUntil(
      Routes.home,
      (route) => false,
    );
  }

  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    ScreenLoadingController.instance.show(context);
    final navigatorState = Navigator.of(context);
    final result =
        await loginUseCase(LoginParams(email: email, password: password));
    ScreenLoadingController.instance.hide();

    if (result.isFailure) {
      if (!context.mounted) return;
      context.showErrorSnackBar(result.failure.message);
      return;
    }

    user = result.data.user;
    await Future.wait([
      Storage.instance.setToken(result.data.token),
      Storage.instance.setId(result.data.user.userId),
    ]);
    if (!context.mounted) return;
    context.showSuccessSnackBar('User logged in successfully');
    navigatorState.pushNamedAndRemoveUntil(Routes.home, (route) => false);
  }

  Future<void> register(
    BuildContext context, {
    required String username,
    required String email,
    required String password,
  }) async {
    ScreenLoadingController.instance.show(context);
    final navigatorState = Navigator.of(context);
    final result = await registerUseCase(
      RegisterParams(username: username, email: email, password: password),
    );
    ScreenLoadingController.instance.hide();

    if (result.isFailure) {
      if (!context.mounted) return;
      context.showErrorSnackBar(result.failure.message);
      return;
    }

    if (!context.mounted) return;
    context.showSuccessSnackBar(result.data);
    navigatorState.pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }
}
