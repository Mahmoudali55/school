import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  late FaceDetector _faceDetector;
  bool _isInitialized = false;

  /// Initialize the face detector
  Future<void> initialize() async {
    if (_isInitialized) return;

    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      minFaceSize: 0.15,
      performanceMode: FaceDetectorMode.accurate,
    );

    _faceDetector = FaceDetector(options: options);
    _isInitialized = true;
  }

  /// Detect faces in an image file
  Future<List<Face>> detectFacesInFile(File imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final faces = await _faceDetector.processImage(inputImage);
      return faces;
    } catch (e) {
      throw Exception('Failed to detect faces: ${e.toString()}');
    }
  }

  /// Detect faces from image bytes
  Future<List<Face>> detectFacesFromBytes(Uint8List bytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Create temporary file
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/temp_face_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(bytes);

      final faces = await detectFacesInFile(tempFile);

      // Clean up
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      return faces;
    } catch (e) {
      throw Exception('Failed to detect faces from bytes: ${e.toString()}');
    }
  }

  /// Detect faces from InputImage (for camera frames)
  Future<List<Face>> detectFaces(InputImage inputImage) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final faces = await _faceDetector.processImage(inputImage);
      return faces;
    } catch (e) {
      throw Exception('Failed to detect faces: ${e.toString()}');
    }
  }

  /// Extract geometric features from a face (Face Embedding)
  List<double> extractFaceFeatures(Face face) {
    final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
    final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;
    final noseBase = face.landmarks[FaceLandmarkType.noseBase]?.position;
    final leftMouth = face.landmarks[FaceLandmarkType.leftMouth]?.position;
    final rightMouth = face.landmarks[FaceLandmarkType.rightMouth]?.position;
    final bottomMouth = face.landmarks[FaceLandmarkType.bottomMouth]?.position;

    // Check if we have all necessary landmarks
    if (leftEye == null ||
        rightEye == null ||
        noseBase == null ||
        leftMouth == null ||
        rightMouth == null ||
        bottomMouth == null) {
      return [];
    }

    // Calculate Euclidean distance between two points
    double dist(Point<int> p1, Point<int> p2) {
      return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
    }

    // Normalize distances by eye distance (scale invariant)
    final eyeDist = dist(leftEye, rightEye);
    if (eyeDist == 0) return [];

    final features = <double>[];

    // 1. Eye Center to Nose
    final eyeCenter = Point<int>(
      ((leftEye.x + rightEye.x) / 2).round(),
      ((leftEye.y + rightEye.y) / 2).round(),
    );
    features.add(dist(eyeCenter, noseBase) / eyeDist);

    // 2. Nose to Mouth Center
    final mouthCenter = Point<int>(
      ((leftMouth.x + rightMouth.x) / 2).round(),
      ((leftMouth.y + rightMouth.y) / 2).round(),
    );
    features.add(dist(noseBase, mouthCenter) / eyeDist);

    // 3. Mouth Width
    features.add(dist(leftMouth, rightMouth) / eyeDist);

    // 4. Eye Center to Mouth Center
    features.add(dist(eyeCenter, mouthCenter) / eyeDist);

    // 5. Left Eye to Left Mouth
    features.add(dist(leftEye, leftMouth) / eyeDist);

    // 6. Right Eye to Right Mouth
    features.add(dist(rightEye, rightMouth) / eyeDist);

    // 7. Nose to Bottom Mouth
    features.add(dist(noseBase, bottomMouth) / eyeDist);

    // 8. Face Proportions (Bounding Box Width/Height)
    final boundingBox = face.boundingBox;
    features.add(boundingBox.width / boundingBox.height);

    // 9. Cheek to Cheek (if landmarks available - assuming Ear or similar?
    // ML Kit doesn't have cheekbones directly in basic landmarks,
    // but has Left/Right Cheek points in Contours.
    // However, basic landmarks have Left/Right Ear.
    final leftCheek = face.landmarks[FaceLandmarkType.leftCheek]?.position;
    final rightCheek = face.landmarks[FaceLandmarkType.rightCheek]?.position;
    if (leftCheek != null && rightCheek != null) {
      features.add(dist(leftCheek, rightCheek) / eyeDist);
    } else {
      features.add(0.0);
    }

    return features;
  }

  /// Compare two face feature vectors using Euclidean Distance
  /// Returns a similarity score (0.0 to 1.0), where 1.0 is exact match
  double compareFaceFeatures(List<double> features1, List<double> features2) {
    if (features1.length != features2.length || features1.isEmpty) {
      return 0.0;
    }

    double sumSquaredDiff = 0.0;
    for (int i = 0; i < features1.length; i++) {
      sumSquaredDiff += pow(features1[i] - features2[i], 2);
    }

    final distance = sqrt(sumSquaredDiff);

    // Convert distance to similarity score
    // The threshold for a match is usually around distance < 0.2
    // We map 0.0 distance to 100% similarity, and 0.5 distance to 0%

    final similarity = (1.0 - (distance * 2)).clamp(0.0, 1.0) * 100;
    return similarity;
  }

  /// Find best matching face from registered features
  Future<Map<String, dynamic>?> findBestMatch({
    required List<double> capturedFeatures,
    required Map<String, List<double>> registeredFeatures, // studentId -> features
    double threshold = 80.0, // Minimum similarity score (0-100)
  }) async {
    if (capturedFeatures.isEmpty || registeredFeatures.isEmpty) {
      return null;
    }

    double bestScore = 0.0;
    String? bestMatchId;

    registeredFeatures.forEach((studentId, features) {
      final score = compareFaceFeatures(capturedFeatures, features);
      if (score > bestScore) {
        bestScore = score;
        bestMatchId = studentId;
      }
    });

    if (bestScore >= threshold && bestMatchId != null) {
      return {'studentId': bestMatchId, 'confidence': bestScore};
    }

    return null;
  }

  /// Check if image contains a clear face
  Future<bool> hasValidFace(File imageFile) async {
    try {
      final faces = await detectFacesInFile(imageFile);

      if (faces.isEmpty) return false;

      // Check if face is clear enough
      final face = faces.first;
      final boundingBox = face.boundingBox;

      // Face should be at least 100x100 pixels
      if (boundingBox.width < 100 || boundingBox.height < 100) {
        return false;
      }

      // Check if face has good quality (using head euler angles)
      if (face.headEulerAngleY != null && face.headEulerAngleY!.abs() > 30) {
        return false; // Face is turned too much
      }

      if (face.headEulerAngleZ != null && face.headEulerAngleZ!.abs() > 30) {
        return false; // Face is tilted too much
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get face quality score (0-100)
  Future<double> getFaceQualityScore(File imageFile) async {
    try {
      final faces = await detectFacesInFile(imageFile);

      if (faces.isEmpty) return 0.0;

      final face = faces.first;
      double score = 100.0;

      // Reduce score based on face angle
      if (face.headEulerAngleY != null) {
        score -= face.headEulerAngleY!.abs() * 2;
      }

      if (face.headEulerAngleZ != null) {
        score -= face.headEulerAngleZ!.abs() * 2;
      }

      // Reduce score if face is too small
      final boundingBox = face.boundingBox;
      if (boundingBox.width < 150 || boundingBox.height < 150) {
        score -= 20;
      }

      return score.clamp(0.0, 100.0);
    } catch (e) {
      return 0.0;
    }
  }

  /// Dispose the face detector
  Future<void> dispose() async {
    if (_isInitialized) {
      await _faceDetector.close();
      _isInitialized = false;
    }
  }
}
