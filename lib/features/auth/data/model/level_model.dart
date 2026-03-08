class LevelModel {
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final String levelNameAr;

  LevelModel({
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.levelNameAr,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      sectionCode: json['SECTION_CODE'] ?? 0,
      stageCode: json['STAGE_CODE'] ?? 0,
      levelCode: json['LEVEL_CODE'] ?? 0,
      levelNameAr: json['LEVEL_NAME_AR'] ?? '',
    );
  }
}
