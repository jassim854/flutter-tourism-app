import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/a_tour_guide_model.dart';

final aTourGuideProvider =
    StateNotifierProvider<ATourGuide, List<ATourGuideModel>>((ref) {
  return ATourGuide();
});

class ATourGuide extends StateNotifier<List<ATourGuideModel>> {
  ATourGuide() : super([]);
  addData(List<ATourGuideModel> data) {
    state = data;
  }
}
