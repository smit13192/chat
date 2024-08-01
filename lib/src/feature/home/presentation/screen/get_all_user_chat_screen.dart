import 'package:chat/locator.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/chat_provider.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GetAllUserChatScreen extends StatelessWidget {
  const GetAllUserChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ChatProvider>()),
      ],
      child: const GetAllUserChatView(),
    );
  }
}

class GetAllUserChatView extends StatefulWidget {
  const GetAllUserChatView({super.key});

  @override
  State<GetAllUserChatView> createState() => _GetAllUserChatViewState();
}

class _GetAllUserChatViewState extends State<GetAllUserChatView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().getAllUserChat(checkIsEmpty: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.whiteColor.withOpacity(0.15),
        elevation: 0,
        title: CustomText(
          'Chat',
          fontSize: 17.sp,
        ),
      ),
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
      onRefresh: () async => _onRefresh(context),
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
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
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

  void _onRefresh(BuildContext context) {
    context.read<ChatProvider>().getAllUserChat();
  }
}
