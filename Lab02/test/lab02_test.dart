import 'package:flutter_test/flutter_test.dart';
import 'package:lab02/lab02_logic.dart';

void main() {
  group('Exercise 3 Functions Test', () {
    test('calculateCircleArea returns correct area', () {
      expect(calculateCircleArea(3.0), closeTo(28.27, 0.01));
    });

    test('squareNumber calculates correctly', () {
      expect(squareNumber(9), equals(81));
    });

    test('isEven checks even numbers', () {
      expect(isEven(14), isTrue);
      expect(isEven(15), isFalse);
    });
  });

  group('Exercise 4 OOP Test', () {
    test('Car standard and named constructors work', () {
      Car sedan = Car('Toyota Camry', 110.0);
      expect(sedan.brand, equals('Toyota Camry'));
      expect(sedan.speed, equals(110.0));

      Car stationary = Car.stationary('Honda Civic');
      expect(stationary.brand, equals('Honda Civic'));
      expect(stationary.speed, equals(0.0));
    });

    test('ElectricCar inheritance and overrides', () {
      ElectricCar tesla = ElectricCar('Tesla Model 3', 140.0, 75);
      expect(tesla.brand, equals('Tesla Model 3'));
      expect(tesla.speed, equals(140.0));
      expect(tesla.batteryCapacity, equals(75));
      expect(tesla.getInfo(), contains('Battery: 75 kWh'));
      expect(tesla.getDrivingStatus(), contains('powered by a 75 kWh electric battery!'));
    });
  });

  group('Exercise 5 Async & Streams Test', () {
    test('fetchUserDataAsync returns JSON payload', () async {
      String data = await fetchUserDataAsync((_) {});
      expect(data, contains('prm393_developer'));
    });

    test('generateCountStream yields numbers 1 to 3', () async {
      List<int> results = await generateCountStream(3, delayMs: 10).toList();
      expect(results, equals([1, 2, 3]));
    });
  });
}
