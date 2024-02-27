import 'package:flutter_riverpod/flutter_riverpod.dart';

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