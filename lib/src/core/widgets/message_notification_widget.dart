import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/services/aes_cipher_service.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/feature/home/domain/entity/chat_entity.dart';
import 'package:chat/src/feature/home/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class MessageNotificationWidget extends StatelessWidget {
  const MessageNotificationWidget({
    super.key,
    required this.chat,
    required this.userId,
    required this.dismiss,
  });

  final ChatEntity chat;
  final String userId;
  final void Function() dismiss;

  @override
  Widget build(BuildContext context) {
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

    return Material(
      color: AppColor.transparent,
      child: ListTile(
        onTap: () => _onTap(context),
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
              ? AESCipherService.decrypt(
                  chat.lastMessage!.message,
                  chat.lastMessage!.messageIv,
                )
              : 'Hello! Feel free to start the conversation.',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: AppColor.whiteColor.withAlpha(178),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    context.pushNamed(
      Routes.chat.name,
      extra: ChatScreenParmas(chatEnity: chat),
    );
    dismiss();
  }
}
