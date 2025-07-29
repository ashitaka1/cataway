import 'package:flutter_test/flutter_test.dart';
import 'package:viam_camera_app/services/robot_service.dart';

void main() {
  group('RobotService', () {
    late RobotService robotService;

    setUp(() {
      robotService = RobotService();
    });

    tearDown(() {
      robotService.disconnect();
    });

    test('initial state is not connected', () {
      expect(robotService.isConnected, isFalse);
      expect(robotService.robot, isNull);
      expect(robotService.camera, isNull);
    });

    test('disconnect sets robot and camera to null', () {
      robotService.disconnect();
      
      expect(robotService.isConnected, isFalse);
      expect(robotService.robot, isNull);
      expect(robotService.camera, isNull);
    });

    test('initializeCamera throws when robot is not connected', () async {
      expect(
        () => robotService.initializeCamera('webcam'),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Robot is not connected'),
        )),
      );
    });

    test('captureImage throws when camera is not initialized', () async {
      expect(
        () => robotService.captureImage(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Camera is not initialized'),
        )),
      );
    });

    // Note: We can't easily test actual robot connection without mocking
    // the Viam SDK, which would require more complex test setup.
    // These tests focus on the service's state management logic.

    test('multiple disconnects are safe', () {
      robotService.disconnect();
      robotService.disconnect();
      robotService.disconnect();
      
      expect(robotService.isConnected, isFalse);
      expect(robotService.robot, isNull);
      expect(robotService.camera, isNull);
    });

    test('service maintains state correctly', () {
      // Initial state
      expect(robotService.isConnected, isFalse);
      
      // After disconnect (should still be false)
      robotService.disconnect();
      expect(robotService.isConnected, isFalse);
    });
  });
}