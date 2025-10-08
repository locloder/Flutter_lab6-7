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

  static UserProfile createEmpty() {
    return UserProfile(
      id: '', 
      name: 'Нове Резюме',
      title: 'Ваша Посада',
      bio: 'Тут буде ваше резюме...',
      skills: ['Flutter', 'Dart'],
      email: 'your.email@example.com',
    );
  }
}