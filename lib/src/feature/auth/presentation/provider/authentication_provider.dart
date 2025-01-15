import 'dart:io';

import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/extension/context_extension.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/auth/domain/usecase/login_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/profile_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/register_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/update_profile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthenticationProvider extends ChangeNotifier {
  LoginUseCase loginUseCase;
  RegisterUseCase registerUseCase;
  ProfileUseCase profileUseCase;
  UpdateProfileUseCase updateProfileUseCase;

  AuthenticationProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.profileUseCase,
    required this.updateProfileUseCase,
  });

  bool get isAuthenticated => user != null;

  UserEntity? user;
  File? updatedImage;

  Future<bool> checkIsLogin() async {
    String? token = Storage.instance.getToken();
    if (token == null) return false;
    final result = await profileUseCase();
    if (result.isFailure) {
      await Storage.instance.clear();
      return false;
    }
    user = result.data;
    return true;
  }

  FormzStatus _loginFormzStatus = FormzStatus.pure;
  set loginFormzStatus(FormzStatus value) {
    _loginFormzStatus = value;
    notifyListeners();
  }

  FormzStatus get loginFormzStatus => _loginFormzStatus;

  FormzStatus _registerFormzStatus = FormzStatus.pure;
  set registerFormzStatus(FormzStatus value) {
    _registerFormzStatus = value;
    notifyListeners();
  }

  FormzStatus get registerFormzStatus => _registerFormzStatus;

  FormzStatus _updateProfileFormzStatus = FormzStatus.pure;
  set updateProfileFormzStatus(FormzStatus value) {
    _updateProfileFormzStatus = value;
    notifyListeners();
  }

  FormzStatus get updateProfileFormzStatus => _updateProfileFormzStatus;

  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final router = GoRouter.of(context);
    loginFormzStatus = FormzStatus.loading;
    final result =
        await loginUseCase(LoginParams(email: email, password: password));
    loginFormzStatus = FormzStatus.pure;

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
    router.go(Routes.dashboard);
  }

  Future<void> register(
    BuildContext context, {
    required String username,
    required String email,
    required String password,
  }) async {
    registerFormzStatus = FormzStatus.loading;
    final router = GoRouter.of(context);
    final result = await registerUseCase(
      RegisterParams(username: username, email: email, password: password),
    );
    registerFormzStatus = FormzStatus.pure;

    if (result.isFailure) {
      if (!context.mounted) return;
      context.showErrorSnackBar(result.failure.message);
      return;
    }

    if (!context.mounted) return;
    context.showSuccessSnackBar(result.data);
    router.go(Routes.login);
  }

  Future<void> getUserProfile() async {
    final result = await profileUseCase();
    if (result.isFailure) return;
    user = result.data;
    notifyListeners();
  }

  void onUpdateImage(File? image) {
    updatedImage = image;
    notifyListeners();
  }

  Future<void> updateUser(
    BuildContext context, {
    required String username,
  }) async {
    updateProfileFormzStatus = FormzStatus.loading;
    final result = await updateProfileUseCase(
      UpdateProfileParams(username: username, image: updatedImage?.path),
    );
    updateProfileFormzStatus = FormzStatus.pure;
    if (result.isFailure) {
      if (!context.mounted) return;
      context.showErrorSnackBar(result.failure.message);
      return;
    }

    user = result.data;
    notifyListeners();
    if (!context.mounted) return;
    context.showSuccessSnackBar('User profile updated successfully');
  }
}
