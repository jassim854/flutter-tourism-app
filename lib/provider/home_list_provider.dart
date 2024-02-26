import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/dummy_model.dart';

final isLoadMoreProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final isNoDataProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final nextPageProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final isLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final dummyListDataProvider =
    StateNotifierProvider.autoDispose<DummyListData, List<DummyModel>>((
  ref,
) {
  return DummyListData();
});

class DummyListData extends StateNotifier<List<DummyModel>> {
  DummyListData() : super([]);
  
  void addData(List<DummyModel> data) {
    
    state.addAll(data);
  }
}
