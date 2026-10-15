import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note_item.dart';

class FileStorageService {
  static const String _fileName = 'local_notes.json';

  /// In-memory cache fallback (used for tests or environments without native storage)
  List<NoteItem>? _memoryFallback;

  /// Retrieves local File instance inside application documents directory
  Future<File> get _localFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  /// Returns the absolute path where the JSON file is stored
  Future<String> getFilePath() async {
    try {
      final File file = await _localFile;
      return file.path;
    } catch (e) {
      return 'in-memory/$_fileName';
    }
  }

  /// Initial sample notes created when no file exists yet
  List<NoteItem> _getInitialSampleNotes() {
    return [
      NoteItem(
        id: 1,
        title: 'Welcome to Lab 9.2',
        content: 'This note is read and persisted locally in application storage.',
        createdAt: '2026-10-12 09:00',
        isImportant: true,
      ),
      NoteItem(
        id: 2,
        title: 'Persistence Test',
        content: 'Add a new note, restart the app, and see if it remains intact!',
        createdAt: '2026-10-12 10:30',
        isImportant: false,
      ),
    ];
  }

  /// Reads NoteItem list from local JSON file. Creates file with sample data if not found.
  Future<List<NoteItem>> readNotes() async {
    try {
      final File file = await _localFile;
      if (!await file.exists()) {
        final initialNotes = _getInitialSampleNotes();
        await writeNotes(initialNotes);
        return initialNotes;
      }

      final String contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(contents);
      if (decoded is List) {
        return decoded
            .map((item) => NoteItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('FileStorageService read error: $e');
      if (_memoryFallback != null) {
        return List.from(_memoryFallback!);
      }
      _memoryFallback = _getInitialSampleNotes();
      return List.from(_memoryFallback!);
    }
  }

  /// Writes NoteItem list to local JSON file.
  Future<int> writeNotes(List<NoteItem> notes) async {
    final jsonList = notes.map((note) => note.toJson()).toList();
    final String jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

    try {
      final File file = await _localFile;
      await file.writeAsString(jsonString, flush: true);
      _memoryFallback = List.from(notes);
      return jsonString.length;
    } catch (e) {
      debugPrint('FileStorageService write error: $e');
      _memoryFallback = List.from(notes);
      return jsonString.length;
    }
  }

  /// Appends or inserts a new note, then persists.
  Future<List<NoteItem>> addNote(String title, String content, {bool isImportant = false}) async {
    final List<NoteItem> currentNotes = await readNotes();
    final int nextId = currentNotes.isEmpty
        ? 1
        : currentNotes.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    final newNote = NoteItem(
      id: nextId,
      title: title,
      content: content,
      createdAt: DateTime.now().toString().substring(0, 16),
      isImportant: isImportant,
    );

    currentNotes.insert(0, newNote);
    await writeNotes(currentNotes);
    return currentNotes;
  }

  /// Removes note by id and saves back to JSON file.
  Future<List<NoteItem>> deleteNote(int id) async {
    final List<NoteItem> currentNotes = await readNotes();
    currentNotes.removeWhere((item) => item.id == id);
    await writeNotes(currentNotes);
    return currentNotes;
  }

  /// Clears notes file
  Future<void> clearNotes() async {
    try {
      final File file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
    _memoryFallback = [];
  }
}
