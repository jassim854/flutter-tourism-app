import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_routes.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/booking_view.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/view/support_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

PersistentTabController controller = PersistentTabController();

class AppBottomNavigationBar extends ConsumerStatefulWidget {
  static const routeName = "/appBottomNavigationBarView";
  const AppBottomNavigationBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState
    extends ConsumerState<AppBottomNavigationBar> {
  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const BookingView(),
      Container(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: HomeView.routeName,
            onGenerateRoute: AppRoutes.generateRoute),
        icon: const Icon(Icons.home),
        title: ("Home"),
        textStyle: AppTypography.label12XSM,
        activeColorPrimary: AppColor.surfaceBrandPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: BookingView.routeName,
            onGenerateRoute: AppRoutes.generateRoute),
        icon: const Icon(Icons.bookmark_border),
        title: ("Bookings"),
        textStyle: AppTypography.label12XSM,
        activeColorPrimary: AppColor.surfaceBrandPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        // iconSize: 90,

        onPressed: (BuildContext? _) {
          return showCupertinoDialog(
            context: context,
            builder: (_) {
              return CupertinoAlertDialog(
                title: Text(
                  'Support',
                  style: AppTypography.title18LG,
                ),
                content: SizedBox(
                  height: 150,
                  // width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      40.height(),
                      CupertinoTextField(
                        controller: _emailController,
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      8.height(),
                      CupertinoTextField(
                        controller: _phoneController,
                        placeholder: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text(
                      'Cancel',
                    ),
                    textStyle: AppTypography.label16MD
                        .copyWith(color: AppColor.redColor),
                    onPressed: () {
                      _.popPage();
                    },
                  ),
                  CupertinoDialogAction(
                    textStyle: AppTypography.label16MD
                        .copyWith(color: AppColor.textPrimaryColor),
                    child: const Text(
                      'Submit',
                    ),
                    onPressed: () {
                      // You can handle the submission here
                      String email = _emailController.text;
                      String phone = _phoneController.text;

                      _.popPage();
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(CupertinoIcons.settings),
        title: ("Support"),
        textStyle: AppTypography.label12XSM,
        activeColorPrimary: AppColor.surfaceBrandPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  bool isOpen = false;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      // padding: NavBarPadding.all(0),
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor:
          AppColor.surfaceBackgroundColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(12.0),
        colorBehindNavBar: AppColor.surfaceBackgroundColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      // popAllScreensOnTapAnyTabs: true,
      popActionScreens: PopActionScreensType.all,

      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}