class SupportModel {
  final int id;
  final String phone;
  final String description;
  final String email;

  SupportModel({
    required this.id,
    required this.phone,
    required this.description,
    required this.email,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
        id: json["id"],
        phone: json["phone"],
        description: json["description"],
        email: json["email"],
      );
}
