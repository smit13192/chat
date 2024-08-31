import 'package:chat/main.dart';
import 'package:chat/src/config/constant/app_color.dart';
import 'package:chat/src/config/constant/app_string.dart';
import 'package:chat/src/core/widgets/custom_text.dart';
import 'package:chat/src/core/widgets/gap.dart';
import 'package:chat/src/feature/home/presentation/screen/get_all_user_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/home_screen.dart';
import 'package:chat/src/feature/home/presentation/screen/profile_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DashboardBottom extends Equatable {
  final String name;
  final IconData icon;

  const DashboardBottom({
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [name, icon];
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashboardBottom> bottomList = [
    const DashboardBottom(
      name: 'Chats',
      icon: Icons.chat_rounded,
    ),
    const DashboardBottom(
      name: 'Friends',
      icon: Icons.person_add_alt_1_rounded,
    ),
    const DashboardBottom(
      name: 'Profile',
      icon: Icons.person_rounded,
    ),
  ];

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.whiteColor.withOpacity(0.15),
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: systemOverlayStyle,
        title: CustomText(
          AppString.appName,
          fontSize: 20.sp,
        ),
      ),
      body: IndexedStack(
        index: selectedTab,
        children: const [
          HomeScreen(),
          GetAllUserScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor.withOpacity(0.15),
          borderRadius: BorderRadius.vertical(top: Radius.circular(2.h)),
        ),
        child: SafeArea(
          child: Row(
            children: List.generate(
              bottomList.length,
              (index) {
                final e = bottomList[index];
                final color = index == selectedTab
                    ? AppColor.whiteColor.withOpacity(0.80)
                    : AppColor.whiteColor.withOpacity(0.30);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabChanged(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          e.icon,
                          size: 20.sp,
                          color: color,
                        ),
                        GapH(0.2.h),
                        CustomText(
                          e.name,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: color,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onTabChanged(int index) {
    if (selectedTab == index) return;
    selectedTab = index;
    setState(() {});
  }
}
