import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab02/lab02_logic.dart';

void main() {
  runApp(const DartEssentialsApp());
}

class DartEssentialsApp extends StatelessWidget {
  const DartEssentialsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRM393 - Lab 02: Dart Essentials',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const Lab02HomePage(),
    );
  }
}

class Lab02HomePage extends StatefulWidget {
  const Lab02HomePage({super.key});

  @override
  State<Lab02HomePage> createState() => _Lab02HomePageState();
}

class _Lab02HomePageState extends State<Lab02HomePage> {
  final List<String> _consoleLogs = [];
  final ScrollController _scrollController = ScrollController();
  bool _isRunning = false;

  void _log(String message) {
    setState(() {
      _consoleLogs.add(message);
    });
    // Auto-scroll to bottom of console
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConsole() {
    setState(() {
      _consoleLogs.clear();
    });
  }

  void _copyConsole() {
    Clipboard.setData(ClipboardData(text: _consoleLogs.join('\n')));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Console output copied to clipboard!')),
    );
  }

  Future<void> _runExercise(int number) async {
    if (_isRunning) return;
    setState(() => _isRunning = true);

    try {
      switch (number) {
        case 1:
          executeExercise1(_log);
          break;
        case 2:
          executeExercise2(_log);
          break;
        case 3:
          executeExercise3(_log);
          break;
        case 4:
          executeExercise4(_log);
          break;
        case 5:
          await executeExercise5(_log);
          break;
      }
    } finally {
      if (mounted) {
        setState(() => _isRunning = false);
      }
    }
  }

  Future<void> _runAllExercises() async {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _log('====================================================================');
    _log('              PRM393 - LAB 02: DART ESSENTIALS PRACTICE             ');
    _log('====================================================================\n');

    try {
      executeExercise1(_log);
      executeExercise2(_log);
      executeExercise3(_log);
      executeExercise4(_log);
      await executeExercise5(_log);
      _log('====================================================================');
      _log('                  ALL EXERCISES EXECUTED SUCCESSFULLY               ');
      _log('====================================================================\n');
    } finally {
      if (mounted) {
        setState(() => _isRunning = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.terminal, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'PRM393 - Lab 02: Dart Essentials',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            tooltip: 'Clear Console',
            icon: const Icon(Icons.delete_sweep),
            onPressed: _consoleLogs.isEmpty ? null : _clearConsole,
          ),
          IconButton(
            tooltip: 'Copy Output',
            icon: const Icon(Icons.copy),
            onPressed: _consoleLogs.isEmpty ? null : _copyConsole,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          final exercisePanel = SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Card(
                  elevation: 2,
                  color: theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dart Essentials Practice Lab',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Execute Dart exercises directly below or run all in sequence. Output is displayed in the live console terminal.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _isRunning ? null : _runAllExercises,
                          icon: _isRunning
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.play_arrow),
                          label: Text(_isRunning ? 'Running...' : 'Run All Exercises'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Exercise 1 Card
                _buildExerciseCard(
                  index: 1,
                  title: 'Exercise 1: Basic Syntax & Types',
                  subtitle: 'Variables (int, double, String, bool) & string interpolation',
                  icon: Icons.code,
                  color: Colors.blue,
                ),

                // Exercise 2 Card
                _buildExerciseCard(
                  index: 2,
                  title: 'Exercise 2: Collections & Operators',
                  subtitle: 'List, Set, Map & Arithmetic/Logical/Ternary operators',
                  icon: Icons.data_object,
                  color: Colors.teal,
                ),

                // Exercise 3 Card
                _buildExerciseCard(
                  index: 3,
                  title: 'Exercise 3: Control Flow & Functions',
                  subtitle: 'if/else, switch, for/for-in/forEach, normal & arrow functions',
                  icon: Icons.alt_route,
                  color: Colors.orange,
                ),

                // Exercise 4 Card
                _buildExerciseCard(
                  index: 4,
                  title: 'Exercise 4: Intro to OOP',
                  subtitle: 'Car & ElectricCar classes, constructors, inheritance, overriding',
                  icon: Icons.directions_car,
                  color: Colors.purple,
                ),

                // Exercise 5 Card
                _buildExerciseCard(
                  index: 5,
                  title: 'Exercise 5: Async & Null Safety',
                  subtitle: 'async/await, Future.delayed, ?, ??, !, Stream of integers',
                  icon: Icons.sync,
                  color: Colors.pink,
                ),
              ],
            ),
          );

          final consolePanel = Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal, color: Colors.greenAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'OUTPUT CONSOLE',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_consoleLogs.length} lines',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 16),
                Expanded(
                  child: _consoleLogs.isEmpty
                      ? const Center(
                          child: Text(
                            'Click "Run All Exercises" or any exercise above to view output.',
                            style: TextStyle(color: Colors.white38, fontSize: 13),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _consoleLogs.length,
                          itemBuilder: (context, index) {
                            final line = _consoleLogs[index];
                            Color textColor = Colors.white;
                            if (line.startsWith('>>>')) {
                              textColor = Colors.amberAccent;
                            } else if (line.startsWith('===')) {
                              textColor = Colors.cyanAccent;
                            } else if (line.contains('[Stream Event]')) {
                              textColor = Colors.lightGreenAccent;
                            } else if (line.contains('[Car Info]') || line.contains('[ElectricCar Info]')) {
                              textColor = Colors.lightBlueAccent;
                            }
                            return SelectableText(
                              line,
                              style: TextStyle(
                                color: textColor,
                                fontFamily: 'monospace',
                                fontSize: 12.5,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                SizedBox(width: 420, child: exercisePanel),
                const VerticalDivider(width: 1),
                Expanded(child: consolePanel),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(flex: 5, child: exercisePanel),
                Expanded(flex: 5, child: consolePanel),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildExerciseCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required MaterialColor color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.shade100,
          child: Icon(icon, color: color.shade800),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: FilledButton.tonal(
          onPressed: _isRunning ? null : () => _runExercise(index),
          child: const Text('Run'),
        ),
      ),
    );
  }
}
