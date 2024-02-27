

import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final int? maxLines,minLines;
 final  String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  const TextFieldWidget({super.key,required this.hintText, this.validator,  required this.textEditingController, required this.textInputType,  this.maxLines,  this.minLines});

  @override
  Widget build(BuildContext context) {
    return      Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: textEditingController,
        style: AppTypography.paragraph16LG,
        maxLines: maxLines,
        minLines: minLines,
        validator:validator ,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(

          hintText: hintText,
         hintStyle: AppTypography.label18LG,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColor.surfaceBrandPrimaryColor,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColor.redColor,
              width: 2.0,
            ),
          ), 
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColor.surfaceBrandPrimaryColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

