import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';


class CustomElevatedButton extends StatelessWidget {
  final String? title;
  final void Function()? onPressed;
  final Color? btnColor,textColor;
  final Widget? child;
  final double? radius, elevation;
  final EdgeInsetsGeometry? childPadding;
  const CustomElevatedButton(
      {super.key,
      required this.onPressed,
       this.child,
      this.btnColor,
      this.elevation,
      this.radius,
      this.textColor,
      this.childPadding,  this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: btnColor ?? AppColor.buttonPrimaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 16))),
      child:child?? Text(title.toString(),style: AppTypography.label18LG.copyWith(color: textColor),)
    );
  }
}