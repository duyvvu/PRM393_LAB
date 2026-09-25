import 'dart:async';
import 'dart:convert';

/// ============================================================================
/// PRM393 - LAB 3: ADVANCED DART PRACTICE EXERCISES
/// Core Logic & Class Definitions
/// ============================================================================

typedef OutputLogger = void Function(String message);
void _defaultPrint(String message) => print(message);

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

  final StreamController<Product> _liveAddedController =
      StreamController<Product>.broadcast();

  /// Stream of new products emitted in real-time
  Stream<Product> liveAdded() => _liveAddedController.stream;

  /// Fetches all stored products with simulated network latency
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
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

Future<void> executeExercise1([OutputLogger log = _defaultPrint]) async {
  log('------------------------------------------------------------------');
  log('EXERCISE 1: Product Model & Repository');
  log('------------------------------------------------------------------');

  final repository = ProductRepository();

  // Subscribe to real-time additions via Stream
  log('[1] Subscribing to repository.liveAdded() stream...');
  final subscription = repository.liveAdded().listen((product) {
    log('  ⚡ [Stream Event] Real-time item added: $product');
  });

  // Add sample products with brief delays
  log('[2] Adding products sequentially...');
  repository.addProduct(Product(id: 'P01', name: 'MacBook Pro M3 Max', price: 3499.00));
  await Future.delayed(const Duration(milliseconds: 100));

  repository.addProduct(Product(id: 'P02', name: 'iPhone 16 Pro Max', price: 1199.00));
  await Future.delayed(const Duration(milliseconds: 100));

  repository.addProduct(Product(id: 'P03', name: 'Sony WH-1000XM5', price: 399.99));
  await Future.delayed(const Duration(milliseconds: 100));

  // Retrieve full list using Future<List<Product>>
  log('\n[3] Calling getAll() [Future]...');
  final allProducts = await repository.getAll();
  log('  Retrieved ${allProducts.length} products:');
  for (var p in allProducts) {
    log('   • $p');
  }

  await subscription.cancel();
  repository.dispose();
  log('>>> Exercise 1 done!\n');
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
  static const String _mockApiJson = '''
  [
    {"name": "Nguyen Van A", "email": "nguyenvana@example.com"},
    {"name": "Tran Thi B", "email": "tranthib@example.com"},
    {"name": "Le Van C", "email": "levanc@example.com"}
  ]
  ''';

  /// Asynchronously returns a parsed list of Users
  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final List<dynamic> jsonList = jsonDecode(_mockApiJson) as List<dynamic>;

    return jsonList
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

Future<void> executeExercise2([OutputLogger log = _defaultPrint]) async {
  log('------------------------------------------------------------------');
  log('EXERCISE 2: User Repository with JSON');
  log('------------------------------------------------------------------');

  final userRepository = UserRepository();

  log('[1] Fetching and parsing mock API JSON response...');
  final users = await userRepository.fetchUsers();

  log('[2] Parsed Users:');
  for (int i = 0; i < users.length; i++) {
    log('  #${i + 1}: ${users[i]}');
  }

  log('\n[3] Re-serializing Users back to JSON string:');
  final encodedJson = jsonEncode(users.map((u) => u.toJson()).toList());
  log('  Result: $encodedJson');

  log('>>> Exercise 2 done!\n');
}

/// ============================================================================
/// EXERCISE 3: Async + Microtask Debugging
/// Goal: Differentiate microtask and event queues.
/// ============================================================================

Future<void> executeExercise3([OutputLogger log = _defaultPrint]) async {
  log('------------------------------------------------------------------');
  log('EXERCISE 3: Async + Microtask Debugging');
  log('------------------------------------------------------------------');

  log('1. [Sync] Main synchronous start');

  Future(() {
    log('5. [Event Queue] Future callback 1 executed');
  });

  scheduleMicrotask(() {
    log('3. [Microtask Queue] scheduleMicrotask 1 executed');
  });

  Future.microtask(() {
    log('4. [Microtask Queue] Future.microtask 2 executed');
  });

  Future(() {
    log('6. [Event Queue] Future callback 2 executed');
  });

  log('2. [Sync] Main synchronous end');

  await Future.delayed(const Duration(milliseconds: 150));

  log('\n[Explanation]:');
  log('  • Microtasks always execute BEFORE Event Queue callbacks.');
  log('  • The Dart Event Loop first executes all synchronous code.');
  log('  • Next, it completely exhausts the Microtask Queue.');
  log('  • Only when the Microtask Queue is completely empty does the Event');
  log('    Loop pick the next item from the Event Queue (Futures, I/O, Timers).');

  log('>>> Exercise 3 done!\n');
}

/// ============================================================================
/// EXERCISE 4: Stream Transformation
/// Goal: Use functional stream operators (map, where).
/// ============================================================================

Future<void> executeExercise4([OutputLogger log = _defaultPrint]) async {
  log('------------------------------------------------------------------');
  log('EXERCISE 4: Stream Transformation');
  log('------------------------------------------------------------------');

  final Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  log('[1] Original input numbers: 1, 2, 3, 4, 5');
  log('[2] Transforming values: map((n) => n * n) then where((sq) => sq % 2 == 0)...');

  final Stream<int> transformedStream = numberStream
      .map((n) {
        final square = n * n;
        log('    • map($n) -> $square');
        return square;
      })
      .where((square) {
        final isEven = square % 2 == 0;
        log('    • where($square is even?) -> $isEven');
        return isEven;
      });

  log('\n[3] Listening to emitted values:');
  final List<int> results = [];
  final completer = Completer<void>();

  transformedStream.listen(
    (value) {
      results.add(value);
      log('  🎉 Emitted output value: $value');
    },
    onDone: () {
      completer.complete();
    },
  );

  await completer.future;
  log('Final filtered even squares: $results');
  log('>>> Exercise 4 done!\n');
}

/// ============================================================================
/// EXERCISE 5: Factory Constructors & Cache
/// Goal: Show how factory constructors implement caching and singleton pattern.
/// ============================================================================

class Settings {
  static Settings? _instance;

  String theme;
  int refreshInterval;

  Settings._internal()
      : theme = 'Dark Mode',
        refreshInterval = 60;

  factory Settings({String? theme, int? refreshInterval}) {
    _instance ??= Settings._internal();
    if (theme != null) _instance!.theme = theme;
    if (refreshInterval != null) _instance!.refreshInterval = refreshInterval;
    return _instance!;
  }

  static void resetForTesting() {
    _instance = null;
  }

  @override
  String toString() =>
      'Settings(theme: "$theme", refreshInterval: ${refreshInterval}s)';
}

void executeExercise5([OutputLogger log = _defaultPrint]) {
  log('------------------------------------------------------------------');
  log('EXERCISE 5: Factory Constructors & Cache');
  log('------------------------------------------------------------------');

  log('[1] Creating two instances via factory Settings():');
  final a = Settings();
  final b = Settings();

  log('  Instance a: $a (hashCode: ${a.hashCode})');
  log('  Instance b: $b (hashCode: ${b.hashCode})');

  final bool sameObject = identical(a, b);
  log('\n[2] Verifying equality:');
  log('  identical(a, b) -> $sameObject');

  if (sameObject) {
    log('  ✅ CONFIRMED: Factory constructor returned the same cached singleton instance!');
  }

  log('\n[3] Updating state on reference "a": a.theme = "Cyberpunk Neon"...');
  a.theme = 'Cyberpunk Neon';
  log('  Reference "b" sees updated theme: b.theme = "${b.theme}"');

  log('>>> Exercise 5 done!\n');
}
