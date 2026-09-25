import 'package:flutter_test/flutter_test.dart';
import 'package:lab03/lab03_logic.dart';

void main() {
  group('Exercise 1: ProductRepository Test', () {
    test('ProductRepository emits live updates and returns all products', () async {
      final repo = ProductRepository();
      final List<Product> streamEmitted = [];

      final subscription = repo.liveAdded().listen(streamEmitted.add);

      repo.addProduct(Product(id: 'P01', name: 'MacBook Pro', price: 2999.0));
      repo.addProduct(Product(id: 'P02', name: 'iPhone 16', price: 999.0));

      await Future.delayed(const Duration(milliseconds: 50));

      expect(streamEmitted.length, equals(2));
      expect(streamEmitted[0].id, equals('P01'));

      final all = await repo.getAll();
      expect(all.length, equals(2));

      await subscription.cancel();
      repo.dispose();
    });
  });

  group('Exercise 2: User Model & Repository Test', () {
    test('User fromJson and toJson serialization', () {
      final jsonMap = {'name': 'Alice Smith', 'email': 'alice@example.com'};
      final user = User.fromJson(jsonMap);

      expect(user.name, equals('Alice Smith'));
      expect(user.email, equals('alice@example.com'));
      expect(user.toJson(), equals(jsonMap));
    });

    test('UserRepository fetchUsers parses mock API JSON', () async {
      final repo = UserRepository();
      final users = await repo.fetchUsers();

      expect(users.length, equals(3));
      expect(users[0].name, equals('Nguyen Van A'));
    });
  });

  group('Exercise 4: Stream Transformation Test', () {
    test('Transforms stream by squaring and filtering even numbers', () async {
      final input = Stream.fromIterable([1, 2, 3, 4, 5]);
      final transformed = input
          .map((n) => n * n)
          .where((sq) => sq % 2 == 0);

      final results = await transformed.toList();
      // 1^2=1 (odd), 2^2=4 (even), 3^2=9 (odd), 4^2=16 (even), 5^2=25 (odd)
      expect(results, equals([4, 16]));
    });
  });

  group('Exercise 5: Factory Constructor & Singleton Test', () {
    test('Settings factory returns cached singleton instance', () {
      Settings.resetForTesting();
      final s1 = Settings(theme: 'Light Mode', refreshInterval: 30);
      final s2 = Settings();

      expect(identical(s1, s2), isTrue);
      expect(s2.theme, equals('Light Mode'));
      expect(s2.refreshInterval, equals(30));
    });
  });
}
