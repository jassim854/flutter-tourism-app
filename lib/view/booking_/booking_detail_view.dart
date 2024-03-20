import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_detail_provider.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/all_booking_view.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:intl/intl.dart';

class BookingDetailView extends ConsumerStatefulWidget {
  final String id;
  static const routeName = "/detailBookingView";
  const BookingDetailView(this.id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailBookingViewState();
}

class _DetailBookingViewState extends ConsumerState<BookingDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
  }

  callApi() async {
    ref.read(isLoadingProvider.notifier).state = true;
    await ref.read(apiServiceProvider).getUserDetailBookedRequest(context,
        payload: {"id": widget.id}).then((value) {
      if (value != null) {
        ref.read(userDetailProvider.notifier).addValue(value);
        ref.read(isLoadingProvider.notifier).state = false;
      }
    });
  }

  int calculateCarAmount(int differenceHour, double amount) {
    return amount.toInt() * differenceHour;
  }

  int getTimeDeifference(
    DateTime startTime,
    DateTime endTime,
  ) {
    TimeOfDay t = TimeOfDay.fromDateTime(startTime);
    TimeOfDay t2 = TimeOfDay.fromDateTime(endTime);
    Duration d = calculateTimeDifference(t, t2);
    return d.inHours;
  }

  Duration calculateTimeDifference(TimeOfDay startTime, TimeOfDay endTime) {
    final now = DateTime.now();
    final start = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final end =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    Duration difference = end.difference(start);
    return difference.isNegative
        ? difference + const Duration(days: 1)
        : difference;
  }

  int caluateTourCost(double amount, int hour) {
    return amount.toInt() * hour;
  }

  @override
  Widget build(BuildContext context) {
    UserBookedModel? data = ref.watch(userDetailProvider);

    int timeDifference = getTimeDeifference(
      data?.booking?.startTime ?? DateTime.now(),
      data?.booking?.endTime ?? DateTime.now(),
    );
    int carAmount = calculateCarAmount(timeDifference, data?.car?.price ?? 0.0);
    int tourAmount =
        caluateTourCost(data?.tourGuide?.price ?? 0, timeDifference);

    return Scaffold(
      appBar: AppBarWidget(
        onTap: () {
          context.maybePopPage();
        },
        titleSpacing: 10,
        leadingWidth: 40,
        title: "Reservation ${data?.booking?.id ?? ""}",
        actions: [
          if (data != null)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: StatusContainer(status: data.booking!.status!),
            )
        ],
      ),
      body: ref.watch(isLoadingProvider) == true || data == null
          ? const Center(
              child: CupertinoActivityIndicator(
              radius: 30,
            ))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  4.height(),
                  ColoredBox(
                    color: AppColor.surfaceBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ConfirmBookRowWidget(
                              title: 'Name', subtitle: data.user!.fullName!),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: 'Email', subtitle: data.user!.email!),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: 'Phone',
                              subtitle: data.user!.phoneNumber!),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: 'Date',
                              subtitle: DateFormat("dd MMM yyyy")
                                  .format(data.booking!.date!)),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: "Tour Start Time",
                              subtitle:
                                  "${DateFormat("h:mm a").format(data.booking!.startTime!)} - ${DateFormat("h:mm a").format(data.booking!.endTime!)}"),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: "Tour Hours",
                              subtitle: "$timeDifference Hours"),
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
                                      imageUrl:
                                          data.tourGuide!.images.toString(),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              15.width(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ambassador",
                                    style: AppTypography.title18LG
                                        .copyWith(fontSize: 15),
                                  ),
                                  // 1.height(),
                                  Text(
                                    data.tourGuide!.name.toString(),
                                    style: AppTypography.paragraph16LG.copyWith(
                                        fontSize: 15,
                                        color: AppColor.textSubTitleColor),
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
                                        data.tourGuide!.countryImg.toString())),
                              ),
                              15.width(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Country",
                                    style: AppTypography.title18LG
                                        .copyWith(fontSize: 15),
                                  ),
                                  // 1.height(),
                                  Text(
                                    data.tourGuide!.location.toString(),
                                    style: AppTypography.paragraph16LG.copyWith(
                                        fontSize: 15,
                                        color: AppColor.textSubTitleColor),
                                  )
                                ],
                              )
                            ],
                          ),
                          15.height(),
                          if (data.car!.carName != null) ...[
                            Text(
                              "Extras",
                              style: AppTypography.paragraph16LG
                                  .copyWith(fontSize: 15),
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
                                        imageUrl:
                                            data.car!.imagePath.toString(),
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
                                          "${data.car!.carName} ",
                                          style: AppTypography.title18LG
                                              .copyWith(fontSize: 15),
                                        ),
                                        Text(
                                          "$timeDifference Hours",
                                          style: AppTypography.paragraph12SM
                                              .copyWith(
                                                  color: AppColor
                                                      .textSubTitleColor),
                                        ),
                                      ],
                                    ),
                                    // 1.height(),
                                    Text(
                                      "${carAmount.formatter}",
                                      style: AppTypography.paragraph16LG
                                          .copyWith(
                                              fontSize: 15,
                                              color:
                                                  AppColor.textSubTitleColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                            PaymentWidget(
                              currency: data.tourGuide!.currency.toString(),
                              tourAmount: tourAmount,
                              carAmount: carAmount,
                            ),
                            8.height(),
                            const Divider(),
                            8.height(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Additional info',
                                  style: AppTypography.paragraph14MD.copyWith(
                                      fontSize: 15,
                                      color: AppColor.textSubTitleColor
                                          .withOpacity(0.60)),
                                ),
                                8.height(),
                                Text(
                                    'Created at: ${DateFormat("dd/MM/yyyy").format(data.booking!.date!)} ${DateFormat("hh:mm a").format(data.booking!.startTime!)} ',
                                    style: AppTypography.paragraph14MD.copyWith(
                                        fontSize: 15,
                                        color: AppColor.textSubTitleColor
                                            .withOpacity(0.60)))
                              ],
                            )
                          ]
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class PaymentWidget extends StatelessWidget {
  PaymentWidget({
    super.key,
    required this.tourAmount,
    required this.carAmount,
    required this.currency,
  }) : totalAmount = carAmount + tourAmount;

  final int tourAmount;
  final int carAmount;
  final String currency;
  int totalAmount;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height(),
        const Divider(),
        8.height(),
        Text(
          "Payment",
          style: AppTypography.title18LG.copyWith(fontSize: 20),
        ),
        12.height(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tour Cost",
              style: AppTypography.title18LG.copyWith(fontSize: 15),
            ),
            Row(
              children: [
                Text(
                  "${tourAmount.formatter} ",
                  style: AppTypography.paragraph14MD.copyWith(fontSize: 15),
                ),
                Text(
                  currency,
                  style: AppTypography.paragraph14MD.copyWith(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
        8.height(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Extra",
              style: AppTypography.title18LG.copyWith(fontSize: 15),
            ),
            Row(
              children: [
                Text(
                  "${carAmount.formatter} ",
                  style: AppTypography.paragraph14MD.copyWith(fontSize: 15),
                ),
                Text(
                  currency,
                  style: AppTypography.paragraph14MD.copyWith(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
        8.height(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: AppTypography.title18LG.copyWith(fontSize: 15),
            ),
            Row(
              children: [
                Text(
                  "${totalAmount.formatter} ",
                  style: AppTypography.paragraph14MD.copyWith(fontSize: 15),
                ),
                Text(
                  currency,
                  style: AppTypography.paragraph14MD.copyWith(fontSize: 15),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  final String text;
  const DescriptionWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.paragraph14MD,
    );
  }
}

class CoverImageWidget extends StatelessWidget {
  final String imageUrl;
  const CoverImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(width: 1, color: AppColor.surfaceBrandPrimaryColor)),
      height: 250,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(width: 4, color: AppColor.surfaceBrandPrimaryColor)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: cacheNetworkWidget(
            context,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
