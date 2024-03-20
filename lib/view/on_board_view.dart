import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/on_board_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/on_board_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
    // TODO: implement initState
    super.initState();
  }

  initilize() async {
    preferences = await SharedPreferences.getInstance();
  }

  callApi() async {
    ref.read(isNoDataProvider.notifier).state = false;
    ref.read(isLoadingProvider.notifier).state = true;
    await ref.read(apiServiceProvider).getOnBoardData(context).then((value) {
      if (value != null) {
        ref.read(onBoardDataProvider.notifier).addData(value);

        ref.read(isLoadingProvider.notifier).state = false;
      } else {
        ref.read(isNoDataProvider.notifier).state = true;
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    OnBoardModel? onBoarData = ref.watch(onBoardDataProvider);
    return Scaffold(
        backgroundColor: AppColor.surfaceBackgroundColor,
        body: ref.watch(isLoadingProvider) == true || onBoarData == null
            ? const Center(
                child: CupertinoActivityIndicator(radius: 30),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 30),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Flexible(
                            child: Container(
                              // height: 350,
                              margin: const EdgeInsets.only(top: 30),
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: cacheNetworkWidget(
                                  context,
                                  imageUrl: onBoarData.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          20.height(),
                          Text(
                            onBoarData.heading,
                            style: AppTypography.label18LG.copyWith(
                                fontFamily: AppTypography.fontFamily2,
                                fontSize: 24,
                                color: AppColor.textBlackColor),
                          ),
                          20.height(),
                          Text(
                            onBoarData.description,
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
