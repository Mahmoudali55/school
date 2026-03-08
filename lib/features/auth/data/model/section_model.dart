class SectionModel {
  final int sectionCode;
  final String sectionNameAr;

  SectionModel({required this.sectionCode, required this.sectionNameAr});

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      sectionCode: json['SECTION_CODE'] ?? 0,
      sectionNameAr: json['SECTION_NAME_AR'] ?? '',
    );
  }
}
