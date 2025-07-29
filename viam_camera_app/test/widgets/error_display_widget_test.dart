import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viam_camera_app/widgets/error_display_widget.dart';

void main() {
  group('ErrorDisplayWidget', () {
    testWidgets('displays error message', (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(errorMessage: errorMessage),
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('renders as a Card widget with correct color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(errorMessage: 'Test error'),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, equals(Colors.red[50]));
    });

    testWidgets('error message is selectable', (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(errorMessage: errorMessage),
          ),
        ),
      );

      expect(find.byType(SelectableText), findsOneWidget);
      
      final selectableText = tester.widget<SelectableText>(
        find.byType(SelectableText),
      );
      expect(selectableText.data, equals(errorMessage));
    });

    testWidgets('error text has red color styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(errorMessage: 'Test error'),
          ),
        ),
      );

      final selectableText = tester.widget<SelectableText>(
        find.byType(SelectableText),
      );
      expect(selectableText.style?.color, equals(Colors.red));
    });

    testWidgets('error icon has red color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(errorMessage: 'Test error'),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.error));
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('displays long error messages correctly', (WidgetTester tester) async {
      const longErrorMessage = 'This is a very long error message that should be displayed properly in the error widget without any truncation or formatting issues.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(errorMessage: longErrorMessage),
          ),
        ),
      );

      expect(find.text(longErrorMessage), findsOneWidget);
    });
  });
}