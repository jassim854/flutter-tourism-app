import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:flutter_tourism_app/widgets/container_bar_widget.dart';
import 'package:flutter_tourism_app/widgets/country_picker_sheet_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardView extends ConsumerStatefulWidget {
  static const routeName = "/onBoardView";
  const OnBoardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends ConsumerState<OnBoardView> {
  late SharedPreferences preferences;
  @override
  void initState() {
    initilize();
    // TODO: implement initState
    super.initState();
  }

  initilize() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        backgroundColor: AppColor.surfaceBackgroundColor,
        body: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                      
                        margin: const EdgeInsets.only(top: 30),
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            AppAssets.onBoardImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    20.height(),
                    Text(
                      "Welcome! We're thrilled to have you on board.",
                      style: AppTypography.label18LG.copyWith(
                          fontFamily: AppTypography.fontFamily2,
                          fontSize: 24,
                          color: AppColor.textBlackColor),
                    ),
                    20.height(),
                    Text(
                      "Welcome to Cultural Guides by SMCCU! 🌍 Discover the essence of cultural exploration with our innovative ambassador booking app. Immerse yourself in authentic experiences curated by knowledgeable ambassadors ready to unveil the hidden gems of each destination.",
                      style: AppTypography.paragraph16LG
                          .copyWith(color: AppColor.textSubTitleColor),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        preferences.setBool("isFirstTime", false);
                        context.navigateToRemovedUntilNamed(
                            AppBottomNavigationBar.routeName);
                      },
                      title: "Start now",
                      textColor: AppColor.textWhiteColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
