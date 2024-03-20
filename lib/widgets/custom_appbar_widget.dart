import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tourism_app/helper/basehelper.dart';
import 'package:flutter_tourism_app/utils/app_assets.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_routes.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/view/select_country_view.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// class BottomAppBarSearchWidget extends StatelessWidget
//   implements PreferredSizeWidget {
// final TextEditingController textEditingController;

// BottomAppBarSearchWidget({super.key, required this.textEditingController});

// @override
// Widget build(BuildContext context) {
//   return
// }

// @override
// // TODO: implement preferredSize
// Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// Timer? timer;
// void delayedFunction({
//   required VoidCallback fn,
// }) async {
//   if (timer != null) {
//     timer!.cancel();
//   }

//   timer = Timer(const Duration(milliseconds: 750), fn);
// }

// iconFilterWidget(BuildContext context) {
//   return InkWell(
//     onTap: () async {
//       context.hideKeypad();
//     },
//     child: Container(
//       margin: const EdgeInsets.only(right: 20),
//       padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
//       // decoration: BoxDecoration(
//       //     color: confirmedFilter.value.isEmpty
//       //         ? null
//       //         : AppColor.textEmphasisColor,
//       //     borderRadius: BorderRadius.circular(12)),
//       child: SvgPicture.asset(
//         AppAssets.homeIcon,
//         // color: confirmedFilter.value.isEmpty
//         //     ? AppColor.textEmphasisColor
//         //     : AppColor.textInvertEmphasis
//       ),
//     ),
//   );
// }
// }

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottomBarWidget;
  final List<Widget>? actions;
  final double toolBarHeight;
  final String? title;
  final bool? centerTitle;
  final double? leadingWidth, titleSpacing;
  final Widget? titleWidget;

  final void Function()? onTap;
  const AppBarWidget(
      {super.key,
      this.bottomBarWidget,
      this.title,
      this.centerTitle,
      this.toolBarHeight = 90,
      this.leadingWidth,
      this.onTap,
      this.titleSpacing,
      this.actions,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        surfaceTintColor: AppColor.surfaceBackgroundColor,
        titleSpacing: titleSpacing ?? 0,
        leadingWidth: leadingWidth ?? 40,
        toolbarHeight: toolBarHeight,
        leading: onTap != null
            ? GestureDetector(
                onTap: onTap,
                child: Transform.scale(
                  scale: 1.2,
                  child: SvgPicture.asset(
                    AppAssets.backArrowIcon,
                    color: AppColor.surfaceBrandDarkColor,
                  ),
                ),
              )
            : SizedBox.shrink(),
        backgroundColor: AppColor.surfaceBackgroundColor,
        elevation: 0.0,
        actions: actions,
        title: titleWidget ??
            Text(
              title.toString(),
              style: AppTypography.title24XL.copyWith(
                  fontWeight: FontWeight.w400, color: AppColor.textBlackColor),
            ),
        centerTitle: centerTitle ?? false,
        bottom: bottomBarWidget);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(bottomBarWidget == null ? kToolbarHeight : toolBarHeight);
}

class SliverAppBarWidget extends StatelessWidget {
  final bool value;

  final String backGroundImg;

  SliverAppBarWidget({
    super.key,
    required this.value,
    required this.backGroundImg,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        // floating: false,
        expandedHeight: 450,
        pinned: true,
        stretch: true,
        leadingWidth: 0,
        leading: SizedBox.shrink(),
        title: GestureDetector(
          onTap: () {
            context.maybePopPage();
          },
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(2),
              child: Row(
                children: [
                  Icon(
                    Icons.keyboard_arrow_left,
                    color: AppColor.surfaceBackgroundColor,
                    size: 40,
                  ),
                  6.width(),
                  Text(
                    "Back",
                    style: AppTypography.paragraph18XL.copyWith(
                        fontSize: 24, color: AppColor.surfaceBackgroundColor),
                  )
                ],
              )),
        ),
        flexibleSpace: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: cacheNetworkWidget(
            context,
            imageUrl: backGroundImg,
            fit: BoxFit.cover,
          ),
        ));
  }
}
