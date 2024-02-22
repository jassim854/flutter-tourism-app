import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final onBoardProvider = ChangeNotifierProvider<OnBoardNotifier>((ref) {
//   return OnBoardNotifier();
// });
// class OnBoardNotifier extends ChangeNotifier {
//   int currentStep;
// }
final onBoardProvider = StateProvider<int>((ref) {
  return 1;
});
