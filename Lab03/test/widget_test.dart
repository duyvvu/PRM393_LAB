import 'package:flutter_test/flutter_test.dart';
import 'package:lab03/main.dart';

void main() {
  testWidgets('Lab 03 home page loads correctly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AdvancedDartApp());

    expect(find.text('PRM393 - Lab 03: Advanced Dart'), findsOneWidget);
    expect(find.text('Run All 5 Exercises'), findsOneWidget);
    expect(find.text('Exercise 1: Product Model & Repository'), findsOneWidget);
  });
}
