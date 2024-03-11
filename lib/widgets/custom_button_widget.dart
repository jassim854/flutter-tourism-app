import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? title;
  final void Function()? onPressed;
  final Color? btnColor, textColor;
  final Widget? child;
  final double? radius, elevation;
  final EdgeInsetsGeometry? childPadding;
  final TextStyle? style;
  const CustomElevatedButton(
      {super.key,
      required this.onPressed,
      this.child,
      this.btnColor,
      this.elevation,
      this.radius,
      this.textColor,
      this.childPadding,
      this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        // alignment: Alignment.centerLeft,

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: btnColor ?? AppColor.buttonPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 16),
            )),
        child: Padding(
          padding: childPadding ?? EdgeInsets.symmetric(horizontal: 32),
          child: child ??
              Text(
                title.toString(),
                style: style?? AppTypography.label14SM
                    .copyWith(color: textColor ?? AppColor.buttonLabelColor),
              ),
        ));
  }
}
