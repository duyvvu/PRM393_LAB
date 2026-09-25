import 'dart:async';

/// ============================================================================
/// PRM393 - Mobile Programming
/// Lab 02: Dart Essentials Practice Lab
/// Core Logic & Class Definitions
/// ============================================================================

// Type definition for logger callback
typedef OutputLogger = void Function(String message);

// Default stdout logger
void _defaultPrint(String message) => print(message);

// ============================================================================
// EXERCISE 1: Basic Syntax & Data Types
// ============================================================================
void executeExercise1([OutputLogger log = _defaultPrint]) {
  log('--------------------------------------------------------------------');
  log('>>> EXERCISE 1: Basic Syntax & Data Types');
  log('--------------------------------------------------------------------');

  // 1. Declare variables using core data types
  int studentAge = 21;                    // Integer type
  double gpa = 3.85;                     // 64-bit floating point number
  String studentName = 'Nguyen Van An';  // UTF-16 code units string
  bool isEnrolled = true;                // Boolean type (true/false)

  // 2. Use print() and string interpolation ($var)
  log('Student Name       : $studentName');
  log('Student Age        : $studentAge');
  log('GPA                : $gpa');
  log('Enrolled in Course : $isEnrolled');

  // 3. String expression interpolation (${expr})
  log('Age Next Year      : ${studentAge + 1}');
  log('Academic Status    : ${gpa >= 3.6 ? "Honors Distinction" : "Good Standing"}');
  log('Greeting Banner    : ${studentName.toUpperCase()} - PRM393\n');
}

// ============================================================================
// EXERCISE 2: Collections & Operators
// ============================================================================
void executeExercise2([OutputLogger log = _defaultPrint]) {
  log('--------------------------------------------------------------------');
  log('>>> EXERCISE 2: Collections & Operators');
  log('--------------------------------------------------------------------');

  // 1. List of integers
  List<int> numbers = [10, 20, 30, 40, 50];
  log('Initial List          : $numbers');

  // List indexing, add(), remove()
  log('Element at index 0    : ${numbers[0]}');
  log('Element at index 2    : ${numbers[2]}');
  numbers.add(60);
  log('After numbers.add(60) : $numbers');
  numbers.remove(20);
  log('After numbers.remove(20): $numbers');

  // 2. Operators (+, -, ==, &&, ? :)
  int a = 15;
  int b = 4;
  log('\n--- Operators Demo ---');
  log('Arithmetic + : $a + $b = ${a + b}');
  log('Arithmetic - : $a - $b = ${a - b}');
  log('Arithmetic * : $a * $b = ${a * b}');
  log('Arithmetic / : $a / $b = ${a / b}');
  log('Integer div ~/ : $a ~/ $b = ${a ~/ b}');
  log('Modulus %    : $a % $b = ${a % b}');

  // Comparison & Logical operators
  log('Equality ==  : ($a == $b) -> ${a == b}');
  log('Inequality !=: ($a != $b) -> ${a != b}');
  log('Logical &&   : ($a > 10 && $b < 5)  -> ${(a > 10) && (b < 5)}');
  log('Logical ||   : ($a < 10 || $b == 4) -> ${(a < 10) || (b == 4)}');

  // Ternary operator (? :)
  String parity = (a % 2 == 0) ? 'Even' : 'Odd';
  log('Ternary (? :): $a is $parity');

  // 3. Set (unique values collection)
  Set<String> skills = {'Dart', 'Flutter', 'Firebase'};
  log('\n--- Set (Unique Elements) ---');
  log('Initial Set: $skills');
  bool addedDuplicate = skills.add('Dart');
  log('Attempting to add duplicate "Dart": added = $addedDuplicate');
  log('Set elements (duplicates discarded): $skills');
  skills.add('SQLite');
  skills.remove('Firebase');
  log('After add(SQLite) & remove(Firebase): $skills');
  log('Does skills contain "Flutter"? : ${skills.contains("Flutter")}');

  // 4. Map (key-value collection)
  Map<String, dynamic> studentProfile = {
    'id': 'SE160001',
    'name': 'Tran Thi Mai',
    'semester': 5,
    'passed': true,
  };
  log('\n--- Map (Key-Value Pairs) ---');
  log('Initial Map: $studentProfile');
  log('Access name by key studentProfile["name"]: ${studentProfile["name"]}');

  // Adding and removing keys
  studentProfile['major'] = 'Software Engineering';
  studentProfile['semester'] = 6;
  studentProfile.remove('passed');
  log('Updated Map: $studentProfile\n');
}

