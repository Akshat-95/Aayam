// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:citizen_issue_app/main.dart';

void main() {
  testWidgets('App builds and shows feature card', (WidgetTester tester) async {
    await tester.pumpWidget(const CitizenIssueApp());
    // Avoid pumpAndSettle because platform plugins (location/geolocator)
    // may schedule native async work that doesn't complete in tests.
    // A single pump is sufficient to build the initial UI for this smoke test.
    await tester.pump();

    // Expect one of the feature cards to be present
    expect(find.text('Report Issue'), findsOneWidget);
  });
}
