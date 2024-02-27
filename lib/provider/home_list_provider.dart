import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/dummy_model.dart';
import 'package:flutter_tourism_app/model/network_model/tour_guide_model.dart';

final dropdownvalueProvider = StateProvider.autoDispose<String>((ref) {
  return "Country";
});

// final dummyListDataProvider =
//     StateNotifierProvider.autoDispose<DummyListData, List<DummyModel>>((
//   ref,
// ) {
//   return DummyListData();
// });

// class DummyListData extends StateNotifier<List<DummyModel>> {
//   DummyListData() : super([]);

//   void addData(List<DummyModel> data) {
//     state.addAll(data);
//   }
// }

final countryWiseTourGuideDataProvider =
    StateNotifierProvider.autoDispose<CountryWiseTourGuideData, List<TourGuidModel>>((
  ref,
) {
  return CountryWiseTourGuideData();
});

class CountryWiseTourGuideData extends StateNotifier<List<TourGuidModel>> {
  CountryWiseTourGuideData() : super([]);

  void addData(List<TourGuidModel> data) {
    state.addAll(data);
  }
}