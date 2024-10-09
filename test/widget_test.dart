import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocr_app/text_recognition_screen.dart'; // Import the TextRecognitionScreen

void main() {
  testWidgets('Text recognition button test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: TextRecognitionScreen())); // Use the new TextRecognitionScreen

    // Find the button that starts text recognition
    final Finder recognitionButton = find.byType(FloatingActionButton);

    // Verify that the button exists
    expect(recognitionButton, findsOneWidget);

    // Tap the recognition button and trigger a frame
    await tester.tap(recognitionButton);
    await tester.pump();

    // You might want to update this expectation based on your app's logic
    // Since the recognizer won't actually run in a test environment,
    // consider adding a mock or a way to simulate the behavior.
    // For example, checking for a specific text if your logic allows it.
    // Here, we'll just expect that the button still exists after tapping.
    expect(recognitionButton, findsOneWidget);
  });
}
