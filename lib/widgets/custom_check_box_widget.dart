import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    this.width = 24.0,
    this.height = 24.0,
    this.color,
    this.iconSize,
    this.onChanged,
    this.checkColor,
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;
  // Now you can set the checkmark size of your own
  final double? iconSize;
  final Color? checkColor;
  final Function(bool?)? onChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isChecked = !isChecked);
        widget.onChanged?.call(isChecked);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: isChecked ? AppColor.surfaceBrandDarkColor : null,
          border: Border.all(
            color: widget.color ?? Colors.grey.shade500,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                size: widget.iconSize,
                color: AppColor.surfaceBackgroundColor,
              )
            : null,
      ),
    );
  }
}
