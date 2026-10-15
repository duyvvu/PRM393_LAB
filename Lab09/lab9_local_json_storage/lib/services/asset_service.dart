import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

class AssetService {
  static const String defaultAssetPath = 'assets/data/courses.json';

  /// Loads and parses Course list from assets bundle.
  Future<List<Course>> loadCourses({String path = defaultAssetPath}) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is List) {
        return decoded
            .map((item) => Course.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw const FormatException('Expected JSON array at root');
      }
    } catch (e) {
      throw Exception('Failed to load courses from asset "$path": $e');
    }
  }

  /// Loads raw JSON string from given asset path (useful for raw inspection).
  Future<String> loadRawString({String path = defaultAssetPath}) async {
    return await rootBundle.loadString(path);
  }
}
