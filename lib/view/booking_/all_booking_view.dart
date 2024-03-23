import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/provider/home_provider.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllBookingView extends ConsumerStatefulWidget {
  const AllBookingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllBookingViewState();
}

class _AllBookingViewState extends ConsumerState<AllBookingView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callBooking();
    });
  }

  callBooking() async {
 ref.read(isLoadingProvider.notifier).state = true;

      await ref.read(apiServiceProvider).getUserBookedRequest(context,
          payload: {"device_id": ref.read(deviceUDIDProvider)}).then((val) {
        if (val != null) {
          ref.read(userAllBookedListProvider.notifier).addValue(val);
          ref.read(isLoadingProvider.notifier).state = false;

          // ref.read(userConfirmedBookedListProvider.notifier).addValue(val);
          ref.read(userCompletedListProvider.notifier).addValue(val);
          ref.read(userCancelledBookedListProvider.notifier).addValue(val);
          // ref.read(userPendingBookedListProvider.notifier).addValue(val);
        } else {
          ref.read(isLoadingProvider.notifier).state = false;
        }
      });
    
  }

  @override
  Widget build(BuildContext context) {
    List<UserBookedModel> data = ref.watch(userAllBookedListProvider);
    return ColoredBox(
      color: AppColor.surfaceBackgroundColor,
      child: ref.watch(isLoadingProvider) == true
          ? const CupertinoActivityIndicator(
              radius: 30,
            )
          : data.isEmpty
              ? const Center(
                  child: Text("No Bookings avilable"),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BookingDetailView(
                                data[index].booking!.id.toString()),
                          ));
                        },
                        child: ShowBookingRowWidget(
                          imageUrl:
                              data[index].tourGuide?.images.toString() ?? "",
                          name: data[index].tourGuide?.name.toString() ?? "",
                          bookingId: data[index].booking?.id.toString() ?? "",
                          bookingStatus:
                              data[index].booking?.status.toString() ?? "",
                          bookingDate:
                              data[index].booking?.date ?? DateTime(2000),
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: data.length),
    );
  }
}

class ShowBookingRowWidget extends StatelessWidget {
  final String imageUrl, name, bookingId, bookingStatus;
  final DateTime bookingDate;
  const ShowBookingRowWidget(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.bookingId,
      required this.bookingStatus,
      required this.bookingDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: cacheNetworkWidget(context,
                      imageUrl: imageUrl, fit: BoxFit.cover),
                ),
              ),
              15.width(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.title18LG.copyWith(fontSize: 15),
                    ),
                    // 1.height(),
                    Text(
                      "Res. No. $bookingId . ${DateFormat("dd/MM/yyyy").format(bookingDate)}",
                      style: AppTypography.paragraph16LG.copyWith(
                          fontSize: 15,
                          color: AppColor.textSubTitleColor.withOpacity(0.60)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        StatusContainer(status: bookingStatus)
      ],
    );
  }
}

class StatusContainer extends StatelessWidget {
  final String status;
  const StatusContainer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: status.toLowerCase().contains("pending")
              ? const Color(0xffD0B317).withOpacity(0.28)
              : status.toLowerCase().contains("complete")
                  ? const Color(0xff218A36).withOpacity(0.20)
                  : status.toLowerCase().contains("cancelled")
                      ? const Color(0xff929292).withOpacity(0.20)
                      : status.toLowerCase().contains("confirmed")
                          ? const Color(0xff0079B0).withOpacity(0.20)
                          : null,
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        status,
        style: AppTypography.paragraph14MD
            .copyWith(fontSize: 12, color: AppColor.surfaceBrandDarkColor),
      ),
    );
  }
}
