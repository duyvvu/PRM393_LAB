import 'package:flutter/material.dart';
import 'exercises/exercise1_core_widgets.dart';
import 'exercises/exercise2_input_controls.dart';
import 'exercises/exercise3_layout_basics.dart';
import 'exercises/exercise4_app_structure.dart';
import 'exercises/exercise5_debug_fixes.dart';

void main() {
  runApp(const Lab04App());
}

class Lab04App extends StatefulWidget {
  const Lab04App({super.key});

  @override
  State<Lab04App> createState() => _Lab04AppState();
}

class _Lab04AppState extends State<Lab04App> {
  final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'PRM393 - Lab 04: Flutter UI Fundamentals',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: Lab04HomeScreen(themeNotifier: _themeNotifier),
        );
      },
    );
  }
}

class Lab04HomeScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const Lab04HomeScreen({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4: Flutter UI Fundamentals'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Select an Exercise:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildExerciseCard(
            context,
            title: 'Exercise 1',
            subtitle: 'Core Widgets: Text, Image, Icon, Card, ListTile',
            icon: Icons.widgets,
            destination: const Exercise1Screen(),
          ),
          _buildExerciseCard(
            context,
            title: 'Exercise 2',
            subtitle: 'Input Widgets: Slider, Switch, Radio, DatePicker',
            icon: Icons.tune,
            destination: const Exercise2Screen(),
          ),
          _buildExerciseCard(
            context,
            title: 'Exercise 3',
            subtitle: 'Layout Basics: Column, Row, Padding, ListView',
            icon: Icons.dashboard,
            destination: const Exercise3Screen(),
          ),
          _buildExerciseCard(
            context,
            title: 'Exercise 4',
            subtitle: 'App Structure: Scaffold, AppBar, FAB & Theme',
            icon: Icons.phone_android,
            destination: Exercise4Screen(themeNotifier: themeNotifier),
          ),
          _buildExerciseCard(
            context,
            title: 'Exercise 5',
            subtitle: 'Debug & Fix Common UI Errors',
            icon: Icons.bug_report,
            destination: const Exercise5Screen(),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}
