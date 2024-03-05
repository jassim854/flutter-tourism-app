
class CarModel {
    final int id;
    final String imagePath;
    final String carName;
    final String currency;
    final String price;
    final int flagId;

    CarModel({
        required this.id,
        required this.imagePath,
        required this.carName,
        required this.currency,
        required this.price,
        required this.flagId,
    });

    factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"],
        imagePath: json["image_path"],
        carName: json["car_name"],
        currency: json["currency"],
        price: json["price"],
        flagId: json["flag_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image_path": imagePath,
        "car_name": carName,
        "currency": currency,
        "price": price,
        "flag_id": flagId,
    };
}
