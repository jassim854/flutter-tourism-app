
class UserDetailBookedModel {
    final Booking booking;
    final User user;
    final TourGuide tourGuide;

    UserDetailBookedModel({
        required this.booking,
        required this.user,
        required this.tourGuide,
    });

    factory UserDetailBookedModel.fromJson(Map<String, dynamic> json) => UserDetailBookedModel(
        booking: Booking.fromJson(json["booking"]),
        user: User.fromJson(json["user"]),
        tourGuide: TourGuide.fromJson(json["tour_guide"]),
    );

    Map<String, dynamic> toJson() => {
        "booking": booking.toJson(),
        "user": user.toJson(),
        "tour_guide": tourGuide.toJson(),
    };
}

class Booking {
    final int id;
    final DateTime date;
    final String startTime;
    final String endTime;
    final String status;

    Booking({
        required this.id,
        required this.date,
        required this.startTime,
        required this.endTime,
        required this.status,
    });

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
    };
}

class TourGuide {
    final int id;
    final String name;
    final String description;
    final String location;
    final bool status;

    TourGuide({
        required this.id,
        required this.name,
        required this.description,
        required this.location,
        required this.status,
    });

    factory TourGuide.fromJson(Map<String, dynamic> json) => TourGuide(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "location": location,
        "status": status,
    };
}

class User {
    final int id;
    final String fullName;
    final String email;
    final String phoneNumber;
    final String deviceId;

    User({
        required this.id,
        required this.fullName,
        required this.email,
        required this.phoneNumber,
        required this.deviceId,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        deviceId: json["device_id"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "device_id": deviceId,
    };
}
