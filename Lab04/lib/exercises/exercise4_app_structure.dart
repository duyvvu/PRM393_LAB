import 'package:flutter/material.dart';

/// Exercise 4 – App Structure with Scaffold, AppBar, FAB & Theme
/// Goal: Practice building complete screen structure and theme toggling.
class Exercise4Screen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const Exercise4Screen({super.key, required this.themeNotifier});

  @override
  State<Exercise4Screen> createState() => _Exercise4ScreenState();
}

class _Exercise4ScreenState extends State<Exercise4Screen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4: App Structure & Theme'),
        actions: [
          // Theme mode toggle button
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.themeNotifier.value =
                  isDarkMode ? ThemeMode.light : ThemeMode.dark;
            },
            tooltip: 'Toggle Dark/Light Mode',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Action executed! Counter is $_counter'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Show SnackBar'),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
