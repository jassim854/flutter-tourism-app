import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/dummy_model.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/booking_/booking_view.dart';
import 'package:flutter_tourism_app/view/home_/home_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';

import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeDetailView extends ConsumerStatefulWidget {
  final DummyModel data;
  static const routeName = "/detailView";
  const HomeDetailView({required this.data, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends ConsumerState<HomeDetailView> {
  late ScrollController _scrollController;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _additionalInfoController = TextEditingController();
  @override
  void initState() {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverAppBarWidget(
            backGroundImg: widget.data.downloadUrl,
            value: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.author,
                            style: AppTypography.label16MD,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              Text(
                                "Uk",
                                style: AppTypography.paragraph14MD,
                              )
                            ],
                          ),
                          const RattingWiget(),
                        ],
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  'Enter Details',
                                  style: AppTypography.title18LG,
                                ),
                                content: SizedBox(
                                  height: 250,
                                  // width: 400,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      20.height(),
                                      const CupertinoTextField(
                                        // controller: _emailController,
                                        placeholder: 'name',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      8.height(),
                                      CupertinoTextField(
                                        controller: _emailController,
                                        placeholder: 'Email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      8.height(),
                                      CupertinoTextField(
                                        controller: _phoneController,
                                        placeholder: 'Phone Number',
                                        keyboardType: TextInputType.phone,
                                      ),
                                      8.height(),
                                      CupertinoTextField(
                                        controller: _additionalInfoController,
                                        placeholder: 'Additional Information',
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    textStyle: AppTypography.label16MD
                                        .copyWith(color: AppColor.redColor),
                                    onPressed: () {
                                      context.popPage();
                                    },
                                    child: const Text(
                                      'Cancel',
                                    ),
                                  ),
                                  CupertinoDialogAction(
                                    textStyle: AppTypography.label16MD.copyWith(
                                        color: AppColor.textPrimaryColor),
                                    child: const Text(
                                      'Submit',
                                    ),
                                    onPressed: () {
                                      // You can handle the submission here
                                      String email = _emailController.text;
                                      String phone = _phoneController.text;
                                      String additionalInfo =
                                          _additionalInfoController.text;

                                      Navigator.of(context).pop();
                                      selectDateSheetWidget(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        title: 'Book',
                      )
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
                    "Противно на всеобщото вярване, Lorem Ipsum не е просто случаен текст. Неговите корени са в класическата Латинска литература от 45г.пр.Хр., което прави преди повече от 2000 години. Richard McClintock, професор по Латински от колежа Hampden-Sydney College във Вирджиния, изучавайки една от най-неясните латински думи  в един от пасажите на Lorem Ipsum, и търсейки цитати на думата в класическата литература, открива точния източник. Lorem Ipsum е намерен в секции 1.10.32 и 1.10.33 от de Finibus Bonorum et Malorum райностите на Доброто и Злото) от Цицерон, написан през 45г.пр.Хр. Тази книга е трактат по теория на етиката, много популярна през Ренесанса. Първият ред на Lorem Ipsum идва от ред, намерен в секция 1.10.32.",
                    style: AppTypography.paragraph14MD,
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 16),
              child: Text(
                "More From UK",
                style: AppTypography.title18LG,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              height: 110,
              child: ListView.builder(
                itemCount: dummyNames.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          onBackgroundImageError: (exception, stackTrace) {},
                          radius: 25,
                          backgroundImage: cachedNetworkImageProvider(
                              imageUrl: "https://picsum.photos/150"),
                        ),
                        10.height(),
                        Text(
                          dummyNames[index],
                          style: AppTypography.paragraph18XL,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> selectDateSheetWidget(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColor.surfaceBackgroundBaseColor,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(
          children: [
            40.height(),
            const Image(image: AssetImage(AppAssets.boxIcon)),
            Text(
              "Select Date",
              style: AppTypography.title40_4XL
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColor.surfaceBackgroundColor,
              surfaceTintColor: AppColor.surfaceBackgroundColor,
              child: Theme(
                data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.light(primary: Colors.red),
                ),
                child: CalendarDatePicker(
                  // initialCalendarMode: DatePickerMode.year,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2050),
                  onDateChanged: (value) {},
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () {
                        SelectTimeSheetWidget(context);
                      },
                      title: 'Continue',
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> SelectTimeSheetWidget(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColor.surfaceBackgroundBaseColor,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            40.height(),
            const Image(image: AssetImage(AppAssets.boxIcon)),
            Text(
              "Select time",
              style: AppTypography.title40_4XL
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                // initialEntryMode: TimePickerEntryMode.input,
                onDateTimeChanged: (DateTime value) {},
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () {
                        confirmBookingSheetWidget(context);
                      },
                      title: 'Continue',
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> confirmBookingSheetWidget(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColor.surfaceBackgroundBaseColor,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(children: [
          40.height(),
          const Image(image: AssetImage(AppAssets.boxIcon)),
          Text(
            "Confirm Booking",
            style:
                AppTypography.title40_4XL.copyWith(fontWeight: FontWeight.w400),
          ),
          100.height(),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                const ConfirmBookRowWidget(title: 'Date', subtitle: ''),
                20.height(),
                const ConfirmBookRowWidget(title: "Time", subtitle: ""),
                20.height(),
                const ConfirmBookRowWidget(
                  title: "Name",
                  subtitle: "",
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: Row(children: [
                Expanded(
                    child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // context.navigateToRemovedUntilNamed(BookingView.routeName);
                    controller.jumpToTab(1);
                  },
                  title: "Confirm",
                ))
              ]))
        ]);
      },
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
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 4.5, color: AppColor.surfaceBrandPrimaryColor)),
          child: Icon(
            Icons.check,
            shadows: [
              Shadow(
                  blurRadius: 0,
                  offset: const Offset(0, 1),
                  color: AppColor.surfaceBrandPrimaryColor),
              Shadow(
                  blurRadius: 0,
                  offset: const Offset(0, 1.1),
                  color: AppColor.surfaceBrandPrimaryColor)
            ],
            weight: 10000,
            color: AppColor.surfaceBrandPrimaryColor,
          ),
        ),
        20.width(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.title18LG,
            ),
            1.height(),
            Text(
              "222",
              style: AppTypography.paragraph16LG,
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
