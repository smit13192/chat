import 'package:chat/locator.dart';
import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/core/utils/formz_status.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/feature/auth/domain/entity/login_entity.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GetAllUserScreen extends StatelessWidget {
  const GetAllUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<HomeProvider>()),
      ],
      child: const GetAllUserView(),
    );
  }
}

class GetAllUserView extends StatefulWidget {
  const GetAllUserView({super.key});

  @override
  State<GetAllUserView> createState() => _GetAllUserViewState();
}

class _GetAllUserViewState extends State<GetAllUserView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getAllUser(isFromMain: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor.withOpacity(0.15),
        elevation: 0,
        title: CustomText(
          'Users',
          fontSize: 17.sp,
        ),
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
                    child: CustomImage(user.image.toApiImage()),
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
