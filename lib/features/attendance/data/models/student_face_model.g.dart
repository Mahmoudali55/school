// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_face_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentFaceModelAdapter extends TypeAdapter<StudentFaceModel> {
  @override
  final int typeId = 10;

  @override
  StudentFaceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentFaceModel(
      studentId: fields[0] as String,
      studentName: fields[1] as String,
      faceImagePath: fields[2] as String,
      registrationDate: fields[3] as DateTime,
      classId: fields[4] as String,
      faceMetadata: (fields[5] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentFaceModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.studentName)
      ..writeByte(2)
      ..write(obj.faceImagePath)
      ..writeByte(3)
      ..write(obj.registrationDate)
      ..writeByte(4)
      ..write(obj.classId)
      ..writeByte(5)
      ..write(obj.faceMetadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentFaceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
