import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/locator.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/database/storage.dart';
import 'package:chat/src/core/extension/datetime_extension.dart';
import 'package:chat/src/core/services/aes_cipher_service.dart';
import 'package:chat/src/core/services/image_service.dart';
import 'package:chat/src/core/services/socket_service.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/utils/post_frame_callback_mixin.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_form_field.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/core/widgets/loader.dart';
import 'package:chat/src/core/widgets/refresh.dart';
import 'package:chat/src/feature/auth/data/model/login_model.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:chat/src/feature/home/data/model/chat_model.dart';
import 'package:chat/src/feature/home/domain/entity/attachment_entity.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/domain/entity/message_entity.dart';
import 'package:chat/src/feature/home/domain/entity/typing_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/chat_provider.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChatScreenParmas {
  final ChatEntity chatEnity;

  ChatScreenParmas({required this.chatEnity});
}

class ChatScreen extends StatelessWidget {
  final ChatScreenParmas params;
  const ChatScreen({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => locator<ChatProvider>()),
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

class _ChatViewState extends State<ChatView> with PostFrameCallbackMixin {
  late String? userId;
  StreamSubscription<MessageEntity>? liveMessage;
  StreamSubscription<MessageEntity>? removeMessage;
  TextEditingController messageController = TextEditingController();
  final socketService = SocketService.instance;
  late AuthenticationProvider authProvider;
  late ChatProvider chatProvider;
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();
    userId = Storage.instance.getId();
  }

  @override
  void onPostFrameCallback() {
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthenticationProvider>();
    chatProvider.getChatMessage(widget.chatEntity.chatId, isFromMain: true);
    final chatManageProvider = context.read<HomeProvider>();
    liveMessage = chatManageProvider.liveMessage.stream.listen((message) {
      if (message.chat != widget.chatEntity.chatId) return;
      chatProvider.addLiveChatMessage(message);
    });
    removeMessage = chatManageProvider.removeMessage.stream.listen((message) {
      if (message.chat != widget.chatEntity.chatId) return;
      chatProvider.deleteLiveChatMessage(message);
    });
    socketService.add(
      SocketListner(
        event: 'start-typing',
        listner: (data) {
          if (!mounted) return;
          if (data == null) return;
          final chat = ChatModel.fromMap(
            (data as Map<String, dynamic>)['chat'],
          );
          if (chat.chatId != widget.chatEntity.chatId) return;
          final user = UserModel.fromMap(data['user']);
          chatProvider.addTyping(TypingEntity(chatId: chat.chatId, user: user));
        },
      ),
    );
    socketService.add(
      SocketListner(
        event: 'stop-typing',
        listner: (data) {
          if (!mounted) return;
          if (data == null) return;
          final chat = ChatModel.fromMap(
            (data as Map<String, dynamic>)['chat'],
          );
          if (chat.chatId != widget.chatEntity.chatId) return;
          final user = UserModel.fromMap(data['user']);
          chatProvider.removeTyping(
            TypingEntity(chatId: chat.chatId, user: user),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    liveMessage?.cancel();
    removeMessage?.cancel();
    socketService.off('start-typing');
    socketService.off('stop-typing');
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
              final recieverUserIndex = widget.chatEntity.users.indexWhere(
                (element) => element.userId != userId,
              );
              if (recieverUserIndex != -1) {
                isActive = homeProvider.activeUser.contains(
                  widget.chatEntity.users[recieverUserIndex].userId,
                );
              }
              String chatName =
                  isGroupChat
                      ? widget.chatEntity.chatName!
                      : recieverUserIndex == -1
                      ? 'No User Found'
                      : widget.chatEntity.users[recieverUserIndex].username;
              String image =
                  isGroupChat
                      ? widget.chatEntity.groupImage
                      : recieverUserIndex == -1
                      ? widget.chatEntity.groupImage
                      : widget.chatEntity.users[recieverUserIndex].image;
              return Container(
                color: AppColor.whiteColor.withAlpha(39),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      GapW(3.w),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColor.whiteColor,
                          size: 18.sp,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColor.transparent,
                            backgroundImage: CachedNetworkImageProvider(
                              image.toApiImage(),
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
                            color: AppColor.whiteColor.withAlpha(178),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
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
                  case FormzStatus.failed:
                    return Refresh(
                      onRefresh:
                          () => context.read<ChatProvider>().getChatMessage(
                            widget.chatEntity.chatId,
                          ),
                    );
                  case FormzStatus.success:
                    return MessageBuild(
                      userId: userId,
                      chatId: widget.chatEntity.chatId,
                    );
                  default:
                    return const Loader();
                }
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.h, top: 1.h),
              child: Builder(
                builder: (context) {
                  final replyToMessage = context
                      .select<ChatProvider, MessageEntity?>(
                        (value) => value.replyToMessage,
                      );
                  final attachment = context.select<ChatProvider, File?>(
                    (value) => value.attachment,
                  );
                  final isLoading = context.select<ChatProvider, bool>(
                    (value) => value.sendMessageStatus.isLoading,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (replyToMessage != null || attachment != null)
                        Divider(color: AppColor.whiteColor.withAlpha(75)),
                      if (attachment != null) ...[
                        GapH(1.h),
                        SizedBox(
                          height: 20.h,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.h),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.file(
                                    attachment,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 5.w,
                                top: 1.w,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor.withAlpha(51),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<ChatProvider>().attachment =
                                          null;
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16.sp,
                                      color: AppColor.whiteColor.withAlpha(127),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GapH(1.h),
                      ],
                      if (replyToMessage != null) ...[
                        GapH(1.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w, right: 4.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'Reply to @${replyToMessage.sender.username}',
                                      color: AppColor.whiteColor.withAlpha(127),
                                      fontSize: 11.sp,
                                    ),
                                    const GapH(3),
                                    if (replyToMessage.message.isNotEmpty) ...[
                                      CustomText(
                                        AESCipherService.decrypt(
                                          replyToMessage.message,
                                          replyToMessage.messageIv,
                                        ),
                                        color: AppColor.whiteColor.withAlpha(
                                          75,
                                        ),
                                        fontSize: 10.sp,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ] else if (replyToMessage.attachment !=
                                        null) ...[
                                      CustomText(
                                        'Sent a photo',
                                        color: AppColor.whiteColor.withAlpha(
                                          75,
                                        ),
                                        fontSize: 10.sp,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const GapH(3),
                                    ],
                                  ],
                                ),
                              ),
                              GapW(3.w),
                              GestureDetector(
                                onTap:
                                    () =>
                                        context
                                            .read<ChatProvider>()
                                            .replyToMessage = null,
                                child: Transform.translate(
                                  offset: const Offset(0, 2),
                                  child: Icon(
                                    Icons.close,
                                    size: 16.sp,
                                    color: AppColor.whiteColor.withAlpha(127),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GapH(2.h),
                      ],
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, right: 4.w),
                        child: CustomFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: messageController,
                          minLines: 1,
                          maxLines: 3,
                          hintText: 'Enter message',
                          onSubmitted:
                              (value) => _onFieldSubmit(
                                context,
                                value,
                                widget.chatEntity.chatId,
                              ),
                          onChanged: (value) => _onTextFieldChanged(),
                          suffixIconConstraints: const BoxConstraints(),
                          prefixIcon: GestureDetector(
                            onTap: () => _onImageTap(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                color: AppColor.whiteColor,
                                size: 15.sp,
                              ),
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap:
                                () => _onFieldSubmit(
                                  context,
                                  messageController.text,
                                  widget.chatEntity.chatId,
                                ),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 2.w,
                                top: 5,
                                bottom: 5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child:
                                  isLoading
                                      ? CupertinoActivityIndicator(
                                        color: AppColor.whiteColor,
                                      )
                                      : Icon(
                                        Icons.send,
                                        color: AppColor.whiteColor,
                                        size: 15.sp,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onFieldSubmit(BuildContext context, String message, String chatId) {
    if (message.trim().isEmpty && chatProvider.attachment == null) return;
    context.read<ChatProvider>().sendMessage(
      chatId: chatId,
      message: message.trim(),
    );
    messageController.clear();
  }

  void _onTextFieldChanged() {
    final user = (authProvider.user as UserModel).toMap();
    final chat = (widget.chatEntity as ChatModel).toMap();
    if (typingTimer != null) {
      typingTimer?.cancel();
    }
    if (typingTimer == null) {
      socketService.emit('start-typing', {'user': user, 'chat': chat});
    }
    typingTimer = Timer(const Duration(milliseconds: 500), () {
      socketService.emit('stop-typing', {'user': user, 'chat': chat});
      typingTimer = null;
    });
  }

  Future<void> _onImageTap(BuildContext context) async {
    final file = await ImageService.pickImage(
      context: context,
      source: ImageSource.gallery,
    );
    if (file == null) return;
    chatProvider.attachment = file;
  }
}

class MessageBuild extends StatelessWidget {
  final String? userId;
  final String chatId;
  const MessageBuild({super.key, required this.userId, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final chats = chatProvider.messages;
    return LazyLoadScrollView(
      onEndOfPage: () => _onPageOver(context, chatId),
      child: ListView.separated(
        separatorBuilder: (context, index) => GapH(1.6.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        reverse: true,
        itemCount:
            (chats.length +
                (chatProvider.typing == null ? 0 : 1) +
                (chatProvider.isDataOver ? 0 : 1)),
        itemBuilder: (context, i) {
          if (i == 0 && chatProvider.typing != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    chatProvider.typing!.user.image.toApiImage(),
                  ),
                  radius: 4.w,
                ),
                GapW(2.w),
                CustomText(
                  '${chatProvider.typing!.user.username} is typing...',
                  color: AppColor.whiteColor.withAlpha(127),
                  fontSize: 12.5.sp,
                ),
              ],
            );
          }
          final index = chatProvider.typing != null ? i - 1 : i;
          if (i == chats.length && !chatProvider.isDataOver) {
            return const Loader();
          }
          final message = chats.elementAt(index);
          return MessageTile(
            key: ValueKey(message.messageId),
            message: message,
            userId: userId,
            chats: chats,
            index: index,
            onMessageDoubleTap:
                (message) => _onMessageDoubleTap(context, message.messageId),
          );
        },
      ),
    );
  }

  Future<void> _onMessageDoubleTap(
    BuildContext context,
    String messageId,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final chatProvider = context.read<ChatProvider>();
    bool? isDelete = await showDialog(
      context: context,
      builder: (context) => const DeleteMessageDialog(),
    );
    if (isDelete ?? false) {
      chatProvider.deleteMessage(messageId: messageId);
    }
  }

  void _onPageOver(BuildContext context, String chatId) {
    context.read<ChatProvider>().getChatMessage(chatId);
  }
}

class MessageTile extends StatelessWidget {
  final MessageEntity message;
  final String? userId;
  final Set<MessageEntity> chats;
  final int index;
  final void Function(MessageEntity message) onMessageDoubleTap;

  const MessageTile({
    super.key,
    required this.message,
    required this.userId,
    required this.chats,
    required this.index,
    required this.onMessageDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
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
      crossAxisAlignment:
          isUserSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (isDateShow) ...[
          GapH(1.h),
          Row(
            children: [
              Expanded(
                child: Divider(color: AppColor.whiteColor.withAlpha(153)),
              ),
              GapW(3.w),
              CustomText(
                message.createdAt.toFormatedString('d, MMMM yyyy'),
                color: AppColor.whiteColor.withAlpha(153),
              ),
              GapW(3.w),
              Expanded(
                child: Divider(color: AppColor.whiteColor.withAlpha(153)),
              ),
            ],
          ),
          GapH(2.h),
        ],
        Row(
          mainAxisAlignment:
              isUserSend ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUserSend) ...[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  message.sender.image.toApiImage(),
                ),
                radius: 4.w,
              ),
              GapW(2.w),
            ],
            SwipeAnimatatedWidget(
              isRight: !isUserSend,
              isLeft: isUserSend,
              onLeftSwipe: () => _onSwipe(context, message),
              onRightSwipe: () => _onSwipe(context, message),
              child: GestureDetector(
                onDoubleTap:
                    () => isUserSend ? onMessageDoubleTap(message) : null,
                child: Column(
                  crossAxisAlignment:
                      isUserSend
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    if (message.replyToMessage != null) ...[
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          border: Border.all(
                            color: AppColor.whiteColor.withAlpha(75),
                          ),
                        ),
                        constraints: BoxConstraints(maxWidth: 70.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Reply to @${message.replyToMessage?.sender.username}',
                              color: AppColor.whiteColor.withAlpha(75),
                              fontSize: 10.5.sp,
                            ),
                            if (message.replyToMessage!.attachment != null) ...[
                              const GapH(5),
                              buildImage(
                                attachment: message.replyToMessage!.attachment!,
                                subtractWidth: 4.w,
                              ),
                            ],
                            if (message.replyToMessage!.message.isNotEmpty) ...[
                              const GapH(5),
                              CustomText(
                                AESCipherService.decrypt(
                                  message.replyToMessage!.message,
                                  message.replyToMessage!.messageIv,
                                ),
                                color: AppColor.whiteColor.withAlpha(127),
                                fontSize: 10.sp,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const GapH(5),
                    ],
                    if (message.attachment != null) ...[
                      buildImage(attachment: message.attachment!),
                    ],
                    if (message.message.isNotEmpty) ...[
                      const GapH(5),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color:
                              isUserSend
                                  ? AppColor.whiteColor.withAlpha(51)
                                  : AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                        constraints: BoxConstraints(maxWidth: 70.w),
                        child: CustomText(
                          AESCipherService.decrypt(
                            message.message,
                            message.messageIv,
                          ),
                          color: AppColor.whiteColor,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                    if (isTimeShow) ...[
                      GapH(0.8.h),
                      CustomText(
                        message.createdAt.toFormatedString('hh:mm'),
                        fontSize: 9.sp,
                        color: AppColor.whiteColor.withAlpha(102),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildImage({
    required AttachmentEntity attachment,
    double subtractWidth = 0,
  }) {
    double width = 70.w - subtractWidth;
    double? height;

    if (attachment.height != null && attachment.width != null) {
      double aspectRatio = attachment.height! / attachment.width!;
      height = width * aspectRatio;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.h)),
      clipBehavior: Clip.hardEdge,
      child: CustomImage(attachment.url.toApiImage()),
    );
  }

  void _onSwipe(BuildContext context, MessageEntity message) {
    context.read<ChatProvider>().replyToMessage = message;
  }
}

class DeleteMessageDialog extends StatelessWidget {
  const DeleteMessageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      backgroundColor: AppColor.blackColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CustomText(
              'Are you sure you want to delete this message?',
              color: AppColor.whiteColor,
              fontSize: 18,
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                text: 'Delete',
                onPressed: () {
                  context.pop(true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeAnimatatedWidget extends StatefulWidget {
  final Widget child;
  final void Function()? onRightSwipe;
  final void Function()? onLeftSwipe;
  final bool isRight;
  final bool isLeft;

  const SwipeAnimatatedWidget({
    super.key,
    required this.child,
    this.onLeftSwipe,
    this.onRightSwipe,
    this.isRight = false,
    this.isLeft = false,
  });

  @override
  State<SwipeAnimatatedWidget> createState() => SwipeAnimatatedWidgetState();
}

class SwipeAnimatatedWidgetState extends State<SwipeAnimatatedWidget> {
  double position = 0;
  double maxPosition = 10.w;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(position, 0),
      child: GestureDetector(
        onPanUpdate: (details) => _onPanUpdate(details),
        onPanEnd: (details) => _onPanEnd(details),
        child: widget.child,
      ),
    );
  }

  void _onPanUpdate(details) {
    double dxValue = details.delta.dx;
    if (position >= maxPosition && widget.isRight && dxValue > 0) return;
    if (position <= -maxPosition && widget.isLeft && dxValue < 0) return;
    if (widget.isRight && dxValue > 0) position += details.delta.dx;
    if (widget.isRight && dxValue < 0) {
      if (position < 0 || position == 0) return;
      position += details.delta.dx;
    }
    if (widget.isLeft && dxValue < 0) position += details.delta.dx;
    if (widget.isLeft && dxValue > 0) {
      if (position > 0 || position == 0) return;
      position += details.delta.dx;
    }
    setState(() {});
  }

  void _onPanEnd(details) {
    if (widget.isRight && position >= maxPosition) {
      widget.onRightSwipe?.call();
    }
    if (widget.isLeft && position <= -maxPosition) {
      widget.onLeftSwipe?.call();
    }
    position = 0;
    setState(() {});
  }
}
