import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/on_board_model.dart';


final onBoardDataProvider =
    StateNotifierProvider<OnBoardModelData,OnBoardModel?>((
  ref,
) {
  return OnBoardModelData();
});

class OnBoardModelData extends StateNotifier<OnBoardModel?> {
  OnBoardModelData() : super(null);

  void addData(OnBoardModel data) {
    state=data;
  }
}