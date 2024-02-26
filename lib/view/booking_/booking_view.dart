import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/all_booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/cancelled_booking_view.dart';
import 'package:flutter_tourism_app/view/booking_/completd_booking_view.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';

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
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        toolBarHeight: 110,
        title: 'Booings',
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
                    left: 20,
                    right: 20,
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
                        Row(
                          children: [
                            10.width(),
                            Container(
                              width: 2,
                              height: 20,
                              color: AppColor.surfaceBackgroundBaseDarkColor,
                            ),
                            10.width(),
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
                CompletedBookingView(),
                CancelledBookingView()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
