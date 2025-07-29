import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viam_camera_app/services/credentials_service.dart';

void main() {
  group('CredentialsService', () {
    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('loadCredentials returns default values when no credentials are saved', () async {
      final credentials = await CredentialsService.loadCredentials();

      expect(credentials['location'], equals(''));
      expect(credentials['apiKey'], equals(''));
      expect(credentials['apiKeyId'], equals(''));
      expect(credentials['cameraName'], equals('webcam'));
    });

    test('saveCredentials stores credentials correctly', () async {
      const testLocation = 'test.robot.com';
      const testApiKey = 'test-api-key';
      const testApiKeyId = 'test-api-key-id';
      const testCameraName = 'test-camera';

      await CredentialsService.saveCredentials(
        location: testLocation,
        apiKey: testApiKey,
        apiKeyId: testApiKeyId,
        cameraName: testCameraName,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('location'), equals(testLocation));
      expect(prefs.getString('apiKey'), equals(testApiKey));
      expect(prefs.getString('apiKeyId'), equals(testApiKeyId));
      expect(prefs.getString('cameraName'), equals(testCameraName));
    });

    test('loadCredentials returns saved credentials', () async {
      const testLocation = 'saved.robot.com';
      const testApiKey = 'saved-api-key';
      const testApiKeyId = 'saved-api-key-id';
      const testCameraName = 'saved-camera';

      // First save credentials
      await CredentialsService.saveCredentials(
        location: testLocation,
        apiKey: testApiKey,
        apiKeyId: testApiKeyId,
        cameraName: testCameraName,
      );

      // Then load them
      final credentials = await CredentialsService.loadCredentials();

      expect(credentials['location'], equals(testLocation));
      expect(credentials['apiKey'], equals(testApiKey));
      expect(credentials['apiKeyId'], equals(testApiKeyId));
      expect(credentials['cameraName'], equals(testCameraName));
    });

    test('clearCredentials removes all saved credentials', () async {
      // First save some credentials
      await CredentialsService.saveCredentials(
        location: 'test.robot.com',
        apiKey: 'test-api-key',
        apiKeyId: 'test-api-key-id',
        cameraName: 'test-camera',
      );

      // Verify they are saved
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('location'), isNotNull);

      // Clear credentials
      await CredentialsService.clearCredentials();

      // Verify they are cleared
      final clearedPrefs = await SharedPreferences.getInstance();
      expect(clearedPrefs.getString('location'), isNull);
      expect(clearedPrefs.getString('apiKey'), isNull);
      expect(clearedPrefs.getString('apiKeyId'), isNull);
      expect(clearedPrefs.getString('cameraName'), isNull);
    });

    test('loadCredentials after clearing returns default values', () async {
      // Save credentials
      await CredentialsService.saveCredentials(
        location: 'test.robot.com',
        apiKey: 'test-api-key',
        apiKeyId: 'test-api-key-id',
        cameraName: 'test-camera',
      );

      // Clear credentials
      await CredentialsService.clearCredentials();

      // Load credentials after clearing
      final credentials = await CredentialsService.loadCredentials();

      expect(credentials['location'], equals(''));
      expect(credentials['apiKey'], equals(''));
      expect(credentials['apiKeyId'], equals(''));
      expect(credentials['cameraName'], equals('webcam'));
    });

    test('saveCredentials with empty values stores empty strings', () async {
      await CredentialsService.saveCredentials(
        location: '',
        apiKey: '',
        apiKeyId: '',
        cameraName: '',
      );

      final credentials = await CredentialsService.loadCredentials();

      expect(credentials['location'], equals(''));
      expect(credentials['apiKey'], equals(''));
      expect(credentials['apiKeyId'], equals(''));
      expect(credentials['cameraName'], equals(''));
    });
  });
}