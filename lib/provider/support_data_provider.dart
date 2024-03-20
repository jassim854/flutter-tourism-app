import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/support_model.dart';

final supportDataProvider =
    StateNotifierProvider<SupportModelData,SupportModel?>((
  ref,
) {
  return SupportModelData();
});

class SupportModelData extends StateNotifier<SupportModel?> {
  SupportModelData() : super(null);

  void addData(SupportModel data) {
    state=data;
  }
}