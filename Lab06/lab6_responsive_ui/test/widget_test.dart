import 'package:flutter_test/flutter_test.dart';

import 'package:lab6_responsive_ui/main.dart';

void main() {
  testWidgets('App renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const ResponsiveMovieApp());
    expect(find.text('Find a Movie'), findsOneWidget);
  });
}
