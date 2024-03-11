import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final int? maxLines, minLines;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  const TextFieldWidget(
      {super.key,
      required this.hintText,
      this.validator,
      required this.textEditingController,
      required this.textInputType,
      this.maxLines,
      this.minLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        cursorColor: AppColor.surfaceBrandPrimaryColor,
        controller: textEditingController,
        style: AppTypography.paragraph16LG,
        maxLines: maxLines,
        minLines: minLines,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.surfaceBackgroundColor,
          hintText: hintText,
          hintStyle: AppTypography.label18LG.copyWith(
              color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.9)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color:
                    AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color:
                    AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          errorStyle:
              AppTypography.paragraph12SM.copyWith(color: AppColor.redColor),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColor.redColor,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 0.5,
                color:
                    AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
