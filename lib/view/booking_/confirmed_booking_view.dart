// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
// import 'package:flutter_tourism_app/provider/booking_provider.dart';
// import 'package:flutter_tourism_app/provider/genearl_providers.dart';
// import 'package:flutter_tourism_app/utils/app_colors.dart';
// import 'package:flutter_tourism_app/utils/app_typography.dart';
// import 'package:flutter_tourism_app/view/booking_/all_booking_view.dart';
// import 'package:flutter_tourism_app/view/booking_/booking_detail_view.dart';
// import 'package:intl/intl.dart';

// class ConfirmedBookingView extends ConsumerStatefulWidget {
//   const ConfirmedBookingView({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ConfirmedBookingViewState();
// }

// class _ConfirmedBookingViewState extends ConsumerState<ConfirmedBookingView> {
//   @override
//   Widget build(BuildContext context) {
//     List<UserBookedModel> data = ref.watch(userConfirmedBookedListProvider);
//     return ColoredBox(
//       color: AppColor.surfaceBackgroundColor,
//       child: ref.watch(isLoadingProvider) == true
//           ? const CupertinoActivityIndicator(
//               radius: 30,
//             )
//           : data.isEmpty
//               ? const Center(
//                   child: Text("No Bookings avilable"),
//                 )
//               : ListView.separated(
//                   padding: const EdgeInsets.all(20),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => BookingDetailView(
//                                 data[index].booking!.id.toString()),
//                           ));
//                         },
//                         child: ShowBookingRowWidget(
//                           imageUrl:
//                               data[index].tourGuide?.images.toString() ?? "",
//                           name: data[index].tourGuide?.name.toString() ?? "",
//                           bookingId: data[index].booking?.id.toString() ?? "",
//                           bookingStatus:
//                               data[index].booking?.status.toString() ?? "",
//                           bookingDate:
//                               data[index].booking?.date ?? DateTime(2000),
//                         ));
//                   },
//                   separatorBuilder: (context, index) {
//                     return const Divider();
//                   },
//                   itemCount: data.length),
//     );
//   }
// }
