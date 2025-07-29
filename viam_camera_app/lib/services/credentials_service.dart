import 'package:shared_preferences/shared_preferences.dart';

class CredentialsService {
  static const String _locationKey = 'location';
  static const String _apiKeyKey = 'apiKey';
  static const String _apiKeyIdKey = 'apiKeyId';
  static const String _cameraNameKey = 'cameraName';

  static Future<Map<String, String>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'location': prefs.getString(_locationKey) ?? '',
      'apiKey': prefs.getString(_apiKeyKey) ?? '',
      'apiKeyId': prefs.getString(_apiKeyIdKey) ?? '',
      'cameraName': prefs.getString(_cameraNameKey) ?? 'webcam',
    };
  }

  static Future<void> saveCredentials({
    required String location,
    required String apiKey,
    required String apiKeyId,
    required String cameraName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_locationKey, location),
      prefs.setString(_apiKeyKey, apiKey),
      prefs.setString(_apiKeyIdKey, apiKeyId),
      prefs.setString(_cameraNameKey, cameraName),
    ]);
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}