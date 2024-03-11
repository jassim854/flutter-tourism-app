import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/validators.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

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

class PhoneNumberFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const PhoneNumberFieldWidget({
    super.key,
    required this.controller,
  });

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: "AE",
      // controller: widget.controller,
      pickerDialogStyle: PickerDialogStyle(
        searchFieldPadding: const EdgeInsets.all(10),
        backgroundColor: AppColor.surfaceBackgroundColor,
        searchFieldInputDecoration: InputDecoration(
          filled: true,
          fillColor: AppColor.surfaceBackgroundColor,
          hintText: "Search Country",
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          enabledBorder: OutlineInputBorder(
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
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color:
                    AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 10), child: Icon(Icons.search)),
          hintStyle: AppTypography.paragraph16LG
              .copyWith(color: AppColor.textBlackColor),
        ),
      ),
      dropdownDecoration: BoxDecoration(
        color: AppColor.surfaceBackgroundColor,
      ),

      onChanged: (value) {
        widget.controller.text = "${value.countryCode}${value.number}";
      },

      // onCountryChanged: (value) {
      //   widget.controller.text = value.fullCountryCode + widget.controller.text;
      // },
      // dropdownDecoration: InputDecoration(
      //   filled: true,
      //   fillColor: AppColor.surfaceBackgroundColor,
      //   hintText: "Search Country",
      //   contentPadding:
      //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //         color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: BorderSide(
      //         width: 0.5,
      //         color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      //   border: OutlineInputBorder(
      //     borderSide: BorderSide(
      //         color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      //   prefixIcon: const Padding(
      //       padding: EdgeInsets.only(left: 10), child: Icon(Icons.search)),
      //   hintStyle: AppTypography.paragraph16LG
      //       .copyWith(color: AppColor.textBlackColor),
      // ),

      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.surfaceBackgroundColor,
        hintText: "Enter Phone Number",
        hintStyle: AppTypography.label18LG.copyWith(
            color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.9)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColor.redColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 0.5,
              color: AppColor.surfaceBackgroundBaseDarkColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      cursorColor: AppColor.surfaceBrandPrimaryColor,
      style: AppTypography.label16MD,
    );
  }
}
