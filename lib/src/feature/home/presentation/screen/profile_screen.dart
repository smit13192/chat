import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
import 'package:chat/src/feature/home/presentation/provider/home_provider.dart';
import 'package:chat/src/feature/home/presentation/widget/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authenticationProvider = context.watch<AuthenticationProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              backgroundColor: AppColor.blackColor,
              onRefresh: () =>
                  context.read<AuthenticationProvider>().getUserProfile(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: GapH(2.h)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 24.w,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24.w,
                            width: 24.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.5.w),
                              child: CustomImage(
                                authenticationProvider.user!.image.toApiImage(),
                              ),
                            ),
                          ),
                          GapW(5.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                CustomText(
                                  authenticationProvider.user!.username,
                                  color: AppColor.whiteColor,
                                  fontSize: 13.sp,
                                ),
                                CustomText(
                                  authenticationProvider.user!.email,
                                  color: AppColor.whiteColor.withAlpha(128),
                                ),
                                const Spacer(),
                                _buildButton(
                                  context,
                                  'Edit Profile',
                                  () => _onEditProfileTap(context),
                                  height: 30,
                                  fontSize: 10.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: GapH(2.h)),
                ],
              ),
            ),
          ),
          GapH(2.h),
          _buildButton(
            context,
            'Logout',
            () => _onLogoutTap(context),
            fontSize: 12.sp,
          ),
          GapH(2.h),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    double height = 54.0,
    double? fontSize,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      height: height,
      buttonColor: AppColor.transparent,
      highlightColor: AppColor.whiteColor.withAlpha(10),
      splashColor: AppColor.whiteColor.withAlpha(10),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: AppColor.whiteColor.withAlpha(128),
      ),
      border: Border.all(
        color: AppColor.whiteColor.withAlpha(26),
      ),
    );
  }

  void _onEditProfileTap(BuildContext context) {
    context.push(Routes.editProfile);
  }

  Future<void> _onLogoutTap(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
    if (result == true && context.mounted) {
      context.read<AuthenticationProvider>().logout(context);
      context.read<HomeProvider>().clearAllData();
    }
  }
}
