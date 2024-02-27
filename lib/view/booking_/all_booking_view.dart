import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';

class AllBookingView extends ConsumerStatefulWidget {
  const AllBookingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllBookingViewState();
}

class _AllBookingViewState extends ConsumerState<AllBookingView> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.surfaceBackgroundColor,
      child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder:(context) => BookingDetailView(index), ));
              },
              child: Text(
                "Booking 1024",
                style: AppTypography.label16MD,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: bookedData.length),
    );
  }
}
