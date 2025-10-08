import 'package:my_personal_app/models/user_profile.dart';

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

class UserProfileRepository {
  final List<UserProfile> _userProfiles = [
    UserProfile(
      id: "1",
      name: "Іван Петренко",
      title: "Flutter Developer",
      bio: "Привіт! Я пристрасний розробник мобільних додатків з акцентом на Flutter...",
      skills: ["Flutter", "Dart", "Firebase", "UI/UX Design"],
      email: "ivan.petrenko@example.com",
    ),
    UserProfile(
      id: "2",
      name: "Марія Ковальчук",
      title: "UI/UX Designer",
      bio: "Креативний дизайнер, що спеціалізується на розробці інтуїтивно зрозумілих інтерфейсів.",
      skills: ["Figma", "Sketch", "Prototyping"],
      email: "maria.kovalchuk@example.com",
    ),
  ];

  String _getUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void addProfile(UserProfile profile) {
    final newProfile = profile.copyWith(id: _getUniqueId());
    _userProfiles.add(newProfile);
  }

  void updateProfile(UserProfile updatedProfile) {
    final index = _userProfiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index != -1) {
      _userProfiles[index] = updatedProfile;
    }
  }
  
  List<UserProfile> getAllProfiles() {
    return List.unmodifiable(_userProfiles); 
  }

  UserProfile? getProfileById(String id) {
    return _userProfiles.firstWhereOrNull((profile) => profile.id == id);
  }
}