import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';
import 'package:intl/intl.dart';

class CompletedBookingView extends ConsumerStatefulWidget {
  const CompletedBookingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompletedBookingViewState();
}

class _CompletedBookingViewState extends ConsumerState<CompletedBookingView> {
  @override
  Widget build(BuildContext context) {
    List<UserBookedModel> data=ref.watch(userConfirmBookedListProvider);
    return  ColoredBox(
      color: AppColor.surfaceBackgroundColor,
      child:ref.watch(isLoadingProvider)==true? CupertinoActivityIndicator(radius: 30,)  :data.isEmpty?Center(child: Text("No Bookings avilable"),) :  ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            return GestureDetector(
                  onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder:(context) => BookingDetailView(data[index].booking!.id.toString()), ));
              },
              child: Text(
                "Booking with ${data[index].tourGuide?.name}",
                style: AppTypography.label16MD,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: data.length),
    );
  }
}