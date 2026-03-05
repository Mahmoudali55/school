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
  String get fileExtension {
    final parts = filePath.toLowerCase().split('.');
    return parts.isNotEmpty ? parts.last : '';
  }

  @override
  List<Object?> get props => [id, fileName, filePath, levelCode, teacherCode, notes, teacherName];
}
