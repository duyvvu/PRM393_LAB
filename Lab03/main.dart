import 'dart:async';
import 'dart:convert';

/// ============================================================================
/// PRM393 - LAB 3: ADVANCED DART PRACTICE EXERCISES
/// ============================================================================
/// This file contains all 5 completed exercises in a single runnable Dart script.
/// It can be executed with `dart run main.dart` or pasted directly into DartPad.
/// ============================================================================

void main() async {
  print('╔══════════════════════════════════════════════════════════════════╗');
  print('║           LAB 3 - ADVANCED DART PRACTICE EXERCISES               ║');
  print('║                     Course: PRM393                               ║');
  print('╚══════════════════════════════════════════════════════════════════╝\n');

  // Run Exercise 1
  await runExercise1();

  // Run Exercise 2
  await runExercise2();

  // Run Exercise 3
  await runExercise3();

  // Run Exercise 4
  await runExercise4();

  // Run Exercise 5
  runExercise5();

  print('╔══════════════════════════════════════════════════════════════════╗');
  print('║                 ALL 5 EXERCISES COMPLETED!                       ║');
  print('╚══════════════════════════════════════════════════════════════════╝');
}

/// ============================================================================
/// EXERCISE 1: Product Model & Repository
/// Goal: Understand Futures and Streams.
/// ============================================================================

/// Model representing a Product with id, name, and price.
class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  String toString() => 'Product(id: "$id", name: "$name", price: \$$price)';
}

/// Repository providing asynchronous retrieval and real-time stream updates.
class ProductRepository {
  final List<Product> _products = [];

  // Broadcast StreamController allows multiple listeners to receive real-time updates
  final StreamController<Product> _liveAddedController =
      StreamController<Product>.broadcast();

  /// Stream of new products emitted in real-time
  Stream<Product> liveAdded() => _liveAddedController.stream;

  /// Fetches all stored products with simulated network latency
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products);
  }

  /// Adds a product and notifies active stream subscribers
  void addProduct(Product product) {
    _products.add(product);
    _liveAddedController.add(product);
  }

  /// Closes the stream controller
  void dispose() {
    _liveAddedController.close();
  }
}

Future<void> runExercise1() async {
  print('------------------------------------------------------------------');
  print('EXERCISE 1: Product Model & Repository');
  print('------------------------------------------------------------------');

  final repository = ProductRepository();

  // Subscribe to real-time additions via Stream
  print('[1] Subscribing to repository.liveAdded() stream...');
  final subscription = repository.liveAdded().listen((product) {
    print('  ⚡ [Stream Event] Real-time item added: $product');
  });

  // Add sample products with brief delays
  print('[2] Adding products sequentially...');
  repository.addProduct(Product(id: 'P01', name: 'MacBook Pro M3 Max', price: 3499.00));
  await Future.delayed(const Duration(milliseconds: 150));

  repository.addProduct(Product(id: 'P02', name: 'iPhone 16 Pro Max', price: 1199.00));
  await Future.delayed(const Duration(milliseconds: 150));

  repository.addProduct(Product(id: 'P03', name: 'Sony WH-1000XM5', price: 399.99));
  await Future.delayed(const Duration(milliseconds: 150));

  // Retrieve full list using Future<List<Product>>
  print('\n[3] Calling getAll() [Future]...');
  final allProducts = await repository.getAll();
  print('  Retrieved ${allProducts.length} products:');
  for (var p in allProducts) {
    print('   • $p');
  }

  await subscription.cancel();
  repository.dispose();
  print('>>> Exercise 1 done!\n');
}

/// ============================================================================
/// EXERCISE 2: User Repository with JSON
/// Goal: Practice JSON serialization / deserialization.
/// ============================================================================

/// Model representing a User with name and email.
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  /// Factory constructor to parse a JSON Map into a User instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  /// Serializes the User instance into a JSON Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };

  @override
  String toString() => 'User(name: "$name", email: "$email")';
}

/// Repository simulating JSON fetching and parsing from an API.
class UserRepository {
  // Simulated raw JSON string payload
  static const String _mockApiJson = '''
  [
    {"name": "Nguyen Van A", "email": "nguyenvana@example.com"},
    {"name": "Tran Thi B", "email": "tranthib@example.com"},
    {"name": "Le Van C", "email": "levanc@example.com"}
  ]
  ''';

