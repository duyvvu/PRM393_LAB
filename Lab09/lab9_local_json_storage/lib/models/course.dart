class Course {
  final int id;
  final String code;
  final String title;
  final String instructor;
  final int credits;
  final String category;
  final String description;

  const Course({
    required this.id,
    required this.code,
    required this.title,
    required this.instructor,
    required this.credits,
    required this.category,
    required this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      category: json['category'] as String? ?? 'General',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'instructor': instructor,
      'credits': credits,
      'category': category,
      'description': description,
    };
  }
}
