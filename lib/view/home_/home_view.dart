import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_list_provider.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tourism_app/widgets/filter_sheet_widget.dart';
import 'package:shimmer/shimmer.dart';

GlobalKey dropdownKey = GlobalKey();

class HomeView extends ConsumerStatefulWidget {
  static const routeName = "/homeView";
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  int pageNumber = 1;
  Timer? timer;

  @override
  void initState() {
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    // getData(categoryName: widget.categoryName, isScroll: false);

    _scrollController.addListener(
      () {
        if (ref.read(isLoadMoreProvider.notifier).state == false &&
            ref.read(nextPageProvider.notifier).state == true &&
            _scrollController.position.extentAfter < 300 &&
            _scrollController.position.extentAfter != 0.0) {
          ref.read(isLoadMoreProvider.notifier).state = true;

          pageNumber += 1;
          callApiFn(isScroll: true);
        }
      },
    );
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApiFn(isScroll: false);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    if (timer?.isActive ?? false) {
      timer!.cancel();
    }
    // TODO: implement dispose
    super.dispose();
  }

  callApiFn({required bool isScroll}) async {
    ref.read(isLoadingProvider.notifier).state =
        isScroll == true ? false : true;
    ref.read(isNoDataProvider.notifier).state = false;

    if (isScroll == false) {
      ref.read(countryWiseTourGuideDataProvider).clear();

      pageNumber = 1;
    }

    await ref
        .read(apiServiceProvider)
        .getCountryWiseTourGuideRequest(context, payload: {
      "country": ref.read(selectedCountryProvider)

      // "page": pageNumber.toString(), "limit": "10"
    }).then((value) {
      if (value != null && value.isNotEmpty) {
        ref.read(nextPageProvider.notifier).state = true;

        ref.read(isLoadMoreProvider.notifier).state = false;
        ref.read(countryWiseTourGuideDataProvider.notifier).addData(value);

        ref.read(isLoadingProvider.notifier).state =
            isScroll == true ? false : false;
      } else if (value?.isEmpty ?? false) {
        ref.read(nextPageProvider.notifier).state = false;
        ref.read(isLoadMoreProvider.notifier).state = false;
        ref.read(isLoadingProvider.notifier).state =
            isScroll == true ? false : false;
      } else if (value == null) {
        ref.read(isLoadMoreProvider.notifier).state = false;
        ref.read(isNoDataProvider.notifier).state = true;
        ref.read(nextPageProvider.notifier).state = true;

        ref.read(isLoadingProvider.notifier).state =
            isScroll == true ? false : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int length = ref.watch(countryWiseTourGuideDataProvider).length;
    bool closeIcon = ref.watch(showCloseIconProvider);
    String selectedCountry = ref.watch(selectedCountryProvider);
    return Scaffold(
        appBar: AppBarWidget(

          title: "Ambassadors",
          bottomBarWidget: AppBar(
            surfaceTintColor: AppColor.surfaceBackgroundColor,
            elevation: 0,
            backgroundColor: AppColor.surfaceBackgroundColor,
            leadingWidth: 0,
            titleSpacing: 0,
            leading: const SizedBox.shrink(),
            title: CustomSearchTextFieldWidget(
                hintText: "Search",
                showCloseIcon: closeIcon,
                onChange: (value) {
                  if (value == "") {
                    ref.read(showCloseIconProvider.notifier).state = false;
                  } else {
                    ref.read(showCloseIconProvider.notifier).state = true;
                  }
                  delayedFunction(fn: () {
                    print(value);
                  });
                },
                onIconTap: () {
                  ref.read(showCloseIconProvider.notifier).state = false;
                  _searchController.clear();
                },
                searchController: _searchController),
            actions: [
              InkWell(
                onTap: () async {
                  context.hideKeypad();
                  await showModalBottomSheet(
                    useSafeArea: true,
                    enableDrag: false,
                    isDismissible: false,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    backgroundColor: AppColor.surfaceBackgroundBaseColor,
                    isScrollControlled: true,
                    context: context,
                    builder: (_) {
                      return PopScope(
                        canPop: false,
                        child: FilterSheetWidget(() {
                          callApiFn(isScroll: false);
                        }),
                      );
                    },
                  );
                  // dynamic state = dropdownKey.currentState;
                  // state.showButtonMenu();
                  // dropdownKey.currentState?.widget
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 20, left: 4),
                  decoration: BoxDecoration(
                      color: AppColor.surfaceBrandPrimaryColor,
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    AppAssets.filterIcon,
                    color: AppColor.surfaceBackgroundColor,
                  ),
                ),
              )
              // _searchController.text.isNotEmpty
              //     ? GestureDetector(
              //         onTap: () {
              //           context.hideKeypad();
              //           _searchController.clear();
              //         },
              //         child: Container(
              //           alignment: Alignment.center,
              //           margin: const EdgeInsets.only(right: 20),
              //           child: Text("Cancel",
              //               style: AppTypography.label14SM.copyWith(
              //                 color: AppColor.textPrimaryColor,
              //               )),
              //         ),
              //       )
              //     : Container()
            ],
          ),
        ),
        body: Column(
          children: [
            ColoredBox(
              color: AppColor.surfaceBackgroundColor,
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          width: 3.5,
                          color: AppColor.surfaceBrandPrimaryColor)),
                  child: Text(
                    selectedCountry,
                    style: AppTypography.label18LG,
                  )),
            ),
            ref.watch(isLoadingProvider)
                ? const Expanded(child: ListShimmer())
                : Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.navigateNamed(
                                      HomeDetailView.routeName,
                                      arguments: ref
                                          .read(countryWiseTourGuideDataProvider)[
                                              index]
                                          .id
                                          .toString());
                                },
                                child: CardWidget(
                                  name: ref
                                      .watch(countryWiseTourGuideDataProvider)[
                                          index]
                                      .name
                                      .toString(),
                                  status: ref
                                          .watch(countryWiseTourGuideDataProvider)[
                                              index]
                                          .status ??
                                      false,
                                  url: ref
                                      .watch(countryWiseTourGuideDataProvider)[
                                          index]
                                      .images![1]
                                      .toString(),
                                ),
                              ),
                              if (ref.watch(isLoadMoreProvider) &&
                                  index ==
                                      ref
                                              .watch(
                                                  countryWiseTourGuideDataProvider)
                                              .length -
                                          1)
                                const Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 40),
                                  child: CupertinoActivityIndicator(
                                    radius: 18,
                                  ),
                                ),
                              if (ref.watch(nextPageProvider) == false &&
                                  index ==
                                      ref
                                              .watch(
                                                  countryWiseTourGuideDataProvider)
                                              .length -
                                          1)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 40),
                                  child: Text(
                                    "no Data",
                                    style: AppTypography.label18LG,
                                  ),
                                )
                            ],
                          );
                        }),
                  ),
          ],
        ));
  }
}

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.surfaceBackgroundBaseDarkColor,
                        border: Border.all(
                            width: 2.5,
                            color: AppColor.surfaceBrandPrimaryColor),
                        borderRadius: BorderRadius.circular(16)),
                    height: 200,
                  ),
                  8.height(),
                  Text(
                    "Name Space",
                    style: AppTypography.label18LG,
                  ),
                  8.height(),
                  // const RattingWiget(),
                  // 8.height(),
                  Row(
                    children: [
                      Icon(Icons.person),
                      8.width(),
                      Text(
                        "Name Space",
                        style: AppTypography.paragraph16LG,
                      )
                    ],
                  )
                ],
              );
            }));
  }
}

