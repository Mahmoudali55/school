import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Initialize camera
  Future<bool> initializeCamera({
    ResolutionPreset resolution = ResolutionPreset.high,
    CameraLensDirection direction = CameraLensDirection.front,
  }) async {
    try {
      // Check permission first
      final hasPermission = await hasCameraPermission();
      if (!hasPermission) {
        final granted = await requestCameraPermission();
        if (!granted) {
          return false;
        }
      }

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        return false;
      }

      // Select camera based on direction
      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == direction,
        orElse: () => _cameras!.first,
      );

      // Create controller
      _controller = CameraController(
        camera,
        resolution,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      // Initialize controller
      await _controller!.initialize();
      _isInitialized = true;

      return true;
    } catch (e) {
      _isInitialized = false;
      return false;
    }
  }

  /// Switch camera (front/back)
  Future<bool> switchCamera() async {
    if (_controller == null || _cameras == null || _cameras!.length < 2) {
      return false;
    }

    try {
      final currentDirection = _controller!.description.lensDirection;
      final newDirection = currentDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;

      await disposeCamera();

      return await initializeCamera(direction: newDirection);
    } catch (e) {
      return false;
    }
  }

  /// Capture image
  Future<File?> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      final XFile image = await _controller!.takePicture();
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  /// Start image stream for real-time processing
  Future<void> startImageStream(Function(CameraImage image) onImage) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _controller!.startImageStream(onImage);
    } catch (e) {
      // Handle error
    }
  }

  /// Stop image stream
  Future<void> stopImageStream() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _controller!.stopImageStream();
    } catch (e) {
      // Handle error
    }
  }

  /// Set flash mode
  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _controller!.setFlashMode(mode);
    } catch (e) {
      // Handle error
    }
  }

  /// Set zoom level
  Future<void> setZoomLevel(double zoom) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final maxZoom = await _controller!.getMaxZoomLevel();
      final minZoom = await _controller!.getMinZoomLevel();
      final clampedZoom = zoom.clamp(minZoom, maxZoom);
      await _controller!.setZoomLevel(clampedZoom);
    } catch (e) {
      // Handle error
    }
  }

  /// Get available cameras
  Future<List<CameraDescription>> getAvailableCameras() async {
    if (_cameras != null) {
      return _cameras!;
    }

    _cameras = await availableCameras();
    return _cameras!;
  }

  /// Dispose camera controller
  Future<void> disposeCamera() async {
    if (_controller != null) {
      try {
        if (_controller!.value.isStreamingImages) {
          await _controller!.stopImageStream();
        }
        await _controller!.dispose();
      } catch (e) {
        // Handle error
      } finally {
        _controller = null;
        _isInitialized = false;
      }
    }
  }

  /// Pause camera
  Future<void> pauseCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.pausePreview();
      } catch (e) {
        // Handle error
      }
    }
  }

  /// Resume camera
  Future<void> resumeCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.resumePreview();
      } catch (e) {
        // Handle error
      }
    }
  }

  /// Check if camera is available
  Future<bool> isCameraAvailable() async {
    try {
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get camera resolution
  Size? getCameraResolution() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    return Size(_controller!.value.previewSize!.height, _controller!.value.previewSize!.width);
  }
}
