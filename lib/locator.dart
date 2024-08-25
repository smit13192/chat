import 'package:chat/src/api/api_client.dart';
import 'package:chat/src/core/services/network_service.dart';
import 'package:chat/src/core/services/socket_service.dart';
import 'package:chat/src/feature/auth/data/datasource/authentication_datasource.dart';
import 'package:chat/src/feature/auth/data/repository/authentication_repository_impl.dart';
import 'package:chat/src/feature/auth/domain/repository/authentication_repository.dart';
import 'package:chat/src/feature/auth/domain/usecase/login_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/profile_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/register_usecase.dart';
import 'package:chat/src/feature/auth/domain/usecase/update_profile_usecase.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:chat/src/feature/home/data/datasource/home_datasource.dart';
import 'package:chat/src/feature/home/data/repository/home_repository_impl.dart';
import 'package:chat/src/feature/home/domain/repository/home_repository.dart';
import 'package:chat/src/feature/home/domain/usecase/access_chat_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/delete_message_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_chat_message.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_user_chat_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/get_all_user_usecase.dart';
import 'package:chat/src/feature/home/domain/usecase/send_message_usecase.dart';
import 'package:chat/src/feature/home/presentation/provider/chat_provider.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void initLocator() {
  locator.registerFactory(() => ApiClient());
  authenticationInit();
  homeInit();
  locator.registerSingleton(NetworkService.instance);
  locator.registerSingleton(SocketService.instance);
}

void homeInit() {
  // data source initilize
  locator.registerFactory(
    () => ApiHomeDataSource(apiClient: locator<ApiClient>()),
  );

  // repository initilize
  locator.registerFactory<HomeRepository>(
    () => HomeRepositoryImpl(
      apiHomeDataSource: locator<ApiHomeDataSource>(),
    ),
  );

  //usecase initilize
  locator.registerFactory(
    () => GetAllUserUseCase(
      homeRepository: locator<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => AccessChatUseCase(
      homeRepository: locator<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => GetAllUserChatUseCase(
      homeRepository: locator<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => GetAllChatMessageUseCase(
      homeRepository: locator<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => SendMessageUseCase(
      homeRepository: locator<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => DeleteMessageUseCase(
      homeRepository: locator<HomeRepository>(),
    ),
  );

  // provider initilize
  locator.registerLazySingleton(
    () => HomeProvider(
      getAllUserUseCase: locator<GetAllUserUseCase>(),
      accessChatUseCase: locator<AccessChatUseCase>(),
    ),
  );
  locator.registerLazySingleton(
    () => ChatProvider(
      getAllChatMessageUseCase: locator<GetAllChatMessageUseCase>(),
      sendMessageUseCase: locator<SendMessageUseCase>(),
      getAllUserChatUseCase: locator<GetAllUserChatUseCase>(),
      deleteMessageUseCase: locator<DeleteMessageUseCase>(),
    ),
  );
}

void authenticationInit() {
  // data source initilize
  locator.registerFactory(
    () => ApiAuthenticationDataSource(apiClient: locator<ApiClient>()),
  );
  locator.registerFactory(() => LocalAuthenticationDataSource());

  // repository initilize
  locator.registerFactory<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      apiAuthenticationDataSource: locator<ApiAuthenticationDataSource>(),
    ),
  );

  //usecase initilize
  locator.registerFactory(
    () => LoginUseCase(
      authenticationRepository: locator<AuthenticationRepository>(),
    ),
  );
  locator.registerFactory(
    () => RegisterUseCase(
      authenticationRepository: locator<AuthenticationRepository>(),
    ),
  );
  locator.registerFactory(
    () => ProfileUseCase(
      authenticationRepository: locator<AuthenticationRepository>(),
    ),
  );
  locator.registerFactory(
    () => UpdateProfileUseCase(
      authenticationRepository: locator<AuthenticationRepository>(),
    ),
  );

  // provider initilize
  locator.registerLazySingleton(
    () => AuthenticationProvider(
      loginUseCase: locator<LoginUseCase>(),
      registerUseCase: locator<RegisterUseCase>(),
      profileUseCase: locator<ProfileUseCase>(),
      updateProfileUseCase: locator<UpdateProfileUseCase>(),
    ),
  );
}