  /// Asynchronously returns a parsed list of Users
  Future<List<User>> fetchUsers() async {
    // Simulate API network latency
    await Future.delayed(const Duration(milliseconds: 300));

    // Decode JSON string to dynamic List
    final List<dynamic> jsonList = jsonDecode(_mockApiJson) as List<dynamic>;

    // Map each JSON object to a User model
    return jsonList
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

Future<void> runExercise2() async {
  print('------------------------------------------------------------------');
  print('EXERCISE 2: User Repository with JSON');
  print('------------------------------------------------------------------');

  final userRepository = UserRepository();

  print('[1] Fetching and parsing mock API JSON response...');
  final users = await userRepository.fetchUsers();

  print('[2] Parsed Users:');
  for (int i = 0; i < users.length; i++) {
    print('  #${i + 1}: ${users[i]}');
  }

  // Demonstrate serialization
  print('\n[3] Re-serializing Users back to JSON string:');
  final encodedJson = jsonEncode(users.map((u) => u.toJson()).toList());
  print('  Result: $encodedJson');

  print('>>> Exercise 2 done!\n');
}

/// ============================================================================
/// EXERCISE 3: Async + Microtask Debugging
/// Goal: Differentiate microtask and event queues.
/// ============================================================================

Future<void> runExercise3() async {
  print('------------------------------------------------------------------');
  print('EXERCISE 3: Async + Microtask Debugging');
  print('------------------------------------------------------------------');

  print('1. [Sync] Main synchronous start');

  // Enqueue to Event Queue via Future()
  Future(() {
    print('5. [Event Queue] Future callback 1 executed');
  });

  // Enqueue to Microtask Queue via scheduleMicrotask()
  scheduleMicrotask(() {
    print('3. [Microtask Queue] scheduleMicrotask 1 executed');
  });

  // Enqueue to Microtask Queue via Future.microtask()
  Future.microtask(() {
    print('4. [Microtask Queue] Future.microtask 2 executed');
  });

  // Enqueue another task to Event Queue
  Future(() {
    print('6. [Event Queue] Future callback 2 executed');
  });

  print('2. [Sync] Main synchronous end');

  // Wait for all queues to drain completely
  await Future.delayed(const Duration(milliseconds: 200));

  print('\n[Explanation]:');
  print('  • Microtasks always execute BEFORE Event Queue callbacks.');
  print('  • The Dart Event Loop first executes all synchronous code.');
  print('  • Next, it completely exhausts the Microtask Queue.');
  print('  • Only when the Microtask Queue is completely empty does the Event');
  print('    Loop pick the next item from the Event Queue (Futures, I/O, Timers).');

  print('>>> Exercise 3 done!\n');
}

/// ============================================================================
/// EXERCISE 4: Stream Transformation
/// Goal: Use functional stream operators (map, where).
/// ============================================================================

Future<void> runExercise4() async {
  print('------------------------------------------------------------------');
  print('EXERCISE 4: Stream Transformation');
  print('------------------------------------------------------------------');

  // 1. Create a stream of numbers 1-5
  final Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('[1] Original input numbers: 1, 2, 3, 4, 5');
  print('[2] Transforming values: map((n) => n * n) then where((sq) => sq % 2 == 0)...');

  // 2. Transform values to their squares using map()
  // 3. Filter even numbers with where()
  final Stream<int> transformedStream = numberStream
      .map((n) {
        final square = n * n;
        print('    • map($n) -> $square');
        return square;
      })
      .where((square) {
        final isEven = square % 2 == 0;
        print('    • where($square is even?) -> $isEven');
        return isEven;
      });

  // 4. Listen and print each emitted value
  print('\n[3] Listening to emitted values:');
  final List<int> results = [];
  final completer = Completer<void>();

  transformedStream.listen(
    (value) {
      results.add(value);
      print('  🎉 Emitted output value: $value');
    },
    onDone: () {
      completer.complete();
    },
  );

  await completer.future;
  print('Final filtered even squares: $results');
  print('>>> Exercise 4 done!\n');
}

/// ============================================================================
/// EXERCISE 5: Factory Constructors & Cache
/// Goal: Show how factory constructors implement caching and singleton pattern.
/// ============================================================================

class Settings {
  // Private static instance holding the cached singleton
  static Settings? _instance;

  String theme;
  int refreshInterval;

  // Private named constructor prevents external direct instantiation
  Settings._internal({
    this.theme = 'Dark Mode',
    this.refreshInterval = 60,
  });

  // Factory constructor returning the singleton instance
  factory Settings() {
    _instance ??= Settings._internal();
    return _instance!;
  }

  @override
  String toString() =>
      'Settings(theme: "$theme", refreshInterval: ${refreshInterval}s)';
}

void runExercise5() {
  print('------------------------------------------------------------------');
  print('EXERCISE 5: Factory Constructors & Cache');
  print('------------------------------------------------------------------');

  print('[1] Creating two instances via factory Settings():');
  final a = Settings();
  final b = Settings();

  print('  Instance a: $a (hashCode: ${a.hashCode})');
  print('  Instance b: $b (hashCode: ${b.hashCode})');

  // Verify that identical(a, b) is true
  final bool sameObject = identical(a, b);
  print('\n[2] Verifying equality:');
  print('  identical(a, b) -> $sameObject');

  if (sameObject) {
    print('  ✅ CONFIRMED: Factory constructor returned the same cached singleton instance!');
  }

  // Modifying via 'a' affects 'b' because they share the same object reference
  print('\n[3] Updating state on reference "a": a.theme = "Cyberpunk Neon"...');
  a.theme = 'Cyberpunk Neon';
  print('  Reference "b" sees updated theme: b.theme = "${b.theme}"');

  print('>>> Exercise 5 done!\n');
}
