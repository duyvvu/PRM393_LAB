class NoteItem {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final bool isImportant;

  NoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isImportant = false,
  });

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      isImportant: json['isImportant'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'isImportant': isImportant,
    };
  }

  NoteItem copyWith({
    int? id,
    String? title,
    String? content,
    String? createdAt,
    bool? isImportant,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
