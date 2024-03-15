import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/on_board_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends ConsumerStatefulWidget {
  static const routeName = "/splashView";
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  String firstRouteName = "";
  @override
  void initState() {
    checkIsFirst();
    Future.delayed(const Duration(seconds: 3), () {
      context.navigateToRemovedUntilNamed(firstRouteName);
    });
    // TODO: implement initState
    super.initState();
  }

  checkIsFirst() async {
    SharedPreferences preferences;
    preferences = await SharedPreferences.getInstance();
    bool? value = preferences.getBool("isFirstTime");
    if (value == false) {
      firstRouteName = AppBottomNavigationBar.routeName;
    } else {
      firstRouteName = OnBoardView.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Text(
              "Cultural Guides by",
              style: AppTypography.title40_4XL.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 37,
                  color: AppColor.textLightBlueColor),
              textAlign: TextAlign.center,
            ),
          ),
          10.height(),
          SizedBox(
            height: 77,
            // color: Colors.red,
            child: AnimatedSize(
              duration: const Duration(seconds: 1),
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Image.asset(
                    AppAssets.appLogo,
                    fit: BoxFit.fill,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
