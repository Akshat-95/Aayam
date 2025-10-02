import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizen_issue_app/screens/my_complaints_screen.dart';

void main() {
  testWidgets('MyComplaintsScreen shows title and a complaint', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MyComplaintsScreen()));

    // Verify the app bar title
    expect(find.text('My Complaints'), findsOneWidget);

    // Wait for widgets to render
    await tester.pumpAndSettle();

    // Should find the 'All' chip
    expect(find.text('All'), findsOneWidget);

    // Expect at least one complaint tile (one of the dummy titles)
    expect(find.text('Pothole on Main Street'), findsOneWidget);
  });
}
