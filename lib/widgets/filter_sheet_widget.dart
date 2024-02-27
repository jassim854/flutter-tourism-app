import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/country_model.dart';
import 'package:flutter_tourism_app/provider/select_country_provider.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';
import 'package:flutter_tourism_app/utils/app_typography.dart';
import 'package:flutter_tourism_app/utils/extensions.dart';
import 'package:flutter_tourism_app/widgets/cache_network_image_widget.dart';
import 'package:flutter_tourism_app/widgets/custom_field_widget.dart';

class FilterSheetWidget extends ConsumerStatefulWidget {
  const FilterSheetWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterSheetWidgetState();
}

class _FilterSheetWidgetState extends ConsumerState<FilterSheetWidget> {
  late TextEditingController _searchController;
  List<CountryModel> countryModelData = [
    CountryModel(
        countryName: "Afghanistan",
        countryFlagUrl: "https://www.worldometers.info/img/flags/af-flag.gif"),
    CountryModel(
        countryName: "Albania",
        countryFlagUrl: "https://www.worldometers.info/img/flags/al-flag.gif"),
    CountryModel(
        countryName: "Algeria",
        countryFlagUrl: "https://www.worldometers.info/img/flags/ag-flag.gif"),
    CountryModel(
        countryName: "Andorra",
        countryFlagUrl: "https://www.worldometers.info/img/flags/an-flag.gif"),
    CountryModel(
        countryName: "Angola",
        countryFlagUrl: "https://www.worldometers.info/img/flags/ao-flag.gif"),
  ];
  @override
  void initState() {
    _searchController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String selectedFilter = '';
  @override
  Widget build(BuildContext context) {
    bool closeIcon = ref.watch(showCloseIconProvider);
    String selectedCountry = ref.watch(selectedCountryProvider);
    List<CountryModel> searchedCountries =
        ref.watch(searchedCountryProvider(countryModelData));
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                // onTap: selectedFilter.isNotEmpty
                //     ? () {
                //         ListController.resetFilter(
                //             context, selectedFilter, widget.confirmedFilter);

                //         setState(() {});
                //       }
                //     : null,
                child: Text("Reset",
                    style: selectedFilter.isNotEmpty
                        ? AppTypography.label14SM
                            .copyWith(color: AppColor.buttonPrimaryColor)
                        : AppTypography.label14SM
                            .copyWith(color: AppColor.buttonDisableColor)),
              ),
              Text(
                "FIlter",
                style: AppTypography.label18LG
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              InkWell(
                onTap: () {
                  context.popPage();
                  ref.read(showCloseIconProvider.notifier).state = false;
                  // widget.onDone(selectedFilter);
                },
                child: Text("Done",
                    style: AppTypography.label14SM.copyWith(
                        color: AppColor.surfaceBrandDarkColor,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
        const Divider(),
        CustomSearchTextFieldWidget(
            margin:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 12),
            hintText: "Search",
            showCloseIcon: closeIcon,
            onChange: (value) {
              if (value == "") {
                ref.read(showCloseIconProvider.notifier).state = false;
              } else {
                ref.read(showCloseIconProvider.notifier).state = true;
              }
              delayedFunction(fn: () {
                if (value == "") {
                  ref
                      .read(searchedCountryProvider(countryModelData).notifier)
                      .addData(countryModelData);
                } else {
                  ref
                      .read(searchedCountryProvider(countryModelData).notifier)
                      .filterData(value.toLowerCase().trim(),countryModelData);
                }
              });
            },
            onIconTap: () {
              ref
                  .read(searchedCountryProvider(countryModelData).notifier)
                  .addData(countryModelData);

              ref.read(showCloseIconProvider.notifier).state = false;
              _searchController.clear();
            },
            searchController: _searchController),
        Expanded(
          child: Card(
            color: AppColor.surfaceBackgroundColor,
            surfaceTintColor: AppColor.surfaceBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            margin: const EdgeInsets.only(top: 2),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Flag',
                          style: AppTypography.title14XS,
                        ),
                        Text(
                          'Country',
                          style: AppTypography.title14XS,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      itemCount: searchedCountries.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          selected: searchedCountries[index].countryName ==
                                  selectedCountry
                              ? true
                              : false,
                          selectedTileColor: AppColor.surfaceBrandPrimaryColor,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: cacheNetworkWidget(context,
                                    imageUrl: searchedCountries[index]
                                        .countryFlagUrl),
                              ),
                              Text(
                                searchedCountries[index].countryName,
                                style: AppTypography.label18LG,
                              )
                            ],
                          ),
                          onTap: () {
                            ref.read(selectedCountryProvider.notifier).state =
                                searchedCountries[index].countryName;
                            // _.navigatepushReplacementNamed(AppBottomBar.routeName);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
