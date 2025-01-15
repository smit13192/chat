import 'package:chat/src/api/endpoints.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/router/router.dart';
import 'package:chat/src/core/widgets/custom_button.dart';
import 'package:chat/src/core/widgets/custom_image.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/auth/presentation/provider/authentication_provider.dart';
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
                          CustomButton(
                            onPressed: () => _onEditProfileTap(context),
                            text: 'Edit Profile',
                            height: 30,
                            buttonColor: AppColor.transparent,
                            textStyle: TextStyle(
                              fontSize: 10.sp,
                              color: AppColor.whiteColor.withAlpha(128),
                            ),
                            border: Border.all(
                              color: AppColor.whiteColor.withAlpha(26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEditProfileTap(BuildContext context) {
    context.push(Routes.editProfile);
  }
}
