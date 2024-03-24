import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/firebase_services.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/model/network_model/a_tour_guide_model.dart';
import 'package:flutter_tourism_app/model/network_model/car_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/car_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_detail_provider.dart';
import 'package:flutter_tourism_app/provider/home_provider.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/utils/validators.dart';
import 'package:flutter_tourism_app/view/app_bottom_navigation_bar.dart';
import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';
import 'package:flutter_tourism_app/view/booking_/booking_view.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_button_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_check_box_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';
import 'package:flutter_tourism_app/widgets/expand_collapse_animation_widget.dart';
import 'package:flutter_tourism_app/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SelectedDateSheetWidget extends ConsumerStatefulWidget {
  const SelectedDateSheetWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectedDateSheetWidgetState();
}

class _SelectedDateSheetWidgetState
    extends ConsumerState<SelectedDateSheetWidget> {
  late TextEditingController _nameontroller;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _additionalInfoController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(selectedDateProvider.notifier).updateDate(null);
      ref.read(selectedFromTimeProvider.notifier).updateDate(null);
      ref.read(selectedToTimeProvider.notifier).state = 0;
    });
    _additionalInfoController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nameontroller = TextEditingController();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Scaffold(
          backgroundColor: AppColor.surfaceBackgroundBaseColor,
          body: Column(
            children: [
              40.height(),
              const SvgPicture(SvgAssetLoader(AppAssets.selectDateIcon)),
              30.height(),
              Text(
                "Select Date",
                style: AppTypography.title28_2XL
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 32),
              ),
              const Spacer(),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: AppColor.surfaceBackgroundColor,
                surfaceTintColor: AppColor.surfaceBackgroundColor,
                child: Theme(
                  data: ThemeData().copyWith(
                    colorScheme: ColorScheme.light(
                        primary: AppColor.buttonSecondaryColor),
                  ),
                  child: CalendarDatePicker(
                    initialDate: DateTime.now(),
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
                padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        return CustomElevatedButton(
                          radius: 12,
                          onPressed: () async {
                            if (ref.read(selectedDateProvider) == null) {
                              ref
                                  .read(selectedDateProvider.notifier)
                                  .updateDate(DateTime.now());
                            }
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
                                      child: SelectedTimeSheetWidget(
                                          _nameontroller,
                                          _emailController,
                                          _phoneController,
                                          _additionalInfoController));
                                });
                          },
                          title: 'Continue',
                          style: AppTypography.title18LG.copyWith(
                              fontSize: 17,
                              color: AppColor.surfaceBackgroundColor),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        btnColor: AppColor.buttonDisableColor,
                        radius: 12,
                        onPressed: () {
                          context.popPage();
                          ref.read(selectedDateProvider.notifier).state = null;
                        },
                        title: 'Back',
                        style: AppTypography.title18LG.copyWith(
                            fontSize: 17,
                            color: AppColor.surfaceBackgroundColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class SelectedTimeSheetWidget extends ConsumerWidget {
  final TextEditingController _nameontroller,
      _emailController,
      _phoneController,
      _additionalInfoController;
  const SelectedTimeSheetWidget(this._nameontroller, this._emailController,
      this._phoneController, this._additionalInfoController,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    final aTourGuideData = ref.read(aTourGuideProvider);

    final currentDate = DateTime.now();
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Scaffold(
          backgroundColor: AppColor.surfaceBackgroundBaseColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              40.height(),
              const SvgPicture(SvgAssetLoader(AppAssets.selectTimeIcon)),
              30.height(),
              Text(
                "Select time",
                style: AppTypography.title28_2XL
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 32),
              ),
              // const Spacer(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                       
                        child: Stack(
               
                          children: [
                            CupertinoDatePicker(
                                // minuteInterval: 30,
                                mode: CupertinoDatePickerMode.time,
                                minuteInterval: 30,
                                initialDateTime: currentDate.add(Duration(
                                    minutes: 30 - currentDate.minute % 30)),
                                // initialEntryMode: TimePickerEntryMode.input,
                                onDateTimeChanged: (value) {
                                  ref
                                      .read(selectedFromTimeProvider.notifier)
                                      .updateDate(value);
                                }),
                    
                          ],
                        ),
                      ),
                      30.height(),
                      Text(
                        "Tour Hours",
                        style: AppTypography.title28_2XL.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 32),
                      ),
                      30.height(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              5,
                              (index) => InkWell(
                                    onTap: () {
                                      ref
                                          .read(selectedToTimeProvider.notifier)
                                          .state = index;
                                    },
                                    child: Container(
                                      // width: 70,
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          right: context.dynamicWidth * 0.008,
                                          left: context.dynamicWidth * 0.008,
                                          bottom: 20),
                                      margin: EdgeInsets.only(
                                          left: index == 0
                                              ? context.dynamicWidth * 0.02
                                              : 0,
                                          right: context.dynamicWidth * 0.02),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: ref.watch(
                                                      selectedToTimeProvider) ==
                                                  index
                                              ? AppColor.surfaceBrandDarkColor
                                              : AppColor
                                                  .surfaceBackgroundSecondaryColor),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${4 + index}",
                                            style: AppTypography.paragraph12SM
                                                .copyWith(
                                                    fontSize: 23,
                                                    color: ref.watch(
                                                                selectedToTimeProvider) ==
                                                            index
                                                        ? AppColor
                                                            .textWhiteColor
                                                        : AppColor
                                                            .textLightGreyeColor),
                                          ),
                                          SizedBox(
                                            width: context.dynamicWidth * 0.16,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${aTourGuideData!.currency!} ",
                                                    textAlign: TextAlign.center,
                                                    style: AppTypography
                                                        .paragraph12SM
                                                        .copyWith(
                                                            color: ref.watch(
                                                                        selectedToTimeProvider) ==
                                                                    index
                                                                ? AppColor
                                                                    .textWhiteColor
                                                                : AppColor
                                                                    .textLightGreyeColor),
                                                  ),
                                                  Text(
                                                    "${(double.parse(aTourGuideData.price!).toInt() * (4 + index)).formatter}",
                                                    textAlign: TextAlign.center,
                                                    style: AppTypography
                                                        .paragraph12SM
                                                        .copyWith(
                                                            color: ref.watch(
                                                                        selectedToTimeProvider) ==
                                                                    index
                                                                ? AppColor
                                                                    .textWhiteColor
                                                                : AppColor
                                                                    .textLightGreyeColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))),

                                  
                              
                      // const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0, left: 20, right: 20, top: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                radius: 12,
                                onPressed: () async {
                                  if (ref.read(selectedFromTimeProvider) ==
                                      null) {
                                    ref
                                        .read(selectedFromTimeProvider.notifier)
                                        .updateDate(DateTime.now().add(Duration(
                                            minutes:
                                                30 - currentDate.minute % 30)));
                                  }
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
                                            child: CompleteBookingSheetWidget(
                                                _nameontroller,
                                                _emailController,
                                                _phoneController,
                                                _additionalInfoController));
                                      });
                                },
                                title: 'Continue',
                                style: AppTypography.title18LG.copyWith(
                                    fontSize: 17,
                                    color: AppColor.surfaceBackgroundColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                btnColor: AppColor.buttonDisableColor,
                                radius: 12,
                                onPressed: () async {
                                  context.popPage();
                                  ref
                                      .read(selectedFromTimeProvider.notifier)
                                      .state = null;
                                  ref
                                      .read(selectedToTimeProvider.notifier)
                                      .state = 0;
                                },
                                title: 'Back',
                                style: AppTypography.title18LG.copyWith(
                                    fontSize: 17,
                                    color: AppColor.surfaceBackgroundColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class CompleteBookingSheetWidget extends ConsumerStatefulWidget {
  final TextEditingController _nameontroller,
      _emailController,
      _phoneController,
      _additionalInfoController;
  const CompleteBookingSheetWidget(this._nameontroller, this._emailController,
      this._phoneController, this._additionalInfoController,
      {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompleteBookingSheetWidgetState();
}

class _CompleteBookingSheetWidgetState
    extends ConsumerState<CompleteBookingSheetWidget> {
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
    // TODO: implement initState
    super.initState();
  }

  callApi() async {
    ref.read(isLoadingProvider.notifier).state = true;
    await ref.read(apiServiceProvider).getCarListdRequest(context, payload: {
      "country": ref.read(selectedCountryProvider)?.countryName
    }).then((value) {
      if (value != null) {
        ref.read(carListDataProvider.notifier).addValue(value);
        ref.read(isLoadingProvider.notifier).state = false;
      } else {
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CarModel>? carData = ref.watch(carListDataProvider);
    // bool isPhoneNo = ref.watch(isPhoneNoProvider);
    CarModel? selectedCar = ref.watch(selectedCarProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Scaffold(
        backgroundColor: AppColor.surfaceBackgroundBaseColor,
        body: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            40.height(),
            const SvgPicture(SvgAssetLoader(AppAssets.completeBookIcon)),
            30.height(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Complete Reservation",
                  style: AppTypography.title28_2XL
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 34),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                        validator: (p0) => Validators.validateField(p0),
                        hintText: "Enter Full Name",
                        textEditingController: widget._nameontroller,
                        textInputType: TextInputType.name),
                    16.height(),
                    TextFieldWidget(
                        validator: (p0) => Validators.validateEmail(p0),
                        hintText: "Enter Email",
                        textEditingController: widget._emailController,
                        textInputType: TextInputType.name),
                    16.height(),
                    PhoneNumberFieldWidget(
                      controller: widget._phoneController,
                    ),
                    16.height(),
                    TextFieldWidget(
                        minLines: 4,
                        maxLines: 6,
                        hintText: "Additinal notes",
                        textEditingController: widget._additionalInfoController,
                        textInputType: TextInputType.name),
                  ],
                ),
              ),
            ),
if(carData?.isNotEmpty??false)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                children: [
                  CustomCheckbox(
                    iconSize: 15,
                    height: 22,
                    width: 20,
                    checkColor: AppColor.surfaceBrandDarkColor,
                    onChanged: (p0) {
                      ref.read(isBookCarProvider.notifier).state = p0!;
                      if (p0 == false) {
                        ref.read(selectedCarProvider.notifier).state = null;
                      }
                    },
                  ),
                  8.width(),
                  Text(
                    "Include Transport",
                    style: AppTypography.paragraph14MD,
                  )
                ],
              ),
            ),
            15.height(),
            ExpandedSection(
              expand: ref.watch(isBookCarProvider),
              child: ref.watch(isLoadingProvider)
                  ? const CupertinoActivityIndicator()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: carData?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding:
                              const EdgeInsets.only(left: 6, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1.5,
                                color: selectedCar?.carName ==
                                        carData![index].carName
                                    ? AppColor.surfaceBrandDarkColor
                                    : Colors.transparent,
                              )),
                          child: InkWell(
                            onTap: () {
                              ref.read(selectedCarProvider.notifier).state =
                                  carData[index];
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1.2,
                                          color:
                                              AppColor.surfaceBackgroundColor)),
                                  height: 28,
                                  width: 42,
                                  child: cacheNetworkWidget(
                                    context,
                                    imageUrl: carData[index].imagePath.trim(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                25.width(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      carData[index].carName,
                                      style: AppTypography.title18LG.copyWith(
                                          fontSize: 15,
                                          color: AppColor.textBlackColor),
                                    ),
                                    Text(
                                      "${carData[index].price} ${carData[index].currency} / Hour",
                                      style: AppTypography.paragraph14MD
                                          .copyWith(
                                              fontSize: 15,
                                              color:
                                                  AppColor.textLightGreyeColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      radius: 12,
                      onPressed: () async {
                        if (widget._phoneController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            content: Container(
                              alignment: Alignment.bottomCenter,
                              // color: Colors.red,
                              height: 60,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColor.redColor)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_outlined,
                                          color: AppColor.redColor,
                                        ),
                                        8.width(),
                                        Text(
                                          "Enter your phone number",
                                          style: AppTypography.paragraph12SM
                                              .copyWith(
                                                  color: AppColor.redColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 18,
                                    top: -4,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: AppColor.redColor,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.close,
                                          color:
                                              AppColor.surfaceBackgroundColor,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            margin: const EdgeInsets.all(5),
                            duration: const Duration(seconds: 4),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ));
                          return;
                        }
                        if (ref.watch(isBookCarProvider) == true &&
                            selectedCar == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            content: Container(
                              alignment: Alignment.bottomCenter,
                              // color: Colors.red,
                              height: 60,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColor.redColor)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_outlined,
                                          color: AppColor.redColor,
                                        ),
                                        8.width(),
                                        Text(
                                          "Select a car",
                                          style: AppTypography.paragraph12SM
                                              .copyWith(
                                                  color: AppColor.redColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 18,
                                    top: -4,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: AppColor.redColor,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.close,
                                          color:
                                              AppColor.surfaceBackgroundColor,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            margin: const EdgeInsets.all(5),
                            duration: const Duration(seconds: 4),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ));
                          return;
                        }
                        if (formKey.currentState!.validate()) {
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
                                    child: ConfirmBooingSheetWidget(
                                      name: widget._nameontroller.text
                                          .trimLeft()
                                          .trimRight(),
                                      email:
                                          widget._emailController.text.trim(),
                                      phoneNo: widget._phoneController.text,
                                      additionalNoes:
                                          widget._additionalInfoController.text,
                                    ));
                              });
                        }
                        return;
                      },
                      title: 'Confirm Reservation',
                      style: AppTypography.title18LG.copyWith(
                          fontSize: 17, color: AppColor.surfaceBackgroundColor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      btnColor: AppColor.buttonDisableColor,
                      radius: 12,
                      onPressed: () async {
                        context.popPage();
                      },
                      title: 'Back',
                      style: AppTypography.title18LG.copyWith(
                          fontSize: 17, color: AppColor.surfaceBackgroundColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmBooingSheetWidget extends ConsumerStatefulWidget {
  final String name, email, phoneNo, additionalNoes;

  const ConfirmBooingSheetWidget(
      {required this.name,
      required this.email,
      required this.phoneNo,
      required this.additionalNoes,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmBooingSheetWidgetState();
}

class _ConfirmBooingSheetWidgetState
    extends ConsumerState<ConfirmBooingSheetWidget> {
  int calculateTotalAmount(String perHourRate, int bookHours) {
    var myInt = double.parse(perHourRate);

    int totalAmount = bookHours * myInt.toInt();

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    DateTime? selectedDate = ref.watch(selectedDateProvider);
    DateTime? selectFromTime = ref.watch(selectedFromTimeProvider);
    int? bookingHours = ref.watch(selectedToTimeProvider);
    ATourGuideModel? tourGuideData = ref.watch(aTourGuideProvider);
    bool isCarBooked = ref.watch(isBookCarProvider);
    CarModel? selectedCarData = ref.watch(selectedCarProvider);
    final aTourGuideData = ref.read(aTourGuideProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Scaffold(
          body: ListView(children: [
        40.height(),
        const SvgPicture(SvgAssetLoader(AppAssets.confirmBookIcon)),
        30.height(),
        Center(
          child: Text(
            "Confirm Reservation",
            style: AppTypography.title28_2XL
                .copyWith(fontWeight: FontWeight.w400, fontSize: 32),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConfirmBookRowWidget(title: 'Name', subtitle: widget.name),
              20.height(),
              ConfirmBookRowWidget(title: 'Email', subtitle: widget.email),
              20.height(),
              ConfirmBookRowWidget(title: 'Phone', subtitle: widget.phoneNo),
              20.height(),
              ConfirmBookRowWidget(
                  title: 'Date',
                  subtitle: DateFormat("dd MMM yyyy").format(selectedDate!)),
              20.height(),
              ConfirmBookRowWidget(
                  title: "Tour Start Time",
                  subtitle:
                      "${DateFormat("h:mm a").format(selectFromTime!)} - ${DateFormat("h:mm a").format(selectFromTime.add(Duration(hours: 4 + bookingHours!)))}"),
              20.height(),
              ConfirmBookRowWidget(
                  title: "Tour Hours", subtitle: "${4 + bookingHours} Hours"),
              15.height(),
              const Divider(),
              15.height(),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: cacheNetworkWidget(context,
                          imageUrl: tourGuideData!.images.toString(),
                          fit: BoxFit.cover),
                    ),
                  ),
                  15.width(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ambassador",
                        style: AppTypography.title18LG.copyWith(fontSize: 15),
                      ),
                      // 1.height(),
                      Text(
                        tourGuideData.name.toString(),
                        style: AppTypography.paragraph16LG.copyWith(
                            fontSize: 15, color: AppColor.textSubTitleColor),
                      )
                    ],
                  )
                ],
              ),
              15.height(),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SvgPicture.network(
                            selectedCountry!.countryFlagUrl.toString())),
                  ),
                  15.width(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Country",
                        style: AppTypography.title18LG.copyWith(fontSize: 15),
                      ),
                      // 1.height(),
                      Text(
                        tourGuideData.location.toString(),
                        style: AppTypography.paragraph16LG.copyWith(
                            fontSize: 15, color: AppColor.textSubTitleColor),
                      )
                    ],
                  )
                ],
              ),
              15.height(),
              if (selectedCarData != null) ...[
                Text(
                  "Extras",
                  style: AppTypography.paragraph16LG.copyWith(fontSize: 15),
                ),
                15.height(),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: cacheNetworkWidget(context,
                            imageUrl: selectedCarData!.imagePath.toString(),
                            fit: BoxFit.contain),
                      ),
                    ),
                    15.width(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${selectedCarData.carName} ",
                              style: AppTypography.title18LG
                                  .copyWith(fontSize: 15),
                            ),
                            Text(
                              "${4 + bookingHours} Hours",
                              style: AppTypography.paragraph12SM
                                  .copyWith(color: AppColor.textSubTitleColor),
                            ),
                          ],
                        ),
                        // 1.height(),
                        Text(
                          "${calculateTotalAmount(selectedCarData.price, 4 + bookingHours).formatter} ${selectedCarData.currency}",
                          style: AppTypography.paragraph16LG.copyWith(
                              fontSize: 15, color: AppColor.textSubTitleColor),
                        )
                      ],
                    )
                  ],
                ),
              ],
              PaymentWidget(
                currency: aTourGuideData!.currency.toString(),
                tourAmount: double.parse(aTourGuideData.price!).toInt() *
                    (4 + bookingHours),
                carAmount: selectedCarData!=null?calculateTotalAmount(
                    selectedCarData!.price, 4 + bookingHours):null 
              )
            ],
          ),
        ),
        20.height(),
        ref.watch(isLoadingProvider)
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        radius: 12,
                        onPressed: () async {
                       
                          String? deviceToken = ref.read(deviceTokenProvider);
                          ref.read(isLoadingProvider.notifier).state = true;
                          String crrentDate= DateTime.now().toIso8601String();
                          Map<String, dynamic> payload = {
                            "user_email": widget.email,
                            "username": widget.name,
                            "user_phone_number": widget.phoneNo,
                            "tour_guide_id": tourGuideData.id,
                            "date":
                                DateFormat("yyyy-MM-dd").format(selectedDate),
                            "start_time":
                                DateFormat("HH:mm:ss").format(selectFromTime),
                            "end_time": DateFormat("HH:mm:ss").format(
                                selectFromTime
                                    .add(Duration(hours: 4 + bookingHours))),
                            "book_car":
                                isCarBooked.toString().capitalizeFirst(),
                            if (selectedCarData != null)
                              "car_id": selectedCarData.id,
                            "notes": widget.additionalNoes,
                            if (deviceToken != null) "fcm_token": deviceToken,
                            "user_date":crrentDate,
                            "device_id":ref.read(deviceUDIDProvider)
                          };
                          await ref
                              .read(apiServiceProvider)
                              .postBookRequest(context, payload: payload)
                              .then((value) async {
                            ref.read(isLoadingProvider.notifier).state = false;
                            if (value?.toLowerCase().contains("booked") ??
                                false) {
                              SharedPreferences pre =
                                  await SharedPreferences.getInstance();
                              pre.setString("email", widget.email);
                              if (context.mounted) {
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
                                      return const PopScope(
                                          canPop: false,
                                          child:
                                              RequestSubmissionSheetWidget());
                                    });
                              }
                            } else {
                              ref.read(isLoadingProvider.notifier).state =
                                  false;
                              context.multiPopPage(popPageCount: 3);
                            }
                          });
                        },
                        title: 'Reserve Now',
                        style: AppTypography.title18LG.copyWith(
                            fontSize: 17,
                            color: AppColor.surfaceBackgroundColor),
                      ),
                    ),
                  ],
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  btnColor: AppColor.buttonDisableColor,
                  radius: 12,
                  onPressed: () async {
                    context.popPage();
                  },
                  title: 'Back',
                  style: AppTypography.title18LG.copyWith(
                      fontSize: 17, color: AppColor.surfaceBackgroundColor),
                ),
              ),
            ],
          ),
        )
      ])),
    );
  }
}

