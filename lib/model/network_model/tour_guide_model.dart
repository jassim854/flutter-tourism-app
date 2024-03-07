class TourGuidModel {
    final int? id;
    final String? name;
    final String? description;
    final String? location;
    final bool? status;
    final String? images;

    TourGuidModel({
        this.id,
        this.name,
        this.description,
        this.location,
        this.status,
        this.images,
    });

    factory TourGuidModel.fromJson(Map<String, dynamic> json) => TourGuidModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        status: json["status"],
        images: json["images"] == null ? "" : json["images"]!,
    );

    // Map<String, dynamic> toJson() => {
    //     "id": id,
    //     "name": name,
    //     "description": description,
    //     "location": location,
    //     "status": status,
    //     "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    // };
}