class ATourGuideModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final bool status;
  final List<String> images;
  final List<dynamic> similarTourGuides;

  ATourGuideModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.status,
    required this.images,
    required this.similarTourGuides,
  });

  factory ATourGuideModel.fromJson(Map<String, dynamic> json) =>
      ATourGuideModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        status: json["status"],
        images: List<String>.from(json["images"].map((x) => x)),
        similarTourGuides:
            List<dynamic>.from(json["similarTourGuides"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "location": location,
        "status": status,
        "images": List<dynamic>.from(images.map((x) => x)),
        "similar_tour_guides":
            List<dynamic>.from(similarTourGuides.map((x) => x)),
      };
}
