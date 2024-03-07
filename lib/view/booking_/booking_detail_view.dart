import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/model/network_model/user_detail_booking_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/car_view.dart';
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

  @override
  Widget build(BuildContext context) {
    UserBookedModel? data = ref.watch(userDetailProvider);
    //   Map<String,dynamic> j={};
    // var a=  j.isNotEmpty?1:2;
    return Scaffold(
      appBar: AppBarWidget(
          onTap: () {
            context.maybePopPage();
          },
          titleSpacing: 10,
          leadingWidth: 40,
          title: "Booking with ${data?.tourGuide?.name}"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            4.height(),
            ref.watch(isLoadingProvider) == true || data == null
                ? const Center(
                    child: CupertinoActivityIndicator(
                    radius: 30,
                  ))
                : ColoredBox(
                    color: AppColor.surfaceBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CoverImageWidget(
                            imageUrl: data?.tourGuide?.images ?? "",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: DescriptionWidget(
                              text: data?.tourGuide?.description ?? "",
                            ),
                          ),
                          ConfirmBookRowWidget(
                              title: 'Date',
                              subtitle: DateFormat("yyyy/MM/dd").format(
                                  data?.booking?.date ?? DateTime.now())),
                          20.height(),
                          ConfirmBookRowWidget(
                            title: "From Time",
                            subtitle: DateFormat("h:m a").format(
                                DateFormat("H:m:s")
                                    .parse(data?.booking?.startTime ?? "")),
                          ),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: "To Time",
                              subtitle: DateFormat("h:m a").format(
                                  DateFormat("H:m:s")
                                      .parse(data?.booking?.endTime ?? ""))),
                          20.height(),
                          ConfirmBookRowWidget(
                              title: "Name",
                              subtitle: data.user?.fullName ?? ""),
                          if (data.car?.carName != null) ...[
                            Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Text(
                                "Booked Car",
                                style: AppTypography.title18LG,
                              ),
                            ),
                            Card(
                              color: AppColor.surfaceBackgroundColor,
                              surfaceTintColor: AppColor.surfaceBackgroundColor,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: AppColor
                                                .surfaceBackgroundBaseDarkColor,
                                            border: Border.all(
                                                width: 0.1,
                                                color: AppColor
                                                    .surfaceBrandPrimaryColor),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        height: 200,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: cacheNetworkWidget(context,
                                                imageUrl: data.car!.imagePath
                                                    .toString(),
                                                fit: BoxFit.cover)),
                                      ),
                                      8.height(),

                                      // const RattingWiget(),
                                      // 8.height(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.car!.carName.toString(),
                                                style: AppTypography.label18LG,
                                              ),
                                              8.height(),
                                              Row(
                                                children: [
                                                  Text(
                                                    data.car!.currency
                                                        .toString(),
                                                    style: AppTypography
                                                        .label14SM
                                                        .copyWith(
                                                            color: AppColor
                                                                .textBrandSecondaryColor),
                                                  ),
                                                  8.width(),
                                                  // const Icon(Icons.location_on_outlined),
                                                  // 8.width(),
                                                  Text(
                                                    "${data.car!.price}",
                                                    style: AppTypography
                                                        .paragraph16LG,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
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
