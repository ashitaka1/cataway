import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viam_camera_app/widgets/connection_status_widget.dart';

void main() {
  group('ConnectionStatusWidget', () {
    testWidgets('shows connected status when isConnected is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConnectionStatusWidget(isConnected: true),
          ),
        ),
      );

      expect(find.text('Connection Status'), findsOneWidget);
      expect(find.text('Connected'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Disconnected'), findsNothing);
      expect(find.byIcon(Icons.error), findsNothing);
    });

    testWidgets('shows disconnected status when isConnected is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConnectionStatusWidget(isConnected: false),
          ),
        ),
      );

      expect(find.text('Connection Status'), findsOneWidget);
      expect(find.text('Disconnected'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Connected'), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('renders as a Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConnectionStatusWidget(isConnected: true),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });
  });
}