import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';

countryPickerSheetWidget(BuildContext context,
    {required void Function(Country) onSelect}) {
  return showCountryPicker(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: AppTypography.label16MD
            .copyWith(color: AppColor.textBrandSecondaryColor),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          hintStyle: AppTypography.label16MD,
          labelStyle: AppTypography.paragraph16LG,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.surfaceBrandSecondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2.5, color: AppColor.surfaceBrandPrimaryColor),
          ),
        ),
      ),
      onSelect: onSelect);
}
