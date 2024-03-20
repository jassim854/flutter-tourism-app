import 'package:flutter_riverpod/flutter_riverpod.dart';

final popAllScreenProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});