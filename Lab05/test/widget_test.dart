import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab05/main.dart';

void main() {
  testWidgets('MovieApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MovieApp());

    // Verify that Movie Catalog title is present.
    expect(find.text('Movie Catalog'), findsOneWidget);
    expect(find.text('The Dark Knight'), findsOneWidget);
  });
}
