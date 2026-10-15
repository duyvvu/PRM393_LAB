import 'package:flutter/material.dart';
import '../models/note_item.dart';
import '../services/file_storage_service.dart';

class Lab92StorageScreen extends StatefulWidget {
  const Lab92StorageScreen({super.key});

  @override
  State<Lab92StorageScreen> createState() => _Lab92StorageScreenState();
}

class _Lab92StorageScreenState extends State<Lab92StorageScreen> {
  final FileStorageService _storageService = FileStorageService();
  List<NoteItem> _notes = [];
  bool _isLoading = true;
  String _filePath = '';
  String _statusMessage = 'Ready';
  bool _hasUnsavedChanges = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isImportant = false;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _initStorage() async {
    setState(() => _isLoading = true);
    final path = await _storageService.getFilePath();
    final loadedNotes = await _storageService.readNotes();

    setState(() {
      _filePath = path;
      _notes = loadedNotes;
      _isLoading = false;
      _hasUnsavedChanges = false;
      _statusMessage = 'Loaded ${_notes.length} note(s) from local JSON file.';
    });
  }

  Future<void> _manualSave() async {
    setState(() => _isLoading = true);
    final bytes = await _storageService.writeNotes(_notes);
    setState(() {
      _isLoading = false;
      _hasUnsavedChanges = false;
      _statusMessage = 'File saved successfully ($bytes bytes written).';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved ${_notes.length} items to local storage ($bytes bytes)'),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddNoteDialog() {
    _titleController.clear();
    _contentController.clear();
    _isImportant = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add New Note'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Mark as Important'),
                    value: _isImportant,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setDialogState(() => _isImportant = val ?? false);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final content = _contentController.text.trim();
                  if (title.isEmpty || content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in both title and content.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  final nextId = _notes.isEmpty
                      ? 1
                      : _notes.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

                  final newNote = NoteItem(
                    id: nextId,
                    title: title,
                    content: content,
                    createdAt: DateTime.now().toString().substring(0, 16),
                    isImportant: _isImportant,
                  );

                  setState(() {
                    _notes.insert(0, newNote);
                    _hasUnsavedChanges = true;
                    _statusMessage = 'Added note "#$nextId". Click "Save to Disk" or use auto-save.';
                  });

                  Navigator.pop(ctx);
                },
                child: const Text('Add to List'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteNote(int id) {
    setState(() {
      _notes.removeWhere((item) => item.id == id);
      _hasUnsavedChanges = true;
      _statusMessage = 'Removed note #$id. Don\'t forget to save!';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note #$id removed from list.'),
        action: SnackBarAction(
          label: 'Save Now',
          onPressed: _manualSave,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Local Storage JSON'),
        actions: [
          IconButton(
            tooltip: 'Reload from Disk (Persistence Check)',
            icon: const Icon(Icons.sync),
            onPressed: _initStorage,
          ),
          IconButton(
            tooltip: 'Save to Disk',
            icon: Icon(
              Icons.save,
              color: _hasUnsavedChanges ? Colors.amber[300] : null,
            ),
            onPressed: _manualSave,
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage Status Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _hasUnsavedChanges ? Icons.warning_amber : Icons.storage,
                      size: 18,
                      color: _hasUnsavedChanges ? Colors.orange : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _hasUnsavedChanges ? Colors.orange[900] : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Path: $_filePath',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Items (${_notes.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _manualSave,
                  icon: const Icon(Icons.save, size: 16),
                  label: Text(_hasUnsavedChanges ? 'Save *' : 'Save'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _showAddNoteDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Note'),
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.note_add, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            const Text('No notes yet in local storage.'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _showAddNoteDialog,
                              child: const Text('Create First Note'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _initStorage,
                        child: ListView.builder(
                          itemCount: _notes.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return Card(
                              elevation: note.isImportant ? 2.5 : 1.0,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                side: note.isImportant
                                    ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
                                    : BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: note.isImportant
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.surfaceContainerHighest,
                                  foregroundColor: note.isImportant
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                  child: Icon(
                                    note.isImportant ? Icons.star : Icons.description,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  note.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(note.content),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Saved at: ${note.createdAt}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _deleteNote(note.id),
                                  tooltip: 'Delete',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNoteDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}
