class CountryModel{
  final int id;
  final String countryName;
final String countryFlagUrl;
final bool status;

CountryModel( {required this.id,required this.status, required this.countryName,required this.countryFlagUrl});


  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["id"],
        countryName: json["name"],
        countryFlagUrl: json["image"],
        status: json["status"],
   
      );

}