// ============================================================================
// EXERCISE 3: Control Flow & Functions
// ============================================================================
void executeExercise3([OutputLogger log = _defaultPrint]) {
  log('--------------------------------------------------------------------');
  log('>>> EXERCISE 3: Control Flow & Functions');
  log('--------------------------------------------------------------------');

  // 1. if/else block to check score
  double score = 84.5;
  String letterGrade;
  String feedback;

  if (score >= 90) {
    letterGrade = 'A';
    feedback = 'Excellent performance!';
  } else if (score >= 80) {
    letterGrade = 'B';
    feedback = 'Very good job!';
  } else if (score >= 65) {
    letterGrade = 'C';
    feedback = 'Good, keep improving!';
  } else if (score >= 50) {
    letterGrade = 'D';
    feedback = 'Passed, needs more effort.';
  } else {
    letterGrade = 'F';
    feedback = 'Failed, please retake the test.';
  }
  log('Score: $score => Grade $letterGrade: $feedback');

  // 2. switch case for day of the week
  int dayOfWeek = 4;
  String dayName;
  switch (dayOfWeek) {
    case 1:
      dayName = 'Monday - Start of the work week';
      break;
    case 2:
      dayName = 'Tuesday - Coding day';
      break;
    case 3:
      dayName = 'Wednesday - Mid-week progress';
      break;
    case 4:
      dayName = 'Thursday - PRM393 Lab practice';
      break;
    case 5:
      dayName = 'Friday - Final sprint & review';
      break;
    case 6:
      dayName = 'Saturday - Weekend project time';
      break;
    case 7:
      dayName = 'Sunday - Rest and recharge';
      break;
    default:
      dayName = 'Invalid day of week';
  }
  log('Day $dayOfWeek: $dayName');

  // 3. Loops through a collection: for, for-in, forEach()
  List<String> frameworks = ['Flutter', 'React Native', 'Android Native', 'SwiftUI'];

  log('\nLoop 1: Standard for loop:');
  for (int i = 0; i < frameworks.length; i++) {
    log('  [$i] => ${frameworks[i]}');
  }

  log('\nLoop 2: for-in loop:');
  for (final framework in frameworks) {
    log('  Framework: $framework');
  }

  log('\nLoop 3: forEach() with lambda:');
  frameworks.forEach((item) => log('  Item via forEach: $item'));

  // 4. Functions: Normal syntax and Arrow syntax
  log('\n--- Function Demonstration ---');
  double circleArea = calculateCircleArea(3.0);
  log('Circle area (radius = 3.0) via normal function: ${circleArea.toStringAsFixed(2)}');

  int squareVal = squareNumber(9);
  log('Square of 9 via arrow function: $squareVal');

  bool evenCheck = isEven(14);
  log('Is 14 even? : $evenCheck\n');
}

// Normal syntax function
double calculateCircleArea(double radius) {
  const double pi = 3.141592653589793;
  return pi * radius * radius;
}

// Arrow syntax functions
int squareNumber(int x) => x * x;
bool isEven(int n) => n % 2 == 0;

// ============================================================================
// EXERCISE 4: Intro to OOP
// ============================================================================

// Base class: Car
class Car {
  String brand;
  double speed; // in km/h

  Car(this.brand, this.speed);

  Car.stationary(this.brand) : speed = 0.0;

  Car.custom({required this.brand, this.speed = 60.0});

  String getInfo() => '[Car Info] Brand: $brand | Speed: ${speed.toStringAsFixed(1)} km/h';

  String getDrivingStatus() => '$brand is cruising at ${speed.toStringAsFixed(1)} km/h using a gasoline combustion engine.';

  void displayInfo([OutputLogger log = _defaultPrint]) {
    log('  ${getInfo()}');
  }

  void drive([OutputLogger log = _defaultPrint]) {
    log('  ${getDrivingStatus()}');
  }
}

// Subclass: ElectricCar inheriting from Car
class ElectricCar extends Car {
  int batteryCapacity; // in kWh

  ElectricCar(super.brand, super.speed, this.batteryCapacity);

  ElectricCar.eco(super.brand, this.batteryCapacity) : super.stationary();

  @override
  String getInfo() => '[ElectricCar Info] Brand: $brand | Speed: ${speed.toStringAsFixed(1)} km/h | Battery: $batteryCapacity kWh';

