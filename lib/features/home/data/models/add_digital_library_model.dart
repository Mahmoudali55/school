import 'package:equatable/equatable.dart';

class AddDigitalLibraryRequestModel extends Equatable {
  final String? id;
  final String fileName;
  final String filepath;

  final int levelCode;
  final int teacherCode;
  final String notes;

  const AddDigitalLibraryRequestModel({
    this.id,
    required this.fileName,
    required this.filepath,

    required this.levelCode,
    required this.teacherCode,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? "",
      "File_Name": fileName,
      "File_path": filepath,
      "Level_Code": levelCode,
      "Teacher_Code": teacherCode,
      "Notes": notes,
    };
  }

  @override
  List<Object?> get props => [id, fileName, filepath, levelCode, teacherCode, notes];
}

class AddDigitalLibraryResponseModel extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddDigitalLibraryResponseModel({
    required this.success,
    required this.id,
    required this.msg,
  });

  factory AddDigitalLibraryResponseModel.fromJson(Map<String, dynamic> json) {
    return AddDigitalLibraryResponseModel(
      success: json['success'] ?? false,
      id: json['id'] ?? 0,
      msg: json['msg'] ?? "",
    );
  }

  @override
  List<Object?> get props => [success, id, msg];
}
