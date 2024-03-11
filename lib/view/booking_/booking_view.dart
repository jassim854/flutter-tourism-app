import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/network/api_service.dart';
import 'package:flutter_tourism_app/provider/booking_provider.dart';
import 'package:flutter_tourism_app/provider/genearl_providers.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/all_booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/cancelled_booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/completd_booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/confirmed_booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/pending_booking_view.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingView extends ConsumerStatefulWidget {
  static const routeName = "/bookingView";
  const BookingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingViewState();
}

class _BookingViewState extends ConsumerState<BookingView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // callBooking();
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
          // ref.read(userConfirmedBookedListProvider.notifier).addValue(val);
          ref.read(userCompletedListProvider.notifier).addValue(val);
          ref.read(userCancelledBookedListProvider.notifier).addValue(val);
          // ref.read(userPendingBookedListProvider.notifier).addValue(val);
        } else {
          ref.read(isLoadingProvider.notifier).state = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        toolBarHeight: 110,
        title: 'My Bookings',
        bottomBarWidget: AppBar(
          toolbarHeight: 80,
          backgroundColor: AppColor.surfaceBackgroundColor,
          surfaceTintColor: AppColor.surfaceBackgroundColor,
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          titleSpacing: 0,
          elevation: 0,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                      color: AppColor.surfaceBackgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBar(
                      controller: _tabController,
                      labelPadding: const EdgeInsets.symmetric(vertical: 8),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          color: AppColor.surfaceBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      tabs: [
                        Text(
                          "All",
                          style: AppTypography.label14SM
                              .copyWith(color: AppColor.textBlackColor),
                        ),

                        Text(
                          "Completed",
                          style: AppTypography.label14SM
                              .copyWith(color: AppColor.textBlackColor),
                        ),
                        // Text(
                        //   "Confirmed",
                        //   style: AppTypography.label14SM
                        //       .copyWith(color: AppColor.textBlackColor),
                        // ),
                        Row(
                          children: [
                            5.width(),
                            Container(
                              width: 2,
                              height: 20,
                              color: AppColor.surfaceBackgroundBaseDarkColor,
                            ),
                            20.width(),
                            Text(
                              "Cancelled",
                              style: AppTypography.label14SM
                                  .copyWith(color: AppColor.textBlackColor),
                            ),
                          ],
                        )
                      ])),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          4.height(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                AllBookingView(),
                // PendingBookingView(),
                CompletedBookingView(),
                // ConfirmedBookingView(),
                CancelledBookingView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
