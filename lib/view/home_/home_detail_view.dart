import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/model/network_model/a_tour_guide_model.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/model/network_model/tour_guide_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_detail_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';

import 'package:flutter_tourism_app/view/home_/book_view.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/widgets/book_bottom_sheet.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';

import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';

class HomeDetailView extends ConsumerStatefulWidget {
  final String id;
  static const routeName = "/detailView";
  const HomeDetailView({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends ConsumerState<HomeDetailView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 155) {
          // centerTitle = true;
        } else if (_scrollController.offset < 160) {
          // centerTitle.value = false;
        }
      });
    // TODO: implement initState
    super.initState();
  }

  callApi() async {
    ref.read(isLoadingProvider.notifier).state = true;
    ref.read(isNoDataProvider.notifier).state = false;
    await ref.read(apiServiceProvider).getATourGuideRequest(context,
        payload: {"id": widget.id}).then((value) {
      if (value != null) {
        ref.read(aTourGuideProvider.notifier).addData(value);
        ref.read(isLoadingProvider.notifier).state = false;
      } else {
        ref.read(isNoDataProvider.notifier).state = true;
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
  }

  List<String> dummyNames = [
    'John Smith',
    'Emily Johnson',
    'Michael Brown',
    'Sarah Davis',
    'David Wilson',
    'Jessica Martinez',
    'Robert Anderson',
    'Jennifer Taylor',
    'William Thomas',
    'Amanda Garcia',
  ];
  List<String> dummyImages = [
    "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGVyc29ufGVufDB8fDB8fHww",
    "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqjhFHlDHQi2QahdbwAe2RzFlw3894RkzCgDueYWxpmw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRImhGqnK1GlnIeKEMt0M-t9JqsjVbdoZNLWXW-Xp64M6eN4oVzB43YFImf9A&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREVbsZiiOitWNNhWRiSlCS4sNuQO_YEFqs2w&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzNF2YIDP9cVqoLBNf4Pr7kJ82bWmA1Ups2g&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE4g-3ZH_1TjfN-zOuCRru2LrfrGtPbwaCsQ&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJRFPeLuX1CzCS21KZB6BpL0zSeVxKHwg1Mw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToOoJnrndFqTIcvygz9DmXfGbhxfTCxss17g&s"
  ];
  @override
  Widget build(BuildContext context) {
    //https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTUzn7-qinvq-jbUgQWNL-OfnXUFXfxbtwMs6-Utey3A&s
    ATourGuideModel? data = ref.watch(aTourGuideProvider);

    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: ref.watch(isLoadingProvider) == true || data == null
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 35,
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: [
                SliverAppBarWidget(
                  backGroundImg: data.images.toString(),
                  value: false,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name.toString(),
                                  style: AppTypography.label16MD,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    5.width(),
                                    Text(
                                      data.location.toString(),
                                      style: AppTypography.paragraph14MD,
                                    )
                                  ],
                                ),
                                // const RattingWiget(),
                              ],
                            ),
                            Builder(builder: (context) {
                              return CustomElevatedButton(
                                childPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                radius: 20,
                                onPressed: () async {
                                  await showModalBottomSheet(
                                      useSafeArea: true,
                                      enableDrag: false,
                                      isDismissible: false,
                                      backgroundColor:
                                          AppColor.surfaceBackgroundBaseColor,
                                      isScrollControlled: true,
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (context) {
                                        return PopScope(
                                            canPop: false,
                                            child: SelectedDateSheetWidget());
                                      });
                                },
                                title: 'Book Now',
                              );
                            })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: AppTypography.label18LG,
                        ),
                        8.height(),
                        Text(
                          data.description.toString(),
                          style: AppTypography.paragraph14MD,
                        )
                      ],
                    ),
                  ),
                ),
                if (data.similarTourGuides?.isNotEmpty ?? false) ...[
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, left: 16),
                      child: Text(
                        "More From ${data.location}",
                        style: AppTypography.title18LG,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      height: 110,
                      child: ListView.builder(
                        itemCount: data.similarTourGuides?.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.navigatepushReplacementNamed(
                                  HomeDetailView.routeName,
                                  arguments: data.similarTourGuides![index].id
                                      .toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    onBackgroundImageError:
                                        (exception, stackTrace) {},
                                    radius: 25,
                                    backgroundImage: cachedNetworkImageProvider(
                                        imageUrl: data
                                            .similarTourGuides![index].images
                                            .toString()),
                                  ),
                                  10.height(),
                                  Text(
                                    data.similarTourGuides![index].name
                                        .toString(),
                                    style: AppTypography.paragraph18XL,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ]
              ],
            ),
    );
  }

//   void _showCalendarBottomSheet(BuildContext context, DateTime _selectedDate) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 300,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.dateAndTime,
//             initialDateTime: _selectedDate,
//             minimumDate: _selectedDate,
//             maximumDate: _selectedDate
//                 .add(Duration(days: 7)), // Show calendar for a week
//             onDateTimeChanged: (DateTime newDate) {
//               // Handle date selection from calendar
//               print('Selected date from calendar: $newDate');
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showDateSelectionBottomSheet(BuildContext context) async {
//     await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 200,
//           child: CupertinoDatePicker(
//             maximumYear: 4,
//             minimumYear: 2,
//             mode: CupertinoDatePickerMode.dateAndTime,
//             initialDateTime: _selectedDate ?? DateTime.now(),
//             onDateTimeChanged: (DateTime newDate) {
//               setState(() {
//                 _selectedDate = newDate;
//               });
//             },
//           ),
//         );
//       },
//     ).then((_) {
//       if (_selectedDate != null) {
//         _showCalendarBottomSheet(context, _selectedDate!);
//       }
//     });
//   }
}

class ConfirmBookRowWidget extends StatelessWidget {
  final String title, subtitle;
  const ConfirmBookRowWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(4),
            child: SvgPicture(SvgAssetLoader(title
                    .toLowerCase()
                    .contains("name")
                ? AppAssets.userIcon
                : title.toLowerCase().contains("email")
                    ? AppAssets.emailIcon
                    : title.toLowerCase().contains("phone")
                        ? AppAssets.phoneIcon
                        : title.toLowerCase().contains("date")
                            ? AppAssets.dateIcon
                            : title.toLowerCase().contains("booking start time")
                                ? AppAssets.clockIcon
                                : title.toLowerCase().contains("booking hours")
                                    ? AppAssets.watchIcon
                                    : title
                                            .toLowerCase()
                                            .contains("booking end time")
                                        ? AppAssets.clockIcon
                                        : ""))),
        15.width(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.title18LG.copyWith(fontSize: 15),
            ),
            // 1.height(),
            Text(
              subtitle,
              style: AppTypography.paragraph16LG
                  .copyWith(fontSize: 15, color: AppColor.textSubTitleColor),
            )
          ],
        )
      ],
    );
  }
}
/*  expandedTitleScale: 1,
          titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
          title: Visibility(
            visible: value == false ? true : false,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    flexibleTitle,
                    style: AppTypography.title24XL
                        .copyWith(color: AppColor.textWhiteColor),
                  ),
                  // flexibleSubtitleWidget
                ],
              ),
            ),
          ), */
