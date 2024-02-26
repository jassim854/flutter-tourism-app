import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';

class CancelledBookingView extends ConsumerStatefulWidget {
  const CancelledBookingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CancelledBookingViewState();
}

class _CancelledBookingViewState extends ConsumerState<CancelledBookingView> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.surfaceBackgroundColor,
      child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            return Text(
              "Booking 1024",
              style: AppTypography.label16MD,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 10),
    );
  }
}
