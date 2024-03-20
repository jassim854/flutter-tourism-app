import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/firebase_services.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/model/network_model/country_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_list_provider.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/booking_/car_view.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SelectCountryView extends ConsumerStatefulWidget {
  static const routeName = "/selectCountryView";
  const SelectCountryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectCountryViewState();
}

class _SelectCountryViewState extends ConsumerState<SelectCountryView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // ref.read(searchedCountryProvider.notifier).addData(countryNames);
    // TODO: implement dispose
    super.dispose();
  }

  callApi() async {
    ref.read(isNoDataProvider.notifier).state = false;
    ref.read(isLoadingProvider.notifier).state = true;
    await ref
        .read(apiServiceProvider)
        .getAllcountriesRequest(context)
        .then((value) {
      if (value != null) {
        NotificationServices.requestNotificationPermission(context)
            .then((value) {
          if (value == true) {
            NotificationServices.firebaseInIt(context);
            NotificationServices.foregroundMessaging();
            NotificationServices.setupInteractMessage(context);

            NotificationServices.getDeviceToken().then((value) async {
              ref.read(deviceTokenProvider.notifier).state = value;
            });
          }
        });
        ref.read(countryListDataProvider.notifier).addData(value);

        ref.read(selectedCountryProvider.notifier).state = value[0];
        ref.read(isLoadingProvider.notifier).state = false;
      } else {
        ref.read(isNoDataProvider.notifier).state = true;
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CountryModel> countryListData = ref.watch(countryListDataProvider);
    // bool closeIcon = ref.watch(showCloseIconProvider);
    CountryModel? selectedCountry = ref.watch(selectedCountryProvider);
    // List<CountryModel> searchedCountries =
    //     ref.watch(searchedCountryProvider(countryListData));
    return Scaffold(
      backgroundColor: AppColor.surfaceBackgroundSecondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBarWidget(
          // toolBarHeight: 200,
          leadingWidth: 0,
          centerTitle: true,
          titleWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: FittedBox(
              child: SvgPicture.asset(
                AppAssets.appLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: AppColor.surfaceBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  AppAssets.onBoardImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            2.height(),
            Expanded(
              child: ColoredBox(
                color: AppColor.surfaceBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      25.height(),
                      Text(
                        "Select Country",
                        style: AppTypography.label18LG.copyWith(
                            fontSize: 24, color: AppColor.textBlackColor),
                      ),
                      15.height(),
                      ref.watch(isLoadingProvider)
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                radius: 30,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: countryListData.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.only(
                                        left: 6, top: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                        color: selectedCountry?.countryName ==
                                                countryListData[index]
                                                    .countryName
                                            ? AppColor.surfaceBrandDarkColor
                                            : null,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            width: 1,
                                            color: AppColor
                                                .surfaceBackgroundSecondaryColor)),
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(selectedCountryProvider
                                                .notifier)
                                            .state = countryListData[index];
                                        context
                                            .navigateNamed(HomeView.routeName);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 1.2,
                                                    color: AppColor
                                                        .surfaceBackgroundColor)),
                                            height: 28,
                                            width: 42,
                                            child: SvgPicture.network(
                                              countryListData[index]
                                                  .countryFlagUrl
                                                  .trim(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          8.width(),
                                          Text(
                                            countryListData[index].countryName,
                                            style: AppTypography.label18LG
                                                .copyWith(
                                                    fontSize: 20,
                                                    color: selectedCountry
                                                                ?.countryName ==
                                                            countryListData[
                                                                    index]
                                                                .countryName
                                                        ? AppColor
                                                            .textWhiteColor
                                                        : AppColor
                                                            .textBlackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  ),
                ),
              ),
            )
            // Card(
            //   color: AppColor.surfaceBackgroundColor,
            //   surfaceTintColor: AppColor.surfaceBackgroundColor,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(22)),
            //   margin: const EdgeInsets.only(top: 2),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 20),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 'Country',
            //                 style: AppTypography.title14XS,
            //               ),
            //               Text(
            //                 'Flag',
            //                 style: AppTypography.title14XS,
            //               )
            //             ],
            //           ),
            //         ),
            //         const Divider(),
            //         ref.watch(isLoadingProvider)
            //             ? const Center(
            //                 child: CupertinoActivityIndicator(
            //                   radius: 30,
            //                 ),
            //               )
            //             : Expanded(
            //                 child: ListView.separated(
            //                   itemCount: searchedCountries.length,
            //                   itemBuilder: (_, index) {
            //                     return ListTile(
            //                       selected:
            //                           searchedCountries[index].countryName ==
            //                                   selectedCountry?.countryName
            //                               ? true
            //                               : false,
            //                       selectedTileColor:
            //                           AppColor.surfaceBrandPrimaryColor,
            //                       title: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Text(searchedCountries[index].countryName,
            //                               style: AppTypography.label18LG),
            //                           SizedBox(
            //                               height: 30,
            //                               width: 30,
            //                               child: SvgPicture.network(
            //                                   searchedCountries[index]
            //                                       .countryFlagUrl)),
            //                         ],
            //                       ),
            //                       onTap: () {
            //                         ref
            //                             .read(selectedCountryProvider.notifier)
            //                             .state = searchedCountries[index];
            //                         // _.navigatepushReplacementNamed(AppBottomBar.routeName);
            //                       },
            //                     );
            //                   },
            //                   separatorBuilder:
            //                       (BuildContext context, int index) {
            //                     return const Divider();
            //                   },
            //                 ),
            //               )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
