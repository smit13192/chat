import 'package:chat/locator.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/extension/datetime_extension.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/widgets/custom_form_field.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/chat_provider.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChatScreenParmas {
  final ChatEntity chatEnity;

  ChatScreenParmas({
    required this.chatEnity,
  });
}

class ChatScreen extends StatelessWidget {
  final ChatScreenParmas params;
  const ChatScreen({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<ChatProvider>()),
        ChangeNotifierProvider.value(value: locator<HomeProvider>()),
      ],
      child: ChatView(chatEntity: params.chatEnity),
    );
  }
}

class ChatView extends StatefulWidget {
  final ChatEntity chatEntity;
  const ChatView({super.key, required this.chatEntity});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late String? userId;
  final focusNode = FocusNode();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = Storage.instance.getId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ChatProvider>()
          .getChatMessage(widget.chatEntity.chatId, isFromMain: true);
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Builder(
            builder: (context) {
              bool isActive = false;
              final homeProvider = context.watch<HomeProvider>();
              bool isGroupChat = widget.chatEntity.isGroupChat;
              final recieverUserIndex = widget.chatEntity.users
                  .indexWhere((element) => element.userId != userId);
              if (recieverUserIndex != -1) {
                isActive = homeProvider.activeUser.contains(
                  widget.chatEntity.users[recieverUserIndex].userId,
                );
              }
              String chatName = isGroupChat
                  ? widget.chatEntity.chatName!
                  : recieverUserIndex == -1
                      ? 'No User Found'
                      : widget.chatEntity.users[recieverUserIndex].username;
              String image = isGroupChat
                  ? widget.chatEntity.groupImage
                  : recieverUserIndex == -1
                      ? widget.chatEntity.groupImage
                      : widget.chatEntity.users[recieverUserIndex].image;
              return Container(
                color: AppColor.whiteColor.withOpacity(0.15),
                child: SafeArea(
                  child: ListTile(
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
                      isGroupChat
                          ? 'Hello! Feel free to start the conversation.'
                          : isActive
                              ? 'Active now'
                              : 'The user is currently offline. Drop a message and they\'ll get back to you!',
                      color: AppColor.whiteColor.withOpacity(0.70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final status = context.select<ChatProvider, FormzStatus>(
                  (value) => value.status,
                );
                switch (status) {
                  case FormzStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case FormzStatus.success:
                    return MessageBuild(
                      userId: userId,
                      chatId: widget.chatEntity.chatId,
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: CustomFormField(
              focusNode: focusNode,
              textCapitalization: TextCapitalization.sentences,
              controller: messageController,
              hintText: 'Enter message',
              onSubmitted: (value) =>
                  _onFieldSubmit(context, value, widget.chatEntity.chatId),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: GestureDetector(
                onTap: () => _onFieldSubmit(
                  context,
                  messageController.text,
                  widget.chatEntity.chatId,
                ),
                child: Container(
                  margin: EdgeInsets.only(right: 2.w, top: 5, bottom: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    Icons.send,
                    color: AppColor.whiteColor,
                    size: 15.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onFieldSubmit(BuildContext context, String message, String chatId) {
    FocusScope.of(context).requestFocus(focusNode);
    if (message.trim().isEmpty) return;
    context
        .read<ChatProvider>()
        .sendMessage(chatId: chatId, message: message.trim());
    messageController.clear();
  }
}

class MessageBuild extends StatelessWidget {
  final String? userId;
  final String chatId;
  const MessageBuild({super.key, required this.userId, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chats =
        context.watch<ChatProvider>().chatData[chatId]?.allMessages ?? {};
    return LazyLoadScrollView(
      onEndOfPage: () => _onPageOver(context, chatId),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        reverse: true,
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final message = chats.elementAt(index);
          bool isUserSend = message.sender.userId == userId;
          bool isTimeShow = false;
          if (index == 0) {
            isTimeShow = true;
          } else if (chats.elementAt(index - 1).sender.userId !=
              message.sender.userId) {
            isTimeShow = true;
          }

          bool isDateShow = false;
          if (index == chats.length - 1) {
            isDateShow = true;
          } else if (chats.elementAt(index + 1).createdAt.toFormatedString() !=
              message.createdAt.toFormatedString()) {
            isDateShow = true;
          }
          return Column(
            children: [
              if (isDateShow) ...[
                GapH(1.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColor.whiteColor.withOpacity(0.60),
                      ),
                    ),
                    GapW(3.w),
                    CustomText(
                      message.createdAt.toFormatedString('d, MMMM yyyy'),
                      color: AppColor.whiteColor.withOpacity(0.60),
                    ),
                    GapW(3.w),
                    Expanded(
                      child: Divider(
                        color: AppColor.whiteColor.withOpacity(0.60),
                      ),
                    ),
                  ],
                ),
                GapH(1.h),
              ],
              Align(
                alignment:
                    isUserSend ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onDoubleTap: () =>
                      _onMessageDoubleTap(context, message.messageId),
                  child: Column(
                    crossAxisAlignment: isUserSend
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        margin: EdgeInsets.symmetric(vertical: 0.8.h),
                        decoration: BoxDecoration(
                          color: isUserSend
                              ? AppColor.whiteColor.withOpacity(0.20)
                              : AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 70.w),
                          child: CustomText(
                            message.message,
                            color: AppColor.whiteColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      if (isTimeShow)
                        CustomText(
                          message.createdAt.toFormatedString('hh:mm'),
                          fontSize: 9.sp,
                          color: AppColor.whiteColor.withOpacity(0.40),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onMessageDoubleTap(BuildContext context, String messageId) {
    context.read<ChatProvider>().deleteMessage(messageId: messageId);
  }

  void _onPageOver(BuildContext context, String chatId) {
    context.read<ChatProvider>().getChatMessage(chatId);
  }
}
