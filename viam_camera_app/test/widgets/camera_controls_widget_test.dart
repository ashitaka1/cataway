import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viam_camera_app/widgets/camera_controls_widget.dart';

void main() {
  group('CameraControlsWidget', () {
    testWidgets('displays camera name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CameraControlsWidget(
              cameraName: 'test-camera',
              isLoading: false,
              onCaptureImage: null,
            ),
          ),
        ),
      );

      expect(find.text('Camera: test-camera'), findsOneWidget);
    });

    testWidgets('shows capture image button when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CameraControlsWidget(
              cameraName: 'webcam',
              isLoading: false,
              onCaptureImage: null,
            ),
          ),
        ),
      );

      expect(find.text('Capture Image'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CameraControlsWidget(
              cameraName: 'webcam',
              isLoading: true,
              onCaptureImage: null,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('calls onCaptureImage when button is tapped', (WidgetTester tester) async {
      bool captureCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CameraControlsWidget(
              cameraName: 'webcam',
              isLoading: false,
              onCaptureImage: () => captureCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(captureCalled, isTrue);
    });

    testWidgets('button is disabled when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CameraControlsWidget(
              cameraName: 'webcam',
              isLoading: true,
              onCaptureImage: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('renders as a Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CameraControlsWidget(
              cameraName: 'webcam',
              isLoading: false,
              onCaptureImage: null,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });
  });
}