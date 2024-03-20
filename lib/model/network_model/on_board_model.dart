class OnBoardModel {
    final int id;
    final String name;
    final String description;
    final String heading;
    final String image;

    OnBoardModel({
        required this.id,
        required this.name,
        required this.description,
        required this.heading,
        required this.image,
    });

    factory OnBoardModel.fromJson(Map<String, dynamic> json) => OnBoardModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        heading: json["heading"],
        image: json["image"],
    );


}