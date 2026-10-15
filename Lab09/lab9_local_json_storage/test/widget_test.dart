import 'package:flutter_test/flutter_test.dart';
import 'package:lab9_local_json_storage/main.dart';

void main() {
  testWidgets('Lab9App navigation hub smoke test', (WidgetTester tester) async {
    // Build the app and pump initial frame
    await tester.pumpWidget(const Lab9App());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Dashboard elements exist
    expect(find.text('PRM393 - Lab 09'), findsOneWidget);
    expect(find.text('Working with Local JSON Storage'), findsOneWidget);

    // Verify NavigationBar destinations exist
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('Lab 9.1'), findsOneWidget);
    expect(find.text('Lab 9.2'), findsOneWidget);
    expect(find.text('Lab 9.3'), findsOneWidget);

    // Verify tab switching to Lab 9.1
    await tester.tap(find.text('Lab 9.1'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Lab 9.1 screen title is displayed
    expect(find.text('Lab 9.1 - Read Assets JSON'), findsOneWidget);

    // Verify tab switching to Lab 9.2
    await tester.tap(find.text('Lab 9.2'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Lab 9.2 screen title is displayed
    expect(find.text('Lab 9.2 - Local Storage JSON'), findsOneWidget);

    // Verify tab switching to Lab 9.3
    await tester.tap(find.text('Lab 9.3'));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Lab 9.3 screen title is displayed
    expect(find.text('Lab 9.3 - JSON CRUD Database'), findsOneWidget);
  });
}
