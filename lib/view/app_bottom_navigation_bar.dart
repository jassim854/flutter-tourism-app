import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';

import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_routes.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/booking_view.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:flutter_tourism_app/view/support_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      const SelectCountryView(),
      const BookingView(),
      const SupportView(),
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
        onSelectedTabPressWhenNoScreensPushed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String? value = preferences.getString("email");
          if (value != null) {
            ref.read(isLoadingProvider.notifier).state = true;

            await ref.read(apiServiceProvider).getUserBookedRequest(context,
                payload: {"user_email": value}).then((val) {
              if (val != null) {
                ref.read(userAllBookedListProvider.notifier).addValue(val);
                ref.read(isLoadingProvider.notifier).state = false;

                // ref
                //     .read(userConfirmedBookedListProvider.notifier)
                //     .addValue(val);
                ref.read(userCompletedListProvider.notifier).addValue(val);
                ref
                    .read(userCancelledBookedListProvider.notifier)
                    .addValue(val);
                // ref.read(userPendingBookedListProvider.notifier).addValue(val);
              } else {
                ref.read(isLoadingProvider.notifier).state = false;
              }
            });
          }
        },
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: BookingView.routeName,
            onGenerateRoute: AppRoutes.generateRoute),
        icon: Transform.scale(
            scale: 2.5,
            origin: Offset(0, -5),
            child: Image.asset(AppAssets.book)),
        title: ("Reservations"),
        textStyle: AppTypography.label12XSM,
        activeColorPrimary: AppColor.surfaceBrandPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        // iconSize: 90,

        // onPressed: (BuildContext? _) {
        //   // return showCupertinoDialog(
        //   //   context: context,
        //   //   builder: (_) {
        //   //     return CupertinoAlertDialog(
        //   //       title: Text(
        //   //         'Support',
        //   //         style: AppTypography.title18LG,
        //   //       ),
        //   //       content: SizedBox(
        //   //         height: 150,
        //   //         // width: 400,
        //   //         child: Column(
        //   //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //   //           children: [
        //   //             40.height(),
        //   //             CupertinoTextField(
        //   //               controller: _emailController,
        //   //               placeholder: 'Email',
        //   //               keyboardType: TextInputType.emailAddress,
        //   //             ),
        //   //             8.height(),
        //   //             CupertinoTextField(
        //   //               controller: _phoneController,
        //   //               placeholder: 'Phone Number',
        //   //               keyboardType: TextInputType.phone,
        //   //             ),
        //   //           ],
        //   //         ),
        //   //       ),
        //   //       actions: [
        //   //         CupertinoDialogAction(
        //   //           child: const Text(
        //   //             'Cancel',
        //   //           ),
        //   //           textStyle: AppTypography.label16MD
        //   //               .copyWith(color: AppColor.redColor),
        //   //           onPressed: () {
        //   //             _.popPage();
        //   //           },
        //   //         ),
        //   //         CupertinoDialogAction(
        //   //           textStyle: AppTypography.label16MD
        //   //               .copyWith(color: AppColor.textPrimaryColor),
        //   //           child: const Text(
        //   //             'Submit',
        //   //           ),
        //   //           onPressed: () {
        //   //             // You can handle the submission here
        //   //             String email = _emailController.text;
        //   //             String phone = _phoneController.text;

        //   //             _.popPage();
        //   //           },
        //   //         ),
        //   //       ],
        //   //     );
        //   //   },
        //   // );
        // },
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: SupportView.routeName,
            onGenerateRoute: AppRoutes.generateRoute),
        icon: Transform.scale(
            scale: 2.5,
            origin: Offset(0, -5),
            child: Image.asset(AppAssets.support)),
        title: ("Support"),
        textStyle: AppTypography.label12XSM,
        activeColorPrimary: AppColor.surfaceBrandPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

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

      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(12.0),
        colorBehindNavBar: AppColor.surfaceBackgroundColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      // popAllScreensOnTapAnyTabs: true,

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
