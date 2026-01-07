// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceRecordModelAdapter extends TypeAdapter<AttendanceRecordModel> {
  @override
  final int typeId = 11;

  @override
  AttendanceRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceRecordModel(
      id: fields[0] as String,
      studentId: fields[1] as String,
      studentName: fields[2] as String,
      classId: fields[3] as String,
      date: fields[4] as DateTime,
      status: fields[5] as AttendanceStatus,
      recognitionMethod: fields[6] as RecognitionMethod,
      confidenceScore: fields[7] as double?,
      checkInTime: fields[8] as DateTime?,
      notes: fields[9] as String?,
      teacherId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceRecordModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.studentName)
      ..writeByte(3)
      ..write(obj.classId)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.recognitionMethod)
      ..writeByte(7)
      ..write(obj.confidenceScore)
      ..writeByte(8)
      ..write(obj.checkInTime)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.teacherId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttendanceStatusAdapter extends TypeAdapter<AttendanceStatus> {
  @override
  final int typeId = 12;

  @override
  AttendanceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttendanceStatus.present;
      case 1:
        return AttendanceStatus.absent;
      case 2:
        return AttendanceStatus.late;
      case 3:
        return AttendanceStatus.excused;
      default:
        return AttendanceStatus.present;
    }
  }

  @override
  void write(BinaryWriter writer, AttendanceStatus obj) {
    switch (obj) {
      case AttendanceStatus.present:
        writer.writeByte(0);
        break;
      case AttendanceStatus.absent:
        writer.writeByte(1);
        break;
      case AttendanceStatus.late:
        writer.writeByte(2);
        break;
      case AttendanceStatus.excused:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecognitionMethodAdapter extends TypeAdapter<RecognitionMethod> {
  @override
  final int typeId = 13;

  @override
  RecognitionMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecognitionMethod.faceRecognition;
      case 1:
        return RecognitionMethod.manual;
      case 2:
        return RecognitionMethod.qrCode;
      default:
        return RecognitionMethod.faceRecognition;
    }
  }

  @override
  void write(BinaryWriter writer, RecognitionMethod obj) {
    switch (obj) {
      case RecognitionMethod.faceRecognition:
        writer.writeByte(0);
        break;
      case RecognitionMethod.manual:
        writer.writeByte(1);
        break;
      case RecognitionMethod.qrCode:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecognitionMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
