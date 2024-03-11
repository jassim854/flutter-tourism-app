import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/car_model.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/model/network_model/user_detail_booking_model.dart';

final carListDataProvider =
    StateNotifierProvider<CarListData, List<CarModel>>((ref) {
  return CarListData();
});

class CarListData extends StateNotifier<List<CarModel>> {
  CarListData() : super([]);
  addValue(List<CarModel> data) {
    state = data;
  }
}

final selectedCarProvider = StateProvider.autoDispose<CarModel?>((ref) {
  return null;
});
final isBookCarProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final totalAmountProvider = StateProvider.autoDispose<double>((ref) {
  return 0.0;
});
