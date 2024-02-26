import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/model/dummy_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
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
import 'package:shimmer/shimmer.dart';

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
      ref.read(dummyListDataProvider).clear();

      pageNumber = 1;
    }

    await ref.read(apiServiceProvider).getDummyList(context,
        data: {"page": pageNumber.toString(), "limit": "10"}).then((value) {
      if (value != null && value.isNotEmpty) {
        ref.read(nextPageProvider.notifier).state = true;

        ref.read(isLoadMoreProvider.notifier).state = false;
        ref.read(dummyListDataProvider.notifier).addData(value);

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
    int length = ref.watch(dummyListDataProvider).length;
    bool closeIcon = ref.watch(showCloseIconProvider);

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
                  delayedFunction(
                      // timer: timer,
                      fn: () {
                    print(value);
                  });
                },
                onIconTap: () {
                  ref.read(showCloseIconProvider.notifier).state = false;
                  _searchController.clear();
                },
                searchController: _searchController),
            actions: [
              Container(
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
        body: ref.watch(isLoadingProvider)
            ? const ListShimmer()
            : ListView.builder(
                controller: _scrollController,
                itemCount: length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                                  context.navigateNamed(HomeDetailView.routeName, arguments: ref.read(dummyListDataProvider)[index]);
                        },
                        child: CardWidget(
                          name: ref.watch(dummyListDataProvider)[index].author,
                          id: ref.watch(dummyListDataProvider)[index].id,
                          url:
                              ref.watch(dummyListDataProvider)[index].downloadUrl,
                        ),
                      ),
                      if (ref.watch(isLoadMoreProvider) &&
                          index == ref.watch(dummyListDataProvider).length - 1)
                        const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 40),
                          child: CupertinoActivityIndicator(
                            radius: 18,
                          ),
                        ),
                      if (ref.watch(nextPageProvider) == false &&
                          index == ref.watch(dummyListDataProvider).length - 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 40),
                          child: Text(
                            "no Data",
                            style: AppTypography.label18LG,
                          ),
                        )
                    ],
                  );
                }));
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
                  const RattingWiget(),
                  8.height(),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
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
  final String name, id, url;
  const CardWidget(
      {super.key, required this.name, required this.id, required this.url});

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
                      width: 2.5, color: AppColor.surfaceBrandPrimaryColor),
                  borderRadius: BorderRadius.circular(16)),
              height: 200,
              child:
                  cacheNetworkWidget(context, imageUrl: url, fit: BoxFit.cover),
            ),
            8.height(),
            Text(
              name,
              style: AppTypography.label18LG,
            ),
            8.height(),
            const RattingWiget(),
            8.height(),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                8.width(),
                Text(
                  id,
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

class DropDownContainer extends ConsumerStatefulWidget {
  const DropDownContainer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DropDownContainerState();
}

class _DropDownContainerState extends ConsumerState<DropDownContainer> {
  String dropdownvalue = '';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(width: 3.5, color: AppColor.surfaceBrandPrimaryColor)),
      child: DropdownButton(
        hint: const Text("Country"),
        underline: const SizedBox.shrink(),
        // Initial Value
        value: dropdownvalue.isEmpty ? null : dropdownvalue,
        elevation: 0,
        // borderRadius: BorderRadius.circular(30),
        padding: const EdgeInsets.only(left: 0),
        // alignment: AlignmentDirectional.bottomStart,
        dropdownColor: AppColor.surfaceBackgroundColor,
        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        },
      ),
    );
  }
}