class RequestSubmissionSheetWidget extends ConsumerStatefulWidget {
  const RequestSubmissionSheetWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequestSubmissionSheetWidgetState();
}

class _RequestSubmissionSheetWidgetState
    extends ConsumerState<RequestSubmissionSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Scaffold(
          body: Column(children: [
        40.height(),
        const SvgPicture(SvgAssetLoader(AppAssets.confirmBookIcon)),
        30.height(),
        Center(
          child: Text(
            "Request Submitted",
            style: AppTypography.title28_2XL
                .copyWith(fontWeight: FontWeight.w400, fontSize: 32),
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 10),
            child: Text(
              "Thank you for submitting your request. we will get back to you shortly to confirm your booking.",
              style: AppTypography.paragraph16LG,
              textAlign: TextAlign.center,
            )),
        const Spacer(),
        ref.watch(isLoadingProvider)
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        radius: 12,
                        onPressed: () async {
                          ref.read(isLoadingProvider.notifier).state = true;
                     
                         
                        try {
                              await ref
                                .read(apiServiceProvider)
                                .getUserBookedRequest(context,
                                    payload: {"device_id":ref.read(deviceUDIDProvider) }).then((val) {
                              if (val != null) {
                                ref
                                    .read(userAllBookedListProvider.notifier)
                                    .addValue(val);

                                ref
                                    .read(userCompletedListProvider.notifier)
                                    .addValue(val);
                                ref
                                    .read(userCancelledBookedListProvider
                                        .notifier)
                                    .addValue(val);
                                ref.read(isLoadingProvider.notifier).state =
                                    false;
                                context.multiPopPage(popPageCount: 5);

                                controller.jumpToTab(1);
                           
                            }});
                        } catch (e) {
                              ref.read(isLoadingProvider.notifier).state = false;
                        }
                        
                          
                        },
                        title: 'View Reservation',
                        style: AppTypography.title18LG.copyWith(
                            fontSize: 17,
                            color: AppColor.surfaceBackgroundColor),
                      ),
                    ),
                  ],
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  btnColor: AppColor.buttonDisableColor,
                  radius: 12,
                  onPressed: () async {
                    context.multiPopPage(popPageCount: 5);
                  },
                  title: 'Close',
                  style: AppTypography.title18LG.copyWith(
                      fontSize: 17, color: AppColor.surfaceBackgroundColor),
                ),
              ),
            ],
          ),
        )
      ])),
    );
  }
}
