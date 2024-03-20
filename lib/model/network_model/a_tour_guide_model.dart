class ATourGuideModel {
  final int? id;
  final String? name;
  final String? description;
  final String? location;
  final String? countryImg;
  final String? currency;
  final String? price;
  final bool? status;
  final String? images;
  final List<ATourGuideModel>? similarTourGuides;

  ATourGuideModel({
    this.currency,
    this.price,
    this.id,
    this.name,
    this.description,
    this.location,
    this.status,
    this.images,
    this.countryImg,
    this.similarTourGuides,
  });

  factory ATourGuideModel.fromJson(Map<String, dynamic> json) =>
      ATourGuideModel(
        currency: json["currency"],
        price: json["price"],
        id: json["id"],
        name: json["name"],
        description: json["description"],
        location: json["location"],
        countryImg: json['country-image'],
        status: json["status"],
        images: json["images"],
        similarTourGuides: json["similar_tour_guides"] == null
            ? null
            : List<ATourGuideModel>.from(json["similar_tour_guides"]
                .map((x) => ATourGuideModel.fromJson(x))),
      );
}
