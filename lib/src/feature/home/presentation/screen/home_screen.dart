
import 'package:chat/locator.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/constant/app_string.dart';
import 'package:chat/src/config/constant/assets.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/chat_provider.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<HomeProvider>()),
        ChangeNotifierProvider.value(value: locator<ChatProvider>()),
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
      context.read<HomeProvider>().getAllUser(isFromMain: true);
      context.read<HomeProvider>().emitActiveUser();
      context.read<ChatProvider>().listenNewMessage();
      context.read<ChatProvider>().listenDeleteMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor.withOpacity(0.15),
        elevation: 0,
        title: CustomText(
          AppString.appName,
          fontSize: 17.sp,
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.getAllUserChat),
            child: SizedBox(
              height: 2.5.h,
              width: 2.5.h,
              child: Image.asset(
                Assets.assetsIconsChat,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          GapW(5.w),
        ],
      ),
      body: Builder(
        builder: (context) {
          final status = context
              .select<HomeProvider, FormzStatus>((value) => value.status);
          switch (status) {
            case FormzStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case FormzStatus.success:
              return const AllUserView();
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class AllUserView extends StatelessWidget {
  const AllUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final users = homeProvider.users;
    final activeUser = homeProvider.activeUser;
    final isDataOver = homeProvider.isDataOver;
    return LazyLoadScrollView(
      onEndOfPage: () => context.read<HomeProvider>().getAllUser(),
      child: ListView.builder(
        itemCount: (users.length + (isDataOver ? 0 : 1)),
        itemBuilder: (context, index) {
          if (index == users.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = users[index];

          return ListTile(
            onTap: () => _onUserTap(context, user),
            leading: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.5.h),
                  child: SizedBox(
                    height: 5.h,
                    width: 5.h,
                    child: Image.network(
                      user.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (activeUser.contains(user.userId))
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: const Offset(7, 1),
                      child: Container(
                        height: 2.h,
                        width: 2.h,
                        decoration: const BoxDecoration(
                          color: AppColor.greenColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: CustomText(
              user.username,
              color: AppColor.whiteColor,
              fontSize: 13.sp,
            ),
            subtitle: CustomText(
              user.email,
              color: AppColor.whiteColor.withOpacity(0.70),
            ),
          );
        },
      ),
    );
  }

  void _onUserTap(BuildContext context, UserEntity user) {
    context.read<HomeProvider>().accessChat(context, recieverId: user.userId);
  }
}
