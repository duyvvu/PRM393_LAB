import 'package:flutter_test/flutter_test.dart';
import 'package:lab8_networking/models/post.dart';
import 'package:lab8_networking/main.dart';

void main() {
  group('Post Model Unit Tests', () {
    test('Post.fromJson parses JSON correctly', () {
      final jsonMap = {
        'userId': 1,
        'id': 101,
        'title': 'Test Title',
        'body': 'Test Body Content',
      };

      final post = Post.fromJson(jsonMap);

      expect(post.id, 101);
      expect(post.userId, 1);
      expect(post.title, 'Test Title');
      expect(post.body, 'Test Body Content');
    });

    test('Post.toJson serializes correctly', () {
      final post = Post(
        id: 101,
        userId: 1,
        title: 'Test Title',
        body: 'Test Body Content',
      );

      final json = post.toJson();

      expect(json['id'], 101);
      expect(json['userId'], 1);
      expect(json['title'], 'Test Title');
      expect(json['body'], 'Test Body Content');
    });
  });

  group('Widget Smoke Test', () {
    testWidgets('App loads and displays PostListScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('API-Powered Post List'), findsOneWidget);
    });
  });
}