class CardWidget extends StatelessWidget {
  final String name, url;
  final bool status;
  const CardWidget(
      {super.key, required this.name, required this.status, required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColor.surfaceBackgroundColor,
      surfaceTintColor: AppColor.surfaceBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColor.surfaceBackgroundBaseDarkColor,
                  border: Border.all(
                      width: 0.1, color: AppColor.surfaceBrandPrimaryColor),
                  borderRadius: BorderRadius.circular(16)),
              height: 200,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: cacheNetworkWidget(context,
                      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTUzn7-qinvq-jbUgQWNL-OfnXUFXfxbtwMs6-Utey3A&s", fit: BoxFit.cover)),
            ),
            8.height(),
            Text(
              name,
              style: AppTypography.label18LG,
            ),
            8.height(),
            // const RattingWiget(),
            // 8.height(),
            Row(
              children: [
                Icon(Icons.person),
                8.width(),
                // const Icon(Icons.location_on_outlined),
                // 8.width(),
                Text(
                  status ? "Available" : "Not Available",
                  style: AppTypography.paragraph16LG,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RattingWiget extends StatelessWidget {
  const RattingWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: 18,
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}

// class DropDownContainer extends ConsumerWidget {
//   DropDownContainer({super.key});

//   // List of items in our dropdown menu

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     String currentValue = ref.watch(dropdownvalueProvider);
//     return Container(
//       height: 45,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           border:
//               Border.all(width: 3.5, color: AppColor.surfaceBrandPrimaryColor)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             currentValue,
//             style: AppTypography.label18LG,
//           ),
//           PopupMenuButton(
//             // isExpanded: true,
//             key: dropdownKey,
//             initialValue: currentValue,

//             // Initial Value

//             onSelected: (value) {
//               ref.read(dropdownvalueProvider.notifier).state = value;
//             },
//             // borderRadius: BorderRadius.circular(30),

//             // alignment: AlignmentDirectional.bottomStart,
//             color: AppColor.surfaceBackgroundColor,
//             surfaceTintColor: AppColor.surfaceBackgroundColor,
//             // Down Arrow Icon
//             icon: const Icon(Icons.keyboard_arrow_down),

//             // Array list of items
//             itemBuilder: (context) => items.map((String items) {
//               return PopupMenuItem(
//                 value: items,
//                 child: Text(items),
//               );
//             }).toList(),
//             // After selecting the desired option,it will
//             // change button value to selected value
//           ),
//         ],
//       ),
//     );
//   }

