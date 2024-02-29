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
  late PageController _pageController;

  late SharedPreferences preferences;
  @override
  void initState() {
    _pageController = PageController();
initilize();
    // TODO: implement initState
    super.initState();
  }
  initilize() async{
    preferences=await SharedPreferences.getInstance();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // int currentStep = ref.watch(onBoardProvider);

    List<String> images = [
      AppAssets.onBoardImage1,
      AppAssets.onBoardImage2,
      AppAssets.onBoardImage3,
      AppAssets.onBoardImage4
    ];
    List<String> title = [
      "Welcome! We're thrilled to have you on board",
      "Welcome! We're thrilled to have you on board",
      "Welcome! We're thrilled to have you on board",
      "Welcome! We're thrilled to have you on board"
    ];
    List<String> subtitle = [
      "Capture your ideas, orgainze your thoughts, and never missan important details again.",
      "Record your thoughts in the blink of an eye, Start creating your first note and seehow our app empowers you to capture ideas on the go.",
      "Create notebooks, tags, and folders to categorize your notes and keep everything neatly sorted.",
      "No matter where you are, access your notes on all device seamlessly. Let's get started on your productive note-taking journey!"
    ];
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundColor,
      body: SafeArea(
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ContainerBarWidget(
                          color: AppColor.surfaceBrandDarkColor,
                        ),
                      ),
                      8.width(),
                      Expanded(
                        child: ContainerBarWidget(
                          color: index >= 1
                              ? AppColor.surfaceBrandDarkColor
                              : AppColor.surfaceBackgroundBaseDarkColor,
                        ),
                      ),
                      8.width(),
                      Expanded(
                        child: ContainerBarWidget(
                          color: index >= 2
                              ? AppColor.surfaceBrandDarkColor
                              : AppColor.surfaceBackgroundBaseDarkColor,
                        ),
                      ),
                      8.width(),
                      Expanded(
                        child: ContainerBarWidget(
                          color: index == 3
                              ? AppColor.surfaceBrandDarkColor
                              : AppColor.surfaceBackgroundBaseDarkColor,
                        ),
                      )
                    ],
                  ),
                  10.height(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Steps ${index + 1} / 4",
                        style: AppTypography.title18LG,
                      ),
                      if (index < 3)
                        GestureDetector(
                          onTap: () {
preferences.setBool("isFirstTime", false);
                            context.navigateToRemovedUntilNamed(
                                SelectCountryView.routeName);
                          },
                          child: Text(
                            "Skip",
                            style: AppTypography.title18LG
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        )
                      // CustomElevatedButton(
                      //   onPressed: () {
                      //     context.navigateToRemovedUntilNamed(
                      //         SelectCountryView.routeName);
                      //     // countryPickerSheetWidget(
                      //     //   context,
                      //     //   onSelect: (p0) {
                      //     //     print(p0);
                      //     //     WidgetsBinding.instance
                      //     //         .addPostFrameCallback((_) {

                      //     //     });
                      //     //   },
                      //     // );
                      //   },
                      //   title: "Skip",
                      //   textColor: AppColor.textWhiteColor,
                      // )
                    ],
                  ),
                  Container(
                    height: 220,
                    margin: const EdgeInsets.only(top: 30),
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  20.height(),
                  Text(
                    title[index],
                    style: AppTypography.title24XL
                        .copyWith(color: AppColor.textBlackColor),
                  ),
                  20.height(),
                  Text(
                    subtitle[index],
                    style: AppTypography.label18LG
                        .copyWith(color: AppColor.textBlackColor),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (index < 3) {
                              await _pageController.animateToPage(index + 1,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutBack);
                            } else {
                              preferences.setBool("isFirstTime", false);
                              context.navigateToRemovedUntilNamed(
                                  SelectCountryView.routeName);
                              // countryPickerSheetWidget(
                              //   context,
                              //   onSelect: (p0) {
                              //     print(p0);
                              //     WidgetsBinding.instance
                              //         .addPostFrameCallback((_) {

                              //     });
                              //   },
                              // );
                            }
                          },
                          title: index == 3 ? "Start now" : "Next",
                          textColor: AppColor.textWhiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
