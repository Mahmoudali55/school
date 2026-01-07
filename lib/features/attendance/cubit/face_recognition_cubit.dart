import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/services/camera_service.dart';
import '../../../core/services/face_detection_service.dart';
import '../data/models/student_face_model.dart';
import '../data/repository/face_recognition_repo.dart';

part 'face_recognition_state.dart';

class FaceRecognitionCubit extends Cubit<FaceRecognitionState> {
  final CameraService cameraService;
  final FaceDetectionService faceDetectionService;
  final FaceRecognitionRepo faceRecognitionRepo;

  // Cache for registered face features to speed up recognition
  String? _currentCachedClassId;
  List<StudentFaceModel>? _cachedClassFaces;
  Map<String, List<double>>? _cachedFeaturesMap;

  FaceRecognitionCubit({
    required this.cameraService,
    required this.faceDetectionService,
    required this.faceRecognitionRepo,
  }) : super(FaceRecognitionInitial());

  /// Initialize camera for face detection
  Future<void> initializeCamera({CameraLensDirection direction = CameraLensDirection.front}) async {
    emit(FaceRecognitionCameraInitializing());

    try {
      await faceDetectionService.initialize();
      final success = await cameraService.initializeCamera(direction: direction);

      if (success) {
        emit(FaceRecognitionCameraReady());
      } else {
        emit(const FaceRecognitionError('Failed to initialize camera'));
      }
    } catch (e) {
      emit(FaceRecognitionError('Camera initialization error: ${e.toString()}'));
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    emit(FaceRecognitionCameraInitializing());

    try {
      final success = await cameraService.switchCamera();

      if (success) {
        emit(FaceRecognitionCameraReady());
      } else {
        emit(const FaceRecognitionError('Failed to switch camera'));
      }
    } catch (e) {
      emit(FaceRecognitionError('Camera switch error: ${e.toString()}'));
    }
  }

  /// Capture and register student face
  Future<void> registerStudentFace({
    required String studentId,
    required String studentName,
    required String classId,
  }) async {
    emit(FaceRecognitionProcessing());

    try {
      // Capture image
      final imageFile = await cameraService.captureImage();

      if (imageFile == null) {
        emit(const FaceRecognitionError('Failed to capture image'));
        return;
      }

      // Check if image contains a valid face
      final hasValidFace = await faceDetectionService.hasValidFace(imageFile);

      if (!hasValidFace) {
        emit(const FaceRecognitionError('No clear face detected. Please try again.'));
        return;
      }

      // Get face quality score
      final qualityScore = await faceDetectionService.getFaceQualityScore(imageFile);

      if (qualityScore < 50) {
        emit(
          const FaceRecognitionError(
            'Face quality is too low. Please ensure good lighting and face the camera directly.',
          ),
        );
        return;
      }

      // Detect faces to extract features
      final faces = await faceDetectionService.detectFacesInFile(imageFile);
      if (faces.isEmpty) {
        emit(const FaceRecognitionError('No face detected during processing.'));
        return;
      }

      final features = faceDetectionService.extractFaceFeatures(faces.first);

      if (features.isEmpty) {
        emit(
          const FaceRecognitionError(
            'Could not extract face features. Please ensure face is clearly visible.',
          ),
        );
        return;
      }

      // Register face
      final result = await faceRecognitionRepo.registerStudentFace(
        studentId: studentId,
        studentName: studentName,
        classId: classId,
        faceImage: imageFile,
        metadata: {
          'qualityScore': qualityScore,
          'registrationTimestamp': DateTime.now().toIso8601String(),
          'features': features,
        },
      );

      result.fold(
        (error) => emit(FaceRecognitionError(error)),
        (faceModel) => emit(FaceRecognitionRegistered(faceModel)),
      );
    } catch (e) {
      emit(FaceRecognitionError('Registration error: ${e.toString()}'));
    }
  }

  /// Detect faces in current camera frame
  Future<void> detectFacesInFrame() async {
    try {
      final imageFile = await cameraService.captureImage();

      if (imageFile == null) {
        return;
      }

      final faces = await faceDetectionService.detectFacesInFile(imageFile);

      if (faces.isNotEmpty) {
        emit(FaceRecognitionFacesDetected(faces));
      } else {
        emit(FaceRecognitionNoFaceDetected());
      }
    } catch (e) {
      // Silent error for continuous detection
    }
  }

  /// Recognize student from captured image
  Future<void> recognizeStudent({required String classId, required double threshold}) async {
    emit(FaceRecognitionProcessing());

    try {
      // Capture image
      final capturedImage = await cameraService.captureImage();

      if (capturedImage == null) {
        emit(const FaceRecognitionError('Failed to capture image'));
        return;
      }

      // Detect faces
      final faces = await faceDetectionService.detectFacesInFile(capturedImage);

      if (faces.isEmpty) {
        emit(FaceRecognitionNoFaceDetected());
        return;
      }

      // Use the largest/main face
      final features = faceDetectionService.extractFaceFeatures(faces.first);

      if (features.isEmpty) {
        // Face found but features (landmarks) not clear enough
        emit(FaceRecognitionNoFaceDetected());
        return;
      }

      // Get registered faces for the class (using cache if possible)
      if (_currentCachedClassId != classId || _cachedFeaturesMap == null) {
        final result = await faceRecognitionRepo.getClassFaces(classId);

        await result.fold((error) async => throw Exception(error), (faces) async {
          _currentCachedClassId = classId;
          _cachedClassFaces = faces;
          _cachedFeaturesMap = {};

          for (var faceModel in faces) {
            List<double>? features;
            if (faceModel.faceMetadata != null && faceModel.faceMetadata!.containsKey('features')) {
              final featureData = faceModel.faceMetadata!['features'];
              if (featureData is List) {
                features = featureData.map((e) => (e as num).toDouble()).toList();
              }
            }

            // Migration fallback
            if (features == null || features.isEmpty) {
              final file = File(faceModel.faceImagePath);
              if (await file.exists()) {
                final detectedFaces = await faceDetectionService.detectFacesInFile(file);
                if (detectedFaces.isNotEmpty) {
                  features = faceDetectionService.extractFaceFeatures(detectedFaces.first);
                  if (features.isNotEmpty) {
                    await faceRecognitionRepo.updateStudentFaceMetadata(
                      studentId: faceModel.studentId,
                      metadata: {
                        ...?faceModel.faceMetadata,
                        'features': features,
                        'migratedAt': DateTime.now().toIso8601String(),
                      },
                    );
                  }
                }
              }
            }

            if (features != null && features.isNotEmpty) {
              _cachedFeaturesMap![faceModel.studentId] = features;
            }
          }
        });
      }

      if (_cachedClassFaces == null || _cachedClassFaces!.isEmpty) {
        emit(const FaceRecognitionError('No registered faces found for this class'));
        return;
      }

      if (_cachedFeaturesMap!.isEmpty) {
        emit(
          const FaceRecognitionError(
            'No valid face data found. Please ensure students are registered.',
          ),
        );
        return;
      }

      // Find best match using cached data
      final match = await faceDetectionService.findBestMatch(
        capturedFeatures: features,
        registeredFeatures: _cachedFeaturesMap!,
        threshold: threshold,
      );

      if (match != null) {
        final matchedStudent = _cachedClassFaces!.firstWhere(
          (face) => face.studentId == match['studentId'],
        );

        emit(
          FaceRecognitionStudentRecognized(
            student: matchedStudent,
            confidence: match['confidence'],
          ),
        );
      } else {
        emit(FaceRecognitionNoMatch());
      }
    } catch (e) {
      emit(FaceRecognitionError('Recognition error: ${e.toString()}'));
    }
  }

  /// Get registered students for a class
  Future<void> getRegisteredStudents(String classId) async {
    emit(FaceRecognitionLoading());

    try {
      final result = await faceRecognitionRepo.getClassFaces(classId);

      result.fold(
        (error) => emit(FaceRecognitionError(error)),
        (faces) => emit(FaceRecognitionRegisteredStudentsLoaded(faces)),
      );
    } catch (e) {
      emit(FaceRecognitionError('Failed to load registered students: ${e.toString()}'));
    }
  }

  /// Delete student face registration
  Future<void> deleteStudentFace(String studentId) async {
    emit(FaceRecognitionProcessing());

    try {
      final result = await faceRecognitionRepo.deleteStudentFace(studentId);

      result.fold((error) => emit(FaceRecognitionError(error)), (_) {
        // Invalidate cache if face deleted
        _currentCachedClassId = null;
        _cachedFeaturesMap = null;
        _cachedClassFaces = null;
        emit(FaceRecognitionFaceDeleted());
      });
    } catch (e) {
      emit(FaceRecognitionError('Failed to delete face: ${e.toString()}'));
    }
  }

  /// Dispose resources
  Future<void> disposeResources() async {
    await cameraService.disposeCamera();
    await faceDetectionService.dispose();
  }

  @override
  Future<void> close() {
    disposeResources();
    return super.close();
  }
}
