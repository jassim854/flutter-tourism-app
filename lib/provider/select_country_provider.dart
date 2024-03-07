import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/country_model.dart';

final showCloseIconProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

// final selectCountryProvider = ChangeNotifierProvider<SelectCountry>((ref) {
//   return SelectCountry();
// });

final selectedCountryProvider = StateProvider.autoDispose<CountryModel?>((ref) {
  return null;
});

final searchedCountryProvider = StateNotifierProvider.family
    .autoDispose<SearchedCountry, List<CountryModel>, List<CountryModel>>(
        (ref, data) {
  return SearchedCountry(data);
});

class SearchedCountry extends StateNotifier<List<CountryModel>> {
  SearchedCountry(super.state);

  void addData(List<CountryModel> data) {
    state = data;
  }

  void filterData(String value, List<CountryModel> data) {
    state = [
      ...data.where(
          (element) => element.countryName.toLowerCase().trim().contains(value))
    ];
  }
}
final countryListDataProvider = StateNotifierProvider
    <CountryListData, List<CountryModel>>(
        (ref,) {
  return CountryListData();
});

class CountryListData extends StateNotifier<List<CountryModel>> {
  CountryListData():super([]);

  void addData(List<CountryModel> data) {
    state = data;
  }


}
// class SelectCountry extends ChangeNotifier {

// }
