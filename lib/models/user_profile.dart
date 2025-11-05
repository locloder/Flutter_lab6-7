class UserProfile {
  final String id;
  final String name;
  final String title;
  final String bio;
  final List<String> skills;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.skills,
    required this.email,
  });

  // Метод для копіювання (залишається без змін)
  UserProfile copyWith({
    String? id,
    String? name,
    String? title,
    String? bio,
    List<String>? skills,
    String? email,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      email: email ?? this.email,
    );
  }

  // Метод для створення пустого об'єкта (залишається без змін)
  static UserProfile createEmpty() {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Використовуємо унікальний ID
      name: 'Нове Резюме',
      title: 'Ваша Посада',
      bio: 'Тут буде ваше резюме...',
      skills: ['Flutter', 'Dart'],
      email: 'your.email@example.com',
    );
  }

  // === ДОДАНО ДЛЯ JSON СЕРІАЛІЗАЦІЇ ===

  // 1. Метод для перетворення об'єкта Dart на Map<String, dynamic> (для збереження)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'bio': bio,
    'skills': skills,
    'email': email,
  };

  // 2. Фабричний конструктор для створення об'єкта з Map<String, dynamic> (для завантаження)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      bio: json['bio'] as String,
      // Dart не знає, що 'skills' – це List<String>, тому перетворюємо явно
      skills: List<String>.from(json['skills'] as List),
      email: json['email'] as String,
    );
  }
}