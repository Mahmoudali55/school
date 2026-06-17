import 'dart:convert';
import 'package:equatable/equatable.dart';

class DigitalLibraryItem extends Equatable {
  final int id;
  final String fileName;
  final String filePath;
  final int levelCode;
  final int teacherCode;
  final String notes;
  final String teacherName;

  const DigitalLibraryItem({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.levelCode,
    required this.teacherCode,
    required this.notes,
    required this.teacherName,
  });

  factory DigitalLibraryItem.fromJson(Map<String, dynamic> json) {
    return DigitalLibraryItem(
      id: json['id'] ?? 0,
      fileName: json['File_Name'] ?? '',
      filePath: json['File_path'] ?? '',
      levelCode: json['Level_Code'] ?? 0,
      teacherCode: json['Teacher_Code'] ?? 0,
      notes: json['Notes'] ?? '',
      teacherName: json['TEACHER_NAME'] ?? '',
    );
  }

  static List<DigitalLibraryItem> listFromResponse(Map<String, dynamic> response) {
    final dynamic rawData = response['Data'];
    if (rawData == null) return [];
    final List<dynamic> dataList = rawData is String ? jsonDecode(rawData) : rawData;
    return dataList.map((e) => DigitalLibraryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Helper to detect file type from path
  // في DigitalLibraryItem
String get fileExtension {
  // خد آخر جزء بعد آخر نقطة حقيقية
  final name = filePath.split('/').last.split('\\').last;
  final lastDot = name.lastIndexOf('.');
  if (lastDot == -1) return '';
  return name.substring(lastDot + 1).toLowerCase();
}

String get cleanFileName {
  final name = filePath.split('/').last.split('\\').last;
  // إزالة التكرار زي ".pdf_.pdf" → ".pdf"
  final ext = fileExtension;
  if (ext.isEmpty) return name;
  // شيل كل الامتدادات الزيادة قبل الامتداد الأخير
  final withoutExt = name.substring(0, name.lastIndexOf('.$ext'));
  // لو الجزء اللي قبله فيه نفس الامتداد كمان، شيله
  final cleaned = withoutExt.replaceAll(RegExp(r'\.' + ext + r'[_\s]*$', caseSensitive: false), '');
  return '$cleaned.$ext';
}

  @override
  List<Object?> get props => [id, fileName, filePath, levelCode, teacherCode, notes, teacherName];
}
