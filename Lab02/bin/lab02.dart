import 'package:lab02/lab02_logic.dart';

/// ============================================================================
/// PRM393 - Mobile Programming
/// Lab 02: Dart Essentials Practice Lab (CLI Entry Point)
/// File: bin/lab02.dart
/// ============================================================================

void main() async {
  print('====================================================================');
  print('              PRM393 - LAB 02: DART ESSENTIALS PRACTICE             ');
  print('====================================================================\n');

  // Exercise 1: Basic Syntax & Data Types
  executeExercise1();

  // Exercise 2: Collections & Operators
  executeExercise2();

  // Exercise 3: Control Flow & Functions
  executeExercise3();

  // Exercise 4: Intro to OOP (Classes, Inheritance & Overriding)
  executeExercise4();

  // Exercise 5: Async, Future, Null Safety & Streams
  await executeExercise5();

  print('====================================================================');
  print('                  ALL EXERCISES EXECUTED SUCCESSFULLY               ');
  print('====================================================================');
}
