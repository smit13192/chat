import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/services/aes_cipher_service.dart';
import 'package:chat/src/core/services/socket_service.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/utils/post_frame_callback_mixin.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/loader.dart';
import 'package:chat/src/core/widgets/refresh.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with PostFrameCallbackMixin {
  @override
  void onPostFrameCallback() {
    init();
    SocketService.instance.socketInit();
    context.read<HomeProvider>().emitActiveUser();
    context.read<HomeProvider>().listenNewMessage();
    context.read<HomeProvider>().listenDeleteMessage();
  }

  void init() {
    context.read<HomeProvider>().getAllUserChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final status = context.select<HomeProvider, FormzStatus>(
            (value) => value.getAllChatStatus,
          );
          switch (status) {
            case FormzStatus.failed:
              return Refresh(onRefresh: init);
            case FormzStatus.success:
              return const GetAllChatView();
            default:
              return const Loader();
          }
        },
      ),
    );
  }
}

class GetAllChatView extends StatelessWidget {
  const GetAllChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = context.watch<HomeProvider>().chatList;

    if (chats.isEmpty) {
      return Refresh(onRefresh: () => _onRefresh(context));
    }

    String? userId = Storage.instance.getId();

    return RefreshIndicator(
      onRefresh: () async => await _onRefresh(context),
      backgroundColor: AppColor.blackColor,
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final chat = chats.elementAt(index);
          final recieverUserIndex = chat.users.indexWhere(
            (element) => element.userId != userId,
          );
          String chatName =
              chat.isGroupChat
                  ? chat.chatName!
                  : recieverUserIndex == -1
                  ? 'No User Found'
                  : chat.users[recieverUserIndex].username;
          String image =
              chat.isGroupChat
                  ? chat.groupImage
                  : recieverUserIndex == -1
                  ? chat.groupImage
                  : chat.users[recieverUserIndex].image;
          return ListTile(
            onTap: () => _onChatTap(context, chat),
            leading: CircleAvatar(
              backgroundColor: AppColor.transparent,
              backgroundImage: CachedNetworkImageProvider(image.toApiImage()),
            ),
            title: CustomText(
              chatName,
              color: AppColor.whiteColor,
              fontSize: 13.sp,
            ),
            subtitle: CustomText(
              chat.lastMessage != null
                  ? chat.lastMessage!.message.isNotEmpty
                      ? AESCipherService.decrypt(
                        chat.lastMessage!.message,
                        chat.lastMessage!.messageIv,
                      )
                      : 'Sent a photo'
                  : 'Hello! Feel free to start the conversation.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColor.whiteColor.withAlpha(178),
            ),
          );
        },
      ),
    );
  }

  void _onChatTap(BuildContext context, ChatEntity chat) {
    context.pushNamed(
      Routes.chat.name,
      extra: ChatScreenParmas(chatEnity: chat),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<HomeProvider>().getAllUserChat();
  }
}
