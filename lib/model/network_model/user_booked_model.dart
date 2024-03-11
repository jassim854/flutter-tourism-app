// class UserBookedModel {
//     final int id;
//     final DateTime date;
//     final String startTime;
//     final String endTime;
//     final String bookingStatus;
//     final int tgId;
//     final int userId;

//     UserBookedModel({
//         required this.id,
//         required this.date,
//         required this.startTime,
//         required this.endTime,
//         required this.bookingStatus,
//         required this.tgId,
//         required this.userId,
//     });

//     factory UserBookedModel.fromJson(Map<String, dynamic> json) => UserBookedModel(
//         id: json["id"],
//         date: DateTime.parse(json["date"]),
//         startTime: json["start_time"],
//         endTime: json["end_time"],
//         bookingStatus: json["booking_status"],
//         tgId: json["tg_id"],
//         userId: json["user_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//         "start_time": startTime,
//         "end_time": endTime,
//         "booking_status": bookingStatus,
//         "tg_id": tgId,
//         "user_id": userId,
//     };
// }

import 'package:intl/intl.dart';

class UserBookedModel {
  final Booking? booking;
  final User? user;
  final TourGuide? tourGuide;
  final Car? car;

  UserBookedModel({
    this.booking,
    this.user,
    this.tourGuide,
    this.car,
  });

  factory UserBookedModel.fromJson(Map<String, dynamic> json) =>
      UserBookedModel(
        booking:
            json["booking"] == null ? null : Booking.fromJson(json["booking"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        tourGuide: json["tour_guide"] == null
            ? null
            : TourGuide.fromJson(json["tour_guide"]),
        car: json["car"] == null ? null : Car.fromJson(json["car"]),
      );

  Map<String, dynamic> toJson() => {
        "booking": booking?.toJson(),
        "user": user?.toJson(),
        "tour_guide": tourGuide?.toJson(),
        "car": car?.toJson(),
      };
}

class Booking {
  final int? id;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? status;
  final String? car;
  final String? notes;

  Booking(
      {this.id,
      this.date,
      this.startTime,
      this.endTime,
      this.status,
      this.car,
      this.notes});

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
      id: json["id"],
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      startTime: json["start_time"] == null
          ? null
          : DateFormat("HH:mm:ss").parse(json["start_time"]),
      endTime: json["end_time"] == null
          ? null
          : DateFormat("HH:mm:ss").parse(json["end_time"]),
      status: json["status"],
      car: json["car"],
      notes: json["notes"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
        "car": car,
      };
}

class Car {
  final int? id;
  final String? imagePath;
  final String? carName;
  final String? currency;
  final double? price;

  Car({
    this.id,
    this.imagePath,
    this.carName,
    this.currency,
    this.price,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["id"],
        imagePath: json["image_path"],
        carName: json["car_name"],
        currency: json["currency"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_path": imagePath,
        "car_name": carName,
        "currency": currency,
        "price": price,
      };
}

class TourGuide {
  final int? id;
  final String? name;
  final String? description;
  final String? location;
  final bool? status;
  final String? images;

  TourGuide({
    this.id,
    this.name,
    this.description,
    this.location,
    this.status,
    this.images,
  });

  factory TourGuide.fromJson(Map<String, dynamic> json) => TourGuide(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        status: json["status"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "location": location,
        "status": status,
        "images": images,
      };
}

class User {
  final int? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final dynamic deviceId;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.deviceId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "device_id": deviceId,
      };
}
