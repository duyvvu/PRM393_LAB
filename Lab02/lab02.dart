import 'package:lab02/lab02_logic.dart';

/// ============================================================================
/// PRM393 - Mobile Programming
/// Lab 02: Dart Essentials Practice Lab
/// File: lab02.dart
/// 
/// Objectives Covered:
///   1. Basic Syntax & Data Types: main(), int, double, String, bool, print(), interpolation
///   2. Collections & Operators: List, Set, Map, operators (+, -, ==, &&, ?:), add, remove
///   3. Control Flow & Functions: if/else, switch, for/for-in/forEach, normal & arrow functions
///   4. Intro to OOP: Car class, named constructor, ElectricCar inheritance, method overriding
///   5. Async & Null Safety: async/await, Future.delayed, ?, ??, !, Stream of integers
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
