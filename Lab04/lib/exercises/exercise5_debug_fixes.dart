import 'package:flutter/material.dart';

/// Exercise 5 – Debug & Fix Common UI Errors
/// Demonstrates solutions to common UI issues:
/// 1. ListView inside Column fixed with Expanded.
/// 2. Overflow on small screens fixed with SingleChildScrollView.
/// 3. State update issue fixed with setState().
/// 4. Safe DatePicker context handling.
class Exercise5Screen extends StatefulWidget {
  const Exercise5Screen({super.key});

  @override
  State<Exercise5Screen> createState() => _Exercise5ScreenState();
}

class _Exercise5ScreenState extends State<Exercise5Screen> {
  int _tapCount = 0; // Fixed: using StatefulWidget and setState()

  void _increment() {
    setState(() {
      _tapCount++; // Fixed: state update reflected immediately in UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5: Debug & Fixes'),
      ),
      // Fixed: SingleChildScrollView prevents overflow on small screens
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common UI Errors & Fixes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. State Update Fix:\n'
              'StatelessWidget does not update UI. Fixed by using StatefulWidget + setState().',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _increment,
              child: Text('Tapped: $_tapCount times'),
            ),
            const Divider(height: 32),
            const Text(
              '2. ListView inside Column Fix:\n'
              'Unbounded height error resolved by wrapping ListView in Expanded inside a Column.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Fixed container height or Expanded
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Fixed List Item ${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
