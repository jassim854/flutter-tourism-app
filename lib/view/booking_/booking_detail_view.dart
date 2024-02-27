import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/provider/book_provider.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/home_/home_detail_view.dart';
import 'package:flutter_tourism_app/widgets/custom_appbar_widget.dart';

class BookingDetailView extends ConsumerStatefulWidget {
  final int index;
  static const routeName = "/detailBookingView";
  const BookingDetailView(this.index, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailBookingViewState();
}

class _DetailBookingViewState extends ConsumerState<BookingDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
          titleSpacing: 10, leadingWidth: 40, title: "Booking 1024"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            4.height(),
            ColoredBox(
              color: AppColor.surfaceBackgroundColor,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CoverImageWidget(),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: DescriptionWidget(),
                    ),
                     ConfirmBookRowWidget(title: 'Date', subtitle: bookedData[widget.index]['date'].toString()),
                    20.height(),
                     ConfirmBookRowWidget(title: "From Time", subtitle: bookedData[widget.index]['fromTime'].toString()),
                          20.height(),
                     ConfirmBookRowWidget(title: "To Time", subtitle: bookedData[widget.index]['toTime'].toString()),
                    20.height(),
                     ConfirmBookRowWidget(
                      title: "Name",
                      subtitle: bookedData[widget.index]['name'].toString(),
                    ),
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
  const DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
      style: AppTypography.paragraph14MD,
    );
  }
}

class CoverImageWidget extends StatelessWidget {
  const CoverImageWidget({
    super.key,
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
          child: Image.asset(
            AppAssets.onBoardImage1,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
