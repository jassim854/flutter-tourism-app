import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value = preferences.getString("email");
    if (value != null) {
      ref.read(isLoadingProvider.notifier).state = true;

      await ref.read(apiServiceProvider).getUserBookedRequest(context,
          payload: {"user_email": value}).then((val) {
        if (val != null) {
          ref.read(userAllBookedListProvider.notifier).addValue(val);
          ref.read(isLoadingProvider.notifier).state = false;

ref.read(userConfirmBookedListProvider.notifier).addValue(val);
ref.read(userCancelledBookedListProvider.notifier).addValue(val);
ref.read(userPendingBookedListProvider.notifier).addValue(val);
        } else {
          ref.read(isLoadingProvider.notifier).state = false;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    List<UserBookedModel> data=ref.watch(userAllBookedListProvider);
    return ColoredBox(
      color: AppColor.surfaceBackgroundColor,
      child: ref.watch(isLoadingProvider)==true? CupertinoActivityIndicator(radius: 30,) :data.isEmpty?Center(child: Text("No Bookings avilable"),) :ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (_, index) {
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
