import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viam_camera_app/widgets/image_display_widget.dart';
import 'dart:typed_data';

void main() {
  group('ImageDisplayWidget', () {
    testWidgets('shows placeholder when no image data is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageDisplayWidget(),
          ),
        ),
      );

      expect(find.text('No image captured yet'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows placeholder when imageData is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageDisplayWidget(imageData: null),
          ),
        ),
      );

      expect(find.text('No image captured yet'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('displays image when imageData is provided', (WidgetTester tester) async {
      // Create a simple test image data (1x1 transparent PNG)
      final testImageData = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
        0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
        0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageDisplayWidget(imageData: testImageData),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('No image captured yet'), findsNothing);
      expect(find.byIcon(Icons.camera_alt), findsNothing);
    });

    testWidgets('renders as a Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageDisplayWidget(),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('placeholder has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageDisplayWidget(),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.camera_alt));
      expect(icon.size, equals(48));
      expect(icon.color, equals(Colors.grey));
    });

    testWidgets('container has correct constraints', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageDisplayWidget(),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byWidgetPredicate((widget) => 
          widget is Container && widget.constraints != null),
      );
      expect(container.constraints!.minHeight, equals(200));
      expect(container.constraints!.maxHeight, equals(500));
    });
  });
}