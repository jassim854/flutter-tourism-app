import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/a_tour_guide_model.dart';

final aTourGuideProvider =
    StateNotifierProvider<ATourGuide, ATourGuideModel?>((ref) {
  return ATourGuide();
});

class ATourGuide extends StateNotifier<ATourGuideModel?> {
  ATourGuide() : super(null);
  addData(ATourGuideModel data) {
    state = data;
  }
}
