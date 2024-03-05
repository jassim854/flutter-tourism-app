import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/utils/validators.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/booking_/booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/car_view.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';
import 'package:flutter_tourism_app/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookView extends ConsumerStatefulWidget {
  final String id;
  static const routeName = "/bookView";
  const BookView(this.id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookViewState();
}

class _BookViewState extends ConsumerState<BookView> {
  late GlobalKey<FormState> formKey;
  late TextEditingController _nameontroller;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _additionalInfoController;
  @override
  void initState() {
    _additionalInfoController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nameontroller = TextEditingController();
    formKey = GlobalKey<FormState>();
    // TODO: implement initState
    super.initState();
  }

  DateTime currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate = ref.watch(selectedDateProvider);
    DateTime? selectedFromTime = ref.watch(selectedFromTimeProvider);
    DateTime? selectedToTime = ref.watch(selectedToTimeProvider);

    return Scaffold(
      appBar: const AppBarWidget(
        leadingWidth: 40,
        title: "Book Now",
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Text(
                  "Book Ambassdor",
                  style: AppTypography.title24XL,
                )),
                20.height(),
                TextFieldWidget(
                    validator: (p0) => Validators.validateField(p0),
                    hintText: "Enter Full Name",
                    textEditingController: _nameontroller,
                    textInputType: TextInputType.name),
                16.height(),
                TextFieldWidget(
                    validator: (p0) => Validators.validateEmail(p0),
                    hintText: "Enter Email",
                    textEditingController: _emailController,
                    textInputType: TextInputType.name),
                16.height(),
                PhoneNumberFieldWidget(controller: _phoneController),
                16.height(),
                TextFieldWidget(
                    validator: (p0) => Validators.validateField(p0),
                    minLines: 4,
                    maxLines: 6,
                    hintText: "Additinal notes",
                    textEditingController: _additionalInfoController,
                    textInputType: TextInputType.name),
                16.height(),
                GestureDetector(
                    onTap: () {
                      selectDateSheetWidget(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 18, left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceBackgroundColor,
                          border: Border.all(
                              color: AppColor.surfaceBackgroundBaseDarkColor
                                  .withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: selectedDate != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: AppColor
                                              .surfaceBackgroundBaseDarkColor,
                                        ),
                                        5.width(),
                                        Text('Selected Date:',
                                            style: AppTypography.label18LG),
                                      ],
                                    ),
                                    Text(
                                        DateFormat('MM/dd/yyyy')
                                            .format(selectedDate),
                                        style: AppTypography.label18LG),
                                  ])
                            : Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color:
                                        AppColor.surfaceBackgroundBaseDarkColor,
                                  ),
                                  5.width(),
                                  Text(
                                    "Select Date",
                                    style: AppTypography.label16MD.copyWith(
                                        color: AppColor
                                            .surfaceBackgroundBaseDarkColor
                                            .withOpacity(0.9)),
                                  ),
                                ],
                              ))),
                16.height(),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        selectTimeSheetWidget(context,
                            initialTime: selectedFromTime ?? DateTime.now(),
                            onDateTimeChanged: (value) {
                          ref
                              .read(selectedFromTimeProvider.notifier)
                              .updateDate(value);
                        }, onPressed: () {
                          context.popPage();
                          if (ref.read(selectedToTimeProvider.notifier).state !=
                              null) {
                            if (ref
                                    .read(selectedFromTimeProvider.notifier)
                                    .state !=
                                null) {
                              if (ref
                                  .read(selectedToTimeProvider.notifier)
                                  .state!
                                  .isAfter(ref
                                      .read(selectedFromTimeProvider.notifier)
                                      .state!)) {
                                BaseHelper.showSnackBar(context,
                                    "Time is less the 4 hours of Selected Time");
                                ref
                                    .read(selectedFromTimeProvider.notifier)
                                    .state = null;
                                // ref.read(selectedFromTimeProvider.notifier).updateDate(  selectedFromTime.add(Duration(hours: 4)));
                              }
                            } else {
                              ref
                                  .read(selectedFromTimeProvider.notifier)
                                  .updateDate(DateTime.now());
                            }
                          } else {
                            if (ref
                                    .read(selectedFromTimeProvider.notifier)
                                    .state !=
                                null) {
                              ref
                                  .read(selectedFromTimeProvider.notifier)
                                  .updateDate(selectedFromTime!
                                      .add(const Duration(hours: 4)));
                            } else {
                              ref
                                  .read(selectedFromTimeProvider.notifier)
                                  .updateDate(DateTime.now());
                            }
                          }
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 18, bottom: 18, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceBackgroundColor,
                            border: Border.all(
                                color: AppColor.surfaceBackgroundBaseDarkColor
                                    .withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColor.surfaceBackgroundBaseDarkColor,
                              ),
                              5.width(),
                              selectedFromTime != null
                                  ? Text(
                                      DateFormat("hh:mm aa")
                                          .format(selectedFromTime),
                                      style: AppTypography.label18LG)
                                  : Flexible(
                                      child: FittedBox(
                                        child: Text(
                                          "Select From Time",
                                          style: AppTypography.label18LG.copyWith(
                                              color: AppColor
                                                  .surfaceBackgroundBaseDarkColor
                                                  .withOpacity(0.9)),
                                        ),
                                      ),
                                    ),
                            ],
                          )),
                    )),
                    8.width(),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (ref.read(selectedFromTimeProvider.notifier).state !=
                            null) {
                          selectTimeSheetWidget(context,
                              initialTime: selectedToTime ??
                                  selectedFromTime!
                                      .add(const Duration(hours: 4)),
                              onDateTimeChanged: (value) {
                            ref
                                .read(selectedToTimeProvider.notifier)
                                .updateDate(value);
                          }, onPressed: () {
                            context.popPage();
                            var toTime = ref.read(selectedToTimeProvider);

                            if (ref
                                    .read(selectedToTimeProvider.notifier)
                                    .state !=
                                null) {
                              if (ref
                                  .read(selectedToTimeProvider.notifier)
                                  .state!
                                  .isBefore(ref
                                      .read(selectedFromTimeProvider.notifier)
                                      .state!
                                      .add(const Duration(hours: 4)))) {
                                BaseHelper.showSnackBar(context,
                                    "Time can not be less than 4 hours of the Selected Time");
                                ref
                                    .read(selectedToTimeProvider.notifier)
                                    .state = null;
                              } else if (ref
                                  .read(selectedToTimeProvider.notifier)
                                  .state!
                                  .isAfter(ref
                                      .read(selectedFromTimeProvider.notifier)
                                      .state!
                                      .add(const Duration(hours: 8)))) {
                                BaseHelper.showSnackBar(context,
                                    "Time can not be gretater than 8 hours of the Selected Time");
                                ref
                                    .read(selectedToTimeProvider.notifier)
                                    .state = null;
                              }
                            } else {
                              if (ref
                                      .read(selectedToTimeProvider.notifier)
                                      .state !=
                                  null) {
                                ref
                                    .read(selectedToTimeProvider.notifier)
                                    .updateDate(ref
                                        .read(selectedFromTimeProvider.notifier)
                                        .state!
                                        .add(const Duration(hours: 4)));
                              } else {
                                ref
                                    .read(selectedToTimeProvider.notifier)
                                    .updateDate(DateTime.now()
                                        .add(const Duration(hours: 4)));
                              }
                            }
                          });
                        } else {
                          BaseHelper.showSnackBar(
                              context, "Select From Date First");
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 18, bottom: 18, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceBackgroundColor,
                            border: Border.all(
                                color: AppColor.surfaceBackgroundBaseDarkColor
                                    .withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColor.surfaceBackgroundBaseDarkColor,
                              ),
                              5.width(),
                              selectedToTime != null
                                  ? Text(
                                      DateFormat("hh:mm aa")
                                          .format(selectedToTime),
                                      style: AppTypography.label18LG,
                                    )
                                  : Flexible(
                                      child: FittedBox(
                                        child: Text(
                                          "Select To Time",
                                          style: AppTypography.label18LG.copyWith(
                                              color: AppColor
                                                  .surfaceBackgroundBaseDarkColor
                                                  .withOpacity(0.9)),
                                        ),
                                      ),
                                    ),
                            ],
                          )),
                    )),
                  ],
                ),
                30.height(),
                CustomElevatedButton(
                  onPressed: () async {
                    if (selectedFromTime == null) {
                      BaseHelper.showSnackBar(context, "Select from time");
                    }
                    if (selectedToTime == null) {
                      BaseHelper.showSnackBar(context, "Select to time");
                    }
                    if (selectedDate == null) {
                      BaseHelper.showSnackBar(context, "Select Date");
                    }
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> payload = {
                        "user_email":
                            _emailController.text.trim().toLowerCase(),
                        "username": _nameontroller.text.trimRight().trimLeft(),
                        "user_phone_number": _phoneController.text,
                        "tour_guide_id": widget.id,
                        "date": DateFormat("yyyy-MM-dd").format(selectedDate!),
                        "start_time":
                            DateFormat("H:m:s").format(selectedFromTime!),
                        "end_time": DateFormat("H:m:s").format(selectedToTime!),
                        "book_car": false
                      };
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              'Book Your Car',
                              style: AppTypography.title18LG,
                            ),
                            content: Text(
                              "Click on Get a car button to get details of car",
                              style: AppTypography.paragraph16LG,
                            ),
                            actions: [
                              CupertinoDialogAction(
                                textStyle: AppTypography.label16MD
                                    .copyWith(color: AppColor.redColor),
                                onPressed: () async {
                                  await ref
                                      .read(apiServiceProvider)
                                      .postBookRequest(context,
                                          payload: payload)
                                      .then((value) async {
                                    if (value
                                            ?.toLowerCase()
                                            .contains("booked") ??
                                        false) {
                                      SharedPreferences pre =
                                          await SharedPreferences.getInstance();
                                      pre.setString(
                                        "email",
                                        _emailController.text
                                            .trim()
                                            .toLowerCase(),
                                      );
                                      context.popPage();
                                      confirmBookingSheetWidget(context,
                                          selectedDate: selectedDate,
                                          selectedFromTime: selectedFromTime,
                                          selectedToTime: selectedToTime,
                                          name: _nameontroller.text
                                              .trimRight()
                                              .trimLeft());
                                    } else {
                                      context.popPage();
                                    }
                                  });
                                  // context.popPage();
                                },
                                child: const Text(
                                  'Book Without Car',
                                ),
                              ),
                              CupertinoDialogAction(
                                textStyle: AppTypography.label16MD
                                    .copyWith(color: AppColor.textPrimaryColor),
                                child: const Text(
                                  'Get a car',
                                ),
                                onPressed: () {
                                  // You can handle the submission here

                                  context.navigatepushReplacementNamed(
                                      CarView.routeName,
                                      arguments: payload);
                                },
                              ),
                            ],
                          );
                        },
                      );
