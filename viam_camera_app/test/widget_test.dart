import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:viam_camera_app/main.dart';

void main() {
  group('ViamCameraApp Integration Tests', () {
    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('app initializes with correct title and structure', (WidgetTester tester) async {
      await tester.pumpWidget(const ViamCameraApp());
      await tester.pumpAndSettle();

      // Verify title
      expect(find.text('Viam Camera Stream'), findsOneWidget);
      
      // Verify connection status widget
      expect(find.text('Connection Status'), findsOneWidget);
      expect(find.text('Disconnected'), findsOneWidget);
      
      // Verify connection form is shown when not connected
      expect(find.text('Machine Address'), findsOneWidget);
      expect(find.text('API Key ID'), findsOneWidget);
      expect(find.text('API Key'), findsOneWidget);
      expect(find.text('Camera Name'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('displays connection form when not connected', (WidgetTester tester) async {
      await tester.pumpWidget(const ViamCameraApp());
      await tester.pumpAndSettle();

      // Connection form should be visible
      expect(find.byType(TextField), findsNWidgets(4)); // 4 text fields
      expect(find.text('Connect'), findsOneWidget);
      
      // Camera controls should not be visible
      expect(find.text('Capture Image'), findsNothing);
    });

    testWidgets('loads saved credentials on startup', (WidgetTester tester) async {
      // Set up saved credentials
      SharedPreferences.setMockInitialValues({
        'location': 'test.robot.com',
        'apiKey': 'test-key',
        'apiKeyId': 'test-key-id',
        'cameraName': 'test-camera',
      });

      await tester.pumpWidget(const ViamCameraApp());
      await tester.pumpAndSettle();

      // Verify credentials are loaded into text fields
      expect(find.text('test.robot.com'), findsOneWidget);
      expect(find.text('test-key-id'), findsOneWidget);
      expect(find.text('test-camera'), findsOneWidget);
      // Note: API key text is obscured, so we can't verify its display
    });

    testWidgets('clear button clears form fields', (WidgetTester tester) async {
      // Set up saved credentials
      SharedPreferences.setMockInitialValues({
        'location': 'test.robot.com',
        'apiKeyId': 'test-key-id',
        'cameraName': 'test-camera',
      });

      await tester.pumpWidget(const ViamCameraApp());
      await tester.pumpAndSettle();

      // Verify credentials are loaded
      expect(find.text('test.robot.com'), findsOneWidget);
      
      // Tap clear button
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      // Verify fields are cleared (except camera name which defaults to 'webcam')
      expect(find.text('test.robot.com'), findsNothing);
      expect(find.text('webcam'), findsOneWidget);
    });

    testWidgets('app structure uses widget composition', (WidgetTester tester) async {
      await tester.pumpWidget(const ViamCameraApp());
      await tester.pumpAndSettle();

      // Verify that our custom widgets are being used
      expect(find.byType(Card), findsNWidgets(2)); // Connection status + form
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
