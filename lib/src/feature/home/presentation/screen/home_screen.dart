import 'package:chat/locator.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/chat_provider.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ChatProvider>()),
        ChangeNotifierProvider.value(value: locator<HomeProvider>()),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().getAllUserChat(checkIsEmpty: true);
      context.read<HomeProvider>().emitActiveUser();
      context.read<ChatProvider>().listenNewMessage();
      context.read<ChatProvider>().listenDeleteMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final status = context.select<ChatProvider, FormzStatus>(
            (value) => value.getAllChatStatus,
          );
          switch (status) {
            case FormzStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case FormzStatus.success:
              return const GetAllChatView();
            default:
              return const SizedBox.shrink();
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
    final chats = context.select<ChatProvider, List<ChatEntity>>(
      (value) => value.chatList,
    );

    if (chats.isEmpty) {
      return const SizedBox.shrink();
    }

    String? userId = Storage.instance.getId();

    return RefreshIndicator(
      onRefresh: () async => await _onRefresh(context),
      backgroundColor: AppColor.blackColor,
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final chat = chats[index];
          final recieverUserIndex =
              chat.users.indexWhere((element) => element.userId != userId);
          String chatName = chat.isGroupChat
              ? chat.chatName!
              : recieverUserIndex == -1
                  ? 'No User Found'
                  : chat.users[recieverUserIndex].username;
          String image = chat.isGroupChat
              ? chat.groupImage
              : recieverUserIndex == -1
                  ? chat.groupImage
                  : chat.users[recieverUserIndex].image;
          return ListTile(
            onTap: () => _onChatTap(context, chat),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(2.5.h),
              child: SizedBox(
                height: 5.h,
                width: 5.h,
                child: CustomImage(image.toApiImage()),
              ),
            ),
            title: CustomText(
              chatName,
              color: AppColor.whiteColor,
              fontSize: 13.sp,
            ),
            subtitle: CustomText(
              chat.lastMessage?.message ??
                  'Hello! Feel free to start the conversation.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: AppColor.whiteColor.withOpacity(0.70),
            ),
          );
        },
      ),
    );
  }

  void _onChatTap(BuildContext context, ChatEntity chat) {
    Navigator.pushNamed(
      context,
      Routes.chat,
      arguments: ChatScreenParmas(chatEnity: chat),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<ChatProvider>().getAllUserChat();
  }
}
