class NationalityModel {
  final int nationalityCode;
  final String nationalityNameAr;

  NationalityModel({required this.nationalityCode, required this.nationalityNameAr});

  factory NationalityModel.fromJson(Map<String, dynamic> json) {
    return NationalityModel(
      nationalityCode: json['NATIONALITY_CODE'] ?? 0,
      nationalityNameAr: json['NATIONALITY_NAME_AR'] ?? '',
    );
  }
}
