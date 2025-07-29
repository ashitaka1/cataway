import 'package:viam_sdk/viam_sdk.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class RobotService {
  RobotClient? _robot;
  Camera? _camera;

  RobotClient? get robot => _robot;
  Camera? get camera => _camera;
  bool get isConnected => _robot != null;

  Future<void> connectToRobot({
    required String location,
    required String apiKeyId,
    required String apiKey,
  }) async {
    try {
      _robot = await RobotClient.atAddress(
        location,
        RobotClientOptions.withApiKey(apiKeyId, apiKey),
      );
      debugPrint('Successfully connected to robot');
    } catch (e) {
      debugPrint('Connection failed: $e');
      rethrow;
    }
  }

  Future<void> initializeCamera(String cameraName) async {
    if (_robot == null) {
      throw Exception('Robot is not connected');
    }

    try {
      _camera = Camera.fromRobot(_robot!, cameraName);
      debugPrint('Camera $cameraName initialized');
    } catch (e) {
      debugPrint('Failed to get camera: $e');
      rethrow;
    }
  }

  Future<Uint8List> captureImage() async {
    if (_camera == null) {
      throw Exception('Camera is not initialized');
    }

    try {
      debugPrint('Fetching image from camera');
      final viamImage = await _camera!.image();
      final imageBytes = Uint8List.fromList(viamImage.raw);
      debugPrint('Image fetched successfully, ${imageBytes.length} bytes');
      return imageBytes;
    } catch (e) {
      debugPrint('Image fetch failed: $e');
      rethrow;
    }
  }

  void disconnect() {
    _robot?.close();
    _robot = null;
    _camera = null;
    debugPrint('Disconnected from robot');
  }
}