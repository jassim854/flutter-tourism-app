import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app/model/network_model/user_booked_model.dart';
import 'package:flutter_tourism_app/model/network_model/user_detail_booking_model.dart';
final userAllBookedListProvider = StateNotifierProvider<UserBooked,  List<UserBookedModel>>((ref) {
  return  UserBooked();
});
class UserBooked extends StateNotifier< List<UserBookedModel>> {
  UserBooked(): super([]);
  addValue( List<UserBookedModel> data){
state=data;
  }
}

final userPendingBookedListProvider = StateNotifierProvider<UserBookedPending,  List<UserBookedModel>>((ref) {
  return  UserBookedPending();
});
class UserBookedPending extends StateNotifier< List<UserBookedModel>> {
  UserBookedPending(): super([]);
 addValue( List<UserBookedModel> data){
  state.clear();
    for (var element in data) {
  if (element.booking?.status=="pending") {
 state.add(element);
  }
}

  }
}
final userConfirmBookedListProvider = StateNotifierProvider<UserConfirmedBooking,  List<UserBookedModel>>((ref) {
  return  UserConfirmedBooking();
});
class UserConfirmedBooking extends StateNotifier< List<UserBookedModel>> {
  UserConfirmedBooking(): super([]);
  addValue( List<UserBookedModel> data){
      state.clear();
    for (var element in data) {
      
  if (element.booking?.status=="completed") {
 state.add(element);
  }
}

  }
}
final userCancelledBookedListProvider = StateNotifierProvider<UserCancelledBooking,  List<UserBookedModel>>((ref) {
  return  UserCancelledBooking();
});
class UserCancelledBooking extends StateNotifier< List<UserBookedModel>> {
  UserCancelledBooking(): super([]);
  addValue( List<UserBookedModel> data){
      state.clear();
    for (var element in data) {
      
  if (element.booking?.status=="cancelled") {
 state.add(element);
  }
}

  }
}


final userDetailProvider = StateNotifierProvider.autoDispose <UserDetailBooking,  UserBookedModel?>((ref) {
  return  UserDetailBooking();
});
class UserDetailBooking extends StateNotifier< UserBookedModel?> {
  UserDetailBooking(): super(null);
  addValue( UserBookedModel data){
state=data;

  }
}