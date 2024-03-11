import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/network/api_service.dart';

final selectedDateProvider =
    StateNotifierProvider<SelectDate, DateTime?>((ref) {
  return SelectDate();
});

class SelectDate extends StateNotifier<DateTime?> {
  SelectDate() : super(null);

  updateDate(DateTime value) {
    state = value;
  }
}
final isPhoneNoProvider = StateProvider<bool>((ref) {
  return false ;
});
final selectedFromTimeProvider =
    StateNotifierProvider<SelectDate, DateTime?>((ref) {
  return SelectDate();
});

class SelectFromTime extends StateNotifier<DateTime?> {
  SelectFromTime() : super(null);

  updateDate(DateTime value) {
    state = value;
  }
}

final selectedToTimeProvider =
    StateProvider<int>((ref) {
  return 0;
});

