import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student_face_model.dart';

class FaceRecognitionRepo {
  static const String _boxName = 'student_faces';

  Future<Box<StudentFaceModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<StudentFaceModel>(_boxName);
    }
    return Hive.box<StudentFaceModel>(_boxName);
  }

  /// Register a student's face
  Future<Either<String, StudentFaceModel>> registerStudentFace({
    required String studentId,
    required String studentName,
    required String classId,
    required File faceImage,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Save image to app directory
      final directory = await getApplicationDocumentsDirectory();
      final facesDir = Directory('${directory.path}/student_faces');
      if (!await facesDir.exists()) {
        await facesDir.create(recursive: true);
      }

      final fileName = '${studentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${facesDir.path}/$fileName';
      await faceImage.copy(filePath);

      // Create model
      final faceModel = StudentFaceModel(
        studentId: studentId,
        studentName: studentName,
        faceImagePath: filePath,
        registrationDate: DateTime.now(),
        classId: classId,
        faceMetadata: metadata,
      );

      // Save to Hive
      final box = await _getBox();
      await box.put(studentId, faceModel);

      return Right(faceModel);
    } catch (e) {
      return Left('Failed to register face: ${e.toString()}');
    }
  }

  /// Get registered face for a student
  Future<Either<String, StudentFaceModel?>> getStudentFace(String studentId) async {
    try {
      final box = await _getBox();
      final faceModel = box.get(studentId);
      return Right(faceModel);
    } catch (e) {
      return Left('Failed to get student face: ${e.toString()}');
    }
  }

  /// Get all registered faces for a class
  Future<Either<String, List<StudentFaceModel>>> getClassFaces(String classId) async {
    try {
      final box = await _getBox();
      final allFaces = box.values.where((face) => face.classId == classId).toList();
      return Right(allFaces);
    } catch (e) {
      return Left('Failed to get class faces: ${e.toString()}');
    }
  }

  /// Get all registered student IDs for a class
  Future<Either<String, List<String>>> getRegisteredStudentIds(String classId) async {
    try {
      final box = await _getBox();
      final registeredIds = box.values
          .where((face) => face.classId == classId)
          .map((face) => face.studentId)
          .toList();
      return Right(registeredIds);
    } catch (e) {
      return Left('Failed to get registered student IDs: ${e.toString()}');
    }
  }

  /// Delete a student's face registration
  Future<Either<String, bool>> deleteStudentFace(String studentId) async {
    try {
      final box = await _getBox();
      final faceModel = box.get(studentId);

      if (faceModel != null) {
        // Delete image file
        final file = File(faceModel.faceImagePath);
        if (await file.exists()) {
          await file.delete();
        }

        // Delete from Hive
        await box.delete(studentId);
      }

      return const Right(true);
    } catch (e) {
      return Left('Failed to delete face: ${e.toString()}');
    }
  }

  /// Update student face registration
  Future<Either<String, StudentFaceModel>> updateStudentFace({
    required String studentId,
    required File newFaceImage,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final box = await _getBox();
      final existingFace = box.get(studentId);

      if (existingFace == null) {
        return const Left('Student face not found');
      }

      // Delete old image
      final oldFile = File(existingFace.faceImagePath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      // Save new image
      final directory = await getApplicationDocumentsDirectory();
      final facesDir = Directory('${directory.path}/student_faces');
      final fileName = '${studentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${facesDir.path}/$fileName';
      await newFaceImage.copy(filePath);

      // Update model
      final updatedFace = existingFace.copyWith(
        faceImagePath: filePath,
        registrationDate: DateTime.now(),
        faceMetadata: metadata,
      );

      await box.put(studentId, updatedFace);

      return Right(updatedFace);
    } catch (e) {
      return Left('Failed to update face: ${e.toString()}');
    }
  }

  /// Update just the metadata of a student face (e.g. for migration)
  Future<Either<String, StudentFaceModel>> updateStudentFaceMetadata({
    required String studentId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final box = await _getBox();
      final existingFace = box.get(studentId);

      if (existingFace == null) {
        return const Left('Student face not found');
      }

      // Update model
      final updatedFace = existingFace.copyWith(faceMetadata: metadata);

      await box.put(studentId, updatedFace);

      return Right(updatedFace);
    } catch (e) {
      return Left('Failed to update face metadata: ${e.toString()}');
    }
  }

  /// Check if student has registered face
  Future<bool> hasRegisteredFace(String studentId) async {
    try {
      final box = await _getBox();
      return box.containsKey(studentId);
    } catch (e) {
      return false;
    }
  }

  /// Get total registered faces count
  Future<int> getRegisteredFacesCount() async {
    try {
      final box = await _getBox();
      return box.length;
    } catch (e) {
      return 0;
    }
  }
}
