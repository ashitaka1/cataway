import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viam_camera_app/widgets/connection_form_widget.dart';

void main() {
  group('ConnectionFormWidget', () {
    late TextEditingController locationController;
    late TextEditingController apiKeyController;
    late TextEditingController apiKeyIdController;
    late TextEditingController cameraNameController;

    setUp(() {
      locationController = TextEditingController();
      apiKeyController = TextEditingController();
      apiKeyIdController = TextEditingController();
      cameraNameController = TextEditingController();
    });

    tearDown(() {
      locationController.dispose();
      apiKeyController.dispose();
      apiKeyIdController.dispose();
      cameraNameController.dispose();
    });

    testWidgets('renders all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionFormWidget(
              locationController: locationController,
              apiKeyController: apiKeyController,
              apiKeyIdController: apiKeyIdController,
              cameraNameController: cameraNameController,
              isLoading: false,
              onConnect: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.text('Machine Address'), findsOneWidget);
      expect(find.text('API Key ID'), findsOneWidget);
      expect(find.text('API Key'), findsOneWidget);
      expect(find.text('Camera Name'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionFormWidget(
              locationController: locationController,
              apiKeyController: apiKeyController,
              apiKeyIdController: apiKeyIdController,
              cameraNameController: cameraNameController,
              isLoading: true,
              onConnect: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Connect'), findsNothing);
    });

    testWidgets('calls onConnect when connect button is tapped', (WidgetTester tester) async {
      bool connectCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionFormWidget(
              locationController: locationController,
              apiKeyController: apiKeyController,
              apiKeyIdController: apiKeyIdController,
              cameraNameController: cameraNameController,
              isLoading: false,
              onConnect: () => connectCalled = true,
              onClear: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Connect'));
      await tester.pump();

      expect(connectCalled, isTrue);
    });

    testWidgets('calls onClear when clear button is tapped', (WidgetTester tester) async {
      bool clearCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionFormWidget(
              locationController: locationController,
              apiKeyController: apiKeyController,
              apiKeyIdController: apiKeyIdController,
              cameraNameController: cameraNameController,
              isLoading: false,
              onConnect: () {},
              onClear: () => clearCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clear'));
      await tester.pump();

      expect(clearCalled, isTrue);
    });

    testWidgets('connect button is disabled when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionFormWidget(
              locationController: locationController,
              apiKeyController: apiKeyController,
              apiKeyIdController: apiKeyIdController,
              cameraNameController: cameraNameController,
              isLoading: true,
              onConnect: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      final connectButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(connectButton.onPressed, isNull);
    });

    testWidgets('API key field obscures text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectionFormWidget(
              locationController: locationController,
              apiKeyController: apiKeyController,
              apiKeyIdController: apiKeyIdController,
              cameraNameController: cameraNameController,
              isLoading: false,
              onConnect: () {},
              onClear: () {},
            ),
          ),
        ),
      );

      final apiKeyField = tester.widget<TextField>(
        find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'API Key'),
      );
      expect(apiKeyField.obscureText, isTrue);
    });
  });
}