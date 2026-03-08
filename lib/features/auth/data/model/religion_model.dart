class ReligionModel {
  final int religionCode;
  final String religionNameAr;

  ReligionModel({required this.religionCode, required this.religionNameAr});

  factory ReligionModel.fromJson(Map<String, dynamic> json) {
    return ReligionModel(
      religionCode: json['RELIGION_CODE'] ?? 0,
      religionNameAr: json['RELIGION_NAME_AR'] ?? '',
    );
  }
}