//                       await bookCall(payload).then((value) async{
//                         if (value.toLowerCase().contains("booked")) {
//                           SharedPreferences pre=await SharedPreferences.getInstance();
// pre.setString("email",  _emailController.text.trim().toLowerCase(),);
//                           confirmBookingSheetWidget(context,
//                               selectedDate: selectedDate,
//                               selectedFromTime: selectedFromTime,
//                               selectedToTime: selectedToTime,
//                               name: _nameontroller.text.trimRight().trimLeft());
//                         }
//                       });
                    } else {
                      return;
                    }
                  },
                  title: "Book now",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> selectDateSheetWidget(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
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
                  initialDate:
                      ref.watch(selectedDateProvider) ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2050),
                  onDateChanged: (value) {
                    ref.read(selectedDateProvider.notifier).updateDate(value);
                  },
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
                        context.popPage();
                        if (ref.read(selectedDateProvider) == null) {
                          ref
                              .read(selectedDateProvider.notifier)
                              .updateDate(DateTime.now());
                        }
                        // selectTimeSheetWidget(context);
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

  Future<dynamic> selectTimeSheetWidget(BuildContext context,
      {required DateTime initialTime,
      required void Function(DateTime) onDateTimeChanged,
      required void Function() onPressed}) {
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
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
                  initialDateTime: initialTime,
                  // initialEntryMode: TimePickerEntryMode.input,
                  onDateTimeChanged: onDateTimeChanged),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: onPressed,
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

  Future<dynamic> confirmBookingSheetWidget(
    BuildContext context, {
    required DateTime selectedDate,
    required DateTime selectedFromTime,
    required DateTime selectedToTime,
    required String name,
  }) {
    // bookedData.add({
    //   "date":
    //       DateFormat("MMM/dd/yyyy").format(ref.watch(selectedDateProvider)!),
    //   "fromTime":
    //       DateFormat("hh:mm").format(ref.watch(selectedFromTimeProvider)!),
    //   "toTime": DateFormat("hh:mm").format(ref.watch(selectedToTimeProvider)!),
    //   "name": _nameontroller.text
    // });
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
                ConfirmBookRowWidget(
                    title: 'Date',
                    subtitle: DateFormat("MMM/dd/yyyy").format(selectedDate)),
                20.height(),
                ConfirmBookRowWidget(
                    title: "From Time",
                    subtitle: DateFormat("hh:mm a").format(selectedFromTime)),
                20.height(),
                ConfirmBookRowWidget(
                    title: "To Time",
                    subtitle: DateFormat("hh:mm a").format(selectedToTime)),
                20.height(),
                ConfirmBookRowWidget(title: "Name", subtitle: name),
                20.height(),
                //  ConfirmBookRowWidget(
                //   title: "Email",
                //   subtitle: _emailController.text.toString()
                // ),
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
                    // context.navigateToRemovedUntilNamed(BookingView.routeName);
                    context.navigateToRemovedUntilNamed(BookingView.routeName);
                  },
                  title: "Confirm",
                ))
              ]))
        ]);
      },
    );
  }
}