  @override
  String getDrivingStatus() => '$brand is accelerating silently at ${speed.toStringAsFixed(1)} km/h powered by a $batteryCapacity kWh electric battery!';

  @override
  void displayInfo([OutputLogger log = _defaultPrint]) {
    log('  ${getInfo()}');
  }

  @override
  void drive([OutputLogger log = _defaultPrint]) {
    log('  ${getDrivingStatus()}');
  }
}

void executeExercise4([OutputLogger log = _defaultPrint]) {
  log('--------------------------------------------------------------------');
  log('>>> EXERCISE 4: Intro to OOP');
  log('--------------------------------------------------------------------');

  log('1. Creating Car using Standard Constructor:');
  Car sedan = Car('Toyota Camry', 110.0);
  sedan.displayInfo(log);
  sedan.drive(log);

  log('\n2. Creating Car using Named Constructor (.stationary):');
  Car parked = Car.stationary('Honda Civic');
  parked.displayInfo(log);
  parked.drive(log);

  log('\n3. Creating ElectricCar subclass (Inheritance & Overriding):');
  ElectricCar tesla = ElectricCar('Tesla Model 3', 140.0, 75);
  tesla.displayInfo(log);
  tesla.drive(log);

  log('\n4. Creating ElectricCar using Named Constructor (.eco):');
  ElectricCar vinFast = ElectricCar.eco('VinFast VF8', 88);
  vinFast.displayInfo(log);
  vinFast.drive(log);
  log('');
}

// ============================================================================
// EXERCISE 5: Async, Future, Null Safety & Streams
// ============================================================================

String? getNullableUsername({bool returnNull = true}) {
  return returnNull ? null : 'Nguyen Van Dev';
}

Future<String> fetchUserDataAsync([OutputLogger log = _defaultPrint]) async {
  log('  [Async Worker] Contacting remote server...');
  await Future.delayed(const Duration(milliseconds: 600));
  return '{"userId": 1024, "username": "prm393_developer", "status": "active"}';
}

Stream<int> generateCountStream(int maxCount, {int delayMs = 150}) async* {
  for (int i = 1; i <= maxCount; i++) {
    await Future.delayed(Duration(milliseconds: delayMs));
    yield i;
  }
}

Future<void> executeExercise5([OutputLogger log = _defaultPrint]) async {
  log('--------------------------------------------------------------------');
  log('>>> EXERCISE 5: Async, Future, Null Safety & Streams');
  log('--------------------------------------------------------------------');

  // 1. Null-Safety operators (?, ??, !)
  log('1. Null-Safety Demonstrations:');

  String? nullableUsername = getNullableUsername(returnNull: true);
  log('  Nullable variable initial state   : $nullableUsername');

  int? nameLength = nullableUsername?.length;
  log('  Safe navigation (?.) result       : $nameLength (no crash, evaluates to null)');

  String activeUser = nullableUsername ?? 'Guest_User';
  log('  Null-coalescing (??) fallback     : $activeUser');

  nullableUsername ??= 'Nguyen Van Dev';
  log('  After null-coalescing assign (??=): $nullableUsername');

  String? guaranteedName = getNullableUsername(returnNull: false);
  String confirmedName = guaranteedName!;
  log('  Null-assertion (!) accessed value : $confirmedName');

  // 2. Async/Await & Future.delayed()
  log('\n2. Asynchronous Execution (Future & await):');
  log('  Waiting for fetchUserDataAsync()...');
  Stopwatch stopwatch = Stopwatch()..start();
  String userData = await fetchUserDataAsync(log);
  stopwatch.stop();
  log('  Received User Data: $userData');
  log('  Execution time    : ${stopwatch.elapsedMilliseconds} ms');

  // 3. Streams: Emitting and Listening
  log('\n3. Stream of Integers:');
  log('  Listening to generateCountStream(5) via await for:');
  await for (int count in generateCountStream(5)) {
    log('  [Stream Event] Received count: $count');
  }

  log('\n  Listening via stream.listen() subscription:');
  Completer<void> streamCompleter = Completer<void>();
  Stream<int> simpleStream = Stream<int>.fromIterable([10, 20, 30, 40]);

  simpleStream.listen(
    (value) => log('  [Stream.listen] Value: $value'),
    onDone: () {
      log('  [Stream.listen] Stream closed.');
      streamCompleter.complete();
    },
  );
  await streamCompleter.future;
  log('');
}
