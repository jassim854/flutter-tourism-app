import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomSearchTextFieldWidget extends StatelessWidget {
  CustomSearchTextFieldWidget(
      {super.key,
      this.searchController,
      this.showCloseIcon,
      this.onChange,
      this.onIconTap,
      required this.hintText,
      this.onSubmitted,
      this.margin =
          const EdgeInsets.only(top: 10, left: 20, right: 8, bottom: 12),
      this.onFieldTap,
      this.focusNode});
  bool? showCloseIcon;
  void Function()? onIconTap;
  void Function(String)? onChange;
  TextEditingController? searchController;
  final String hintText;
  EdgeInsetsGeometry? margin;
  void Function()? onFieldTap;
  void Function(String)? onSubmitted;
  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          color: AppColor.surfaceBackgroundSecondaryColor,
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        focusNode: focusNode,
        readOnly: onFieldTap != null ? true : false,
        magnifierConfiguration: TextMagnifier.adaptiveMagnifierConfiguration,
        textAlignVertical: TextAlignVertical.center,
        onTap: onFieldTap,
        onChanged: onChange,
        controller: searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (onSubmitted != null) {
            onSubmitted!(value);
          }
        },
        style: AppTypography.paragraph14MD
            .copyWith(color: AppColor.textBrandSecondaryColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 10),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          constraints: const BoxConstraints(
              maxHeight: 0, maxWidth: 0, minHeight: 0, minWidth: 0),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIcon: showCloseIcon == true
              ? InkWell(onTap: onIconTap, child: const Icon(Icons.cancel))
              : const SizedBox.shrink(),
          suffixIconColor: AppColor.surfaceBrandDarkColor,
          hintStyle: AppTypography.paragraph14MD
              .copyWith(color: AppColor.textBrandSecondaryColor),
          prefixIcon:
              Icon(Icons.search, color: AppColor.textBrandSecondaryColor),
        ),
      ),
    );
  }
}

class PhoneNumberFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const PhoneNumberFieldWidget({super.key, required this.controller});
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      spaceBetweenSelectorAndTextField: 23,
      searchBoxDecoration: InputDecoration(
        hintText: "Search Country",
        icon: const Padding(
            padding: EdgeInsets.only(left: 10), child: Icon(Icons.search)),
        hintStyle: AppTypography.paragraph16LG
            .copyWith(color: AppColor.textBlackColor),
      ),
      selectorConfig: const SelectorConfig(
          leadingPadding: 20,
          useBottomSheetSafeArea: true,
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          setSelectorButtonAsPrefixIcon: false),
      inputDecoration: InputDecoration(
        hintText: "Phone Number",
        hintStyle: AppTypography.paragraph16LG
            .copyWith(color: AppColor.textBlackColor),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.surfaceBrandSecondaryColor)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.surfaceBrandSecondaryColor)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: AppColor.surfaceBrandPrimaryColor)),
        labelStyle: AppTypography.paragraph14MD
            .copyWith(color: AppColor.buttonLabelColor),
      ),
      cursorColor: AppColor.surfaceBrandPrimaryColor,
      textStyle: AppTypography.label16MD,
      autofillHints: ["Pk", "ch", "in"],
      onFieldSubmitted: (value) {},
      onInputChanged: (PhoneNumber value) {},
    );
  }
}
