import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/network/api_service.dart';

final selectedDateProvider =
    StateNotifierProvider.autoDispose<SelectDate, DateTime?>((ref) {
  return SelectDate();
});

class SelectDate extends StateNotifier<DateTime?> {
  SelectDate() : super(null);

  updateDate(DateTime value) {
    state = value;
  }
}

final selectedFromTimeProvider =
    StateNotifierProvider.autoDispose<SelectDate, DateTime?>((ref) {
  return SelectDate();
});

class SelectFromTime extends StateNotifier<DateTime?> {
  SelectFromTime() : super(null);

  updateDate(DateTime value) {
    state = value;
  }
}

final selectedToTimeProvider =
    StateNotifierProvider.autoDispose<SelectDate, DateTime?>((ref) {
  return SelectDate();
});

class SelectToTime extends StateNotifier<DateTime?> {
  SelectToTime() : super(null);

  updateDate(DateTime value) {
    state = value;
  }
}

