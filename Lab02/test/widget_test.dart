import 'package:flutter_test/flutter_test.dart';
import 'package:lab02/main.dart';

void main() {
  testWidgets('Lab 02 home page loads correctly smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DartEssentialsApp());

    // Verify header and action elements are present
    expect(find.text('PRM393 - Lab 02: Dart Essentials'), findsOneWidget);
    expect(find.text('Run All Exercises'), findsOneWidget);
    expect(find.text('Exercise 1: Basic Syntax & Types'), findsOneWidget);
  });
}
