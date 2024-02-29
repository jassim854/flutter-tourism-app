
class UserBookedModel {
    final int id;
    final DateTime date;
    final String startTime;
    final String endTime;
    final String bookingStatus;
    final int tgId;
    final int userId;

    UserBookedModel({
        required this.id,
        required this.date,
        required this.startTime,
        required this.endTime,
        required this.bookingStatus,
        required this.tgId,
        required this.userId,
    });

    factory UserBookedModel.fromJson(Map<String, dynamic> json) => UserBookedModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        bookingStatus: json["booking_status"],
        tgId: json["tg_id"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "booking_status": bookingStatus,
        "tg_id": tgId,
        "user_id": userId,
    };
}