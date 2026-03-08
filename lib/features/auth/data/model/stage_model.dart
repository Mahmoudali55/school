class StageModel {
  final int sectionCode;
  final int stageCode;
  final String stageNameAr;

  StageModel({required this.sectionCode, required this.stageCode, required this.stageNameAr});

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      sectionCode: json['SECTION_CODE'] ?? 0,
      stageCode: json['STAGE_CODE'] ?? 0,
      stageNameAr: json['STAGE_NAME_AR'] ?? '',
    );
  }
}
