import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/firebase_services.dart';
import 'package:flutter_tourism_app/model/network_model/country_model.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/model/network_model/tour_guide_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_provider.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tourism_app/widgets/filter_sheet_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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
          // ref.read(isLoadMoreProvider.notifier).state = true;

          pageNumber += 1;
          // callApiFn(isScroll: true);
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
    NotificationServices.checkNotficationPermission().then((value) {
      if (value == true) {
        NotificationServices.firebaseInIt(context);
        NotificationServices.foregroundMessaging();
        NotificationServices.setupInteractMessage(context);
      }
    });
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
      "country": ref.read(selectedCountryProvider)?.countryName

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
    List<TourGuidModel> dataa = ref.watch(countryWiseTourGuideDataProvider);
    List<TourGuidModel> searchAmbassdor =
        ref.watch(searchedAmbassdorProvider(dataa));

    CountryModel? selectedCountry = ref.watch(selectedCountryProvider);
    return Scaffold(
        backgroundColor: AppColor.surfaceBackgroundSecondaryColor,
        appBar: AppBarWidget(
          onTap: () {
            context.maybePopPage();
          },
          title: "Ambassadors",
          actions: [
            Container(
              height: 45,
              width: 45,
              // padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(
                right: 20,
              ),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100000)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(800000000),
                  child: SvgPicture(
                    SvgNetworkLoader(
                      selectedCountry?.countryFlagUrl ?? "",
                    ),
                    fit: BoxFit.cover,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            2.height(),
            ref.watch(isLoadingProvider)
                ? const Expanded(child: ListShimmer())
                : Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: _scrollController,
                        itemCount: searchAmbassdor.length,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
                            // margin: EdgeInsets.only(bottom: 2),
                            color: AppColor.surfaceBackgroundColor,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.hideKeypad();
                                    context.navigateNamed(
                                        HomeDetailView.routeName,
                                        arguments: searchAmbassdor[index]
                                            .id
                                            .toString());
                                  },
                                  child: CardWidget(
                                      name: searchAmbassdor[index]
                                          .name
                                          .toString(),
                                      status: searchAmbassdor[index].status ??
                                          false,
                                      url: searchAmbassdor[index]
                                          .images
                                          .toString()),
                                ),
                                if (ref.watch(isLoadMoreProvider) &&
                                    index ==
                                        ref
                                                .watch(
                                                    countryWiseTourGuideDataProvider)
                                                .length -
                                            1)
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 5, bottom: 40),
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
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 40),
                                    child: Text(
                                      "no Data",
                                      style: AppTypography.label18LG,
                                    ),
                                  )
                              ],
                            ),
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
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // color: AppColor.surfaceBackgroundColor,
          border: Border.all(
            width: 0.7,
            color: AppColor.surfaceBackgroundBaseDarkColor,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 380,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: cacheNetworkWidget(context,
                      imageUrl: url, fit: BoxFit.cover)),
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

