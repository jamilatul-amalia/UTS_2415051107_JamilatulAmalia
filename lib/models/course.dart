// Nama: Jamilatul Amalia
// NIM: 2415051107

class Course {
  final int? id;
  final String? ownerId;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String description;

  const Course({
    this.id,
    this.ownerId,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.description = '',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      ownerId: json['owner_id'] as String?,
      code: (json['code'] as String?) ?? 'MOB0${json['id'] ?? 1}',
      title: (json['title'] as String?) ?? '',
      credits: (json['credits'] as int?) ?? 3,
      status: (json['status'] as String?) ?? 'planned',
      description:
          (json['description'] as String?) ?? (json['body'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (ownerId != null) 'owner_id': ownerId,
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
        'description': description,
      };
}