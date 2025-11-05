import 'package:my_personal_app/models/user_profile.dart';
import 'package:my_personal_app/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

// Розширення для List (залишаємо, як у вашому оригіналі)
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
  // Змінна для зберігання резюме в пам'яті
  List<UserProfile> _userProfiles = [];
  
  // Сервіс для роботи з файловою системою
  final LocalStorageService _localStorageService;
  
  // Генератор унікальних ID
  final Uuid _uuid = const Uuid();

  // Конструктор, який приймає LocalStorageService
  UserProfileRepository({LocalStorageService? localStorageService})
      : _localStorageService = localStorageService ?? LocalStorageService();

  // === 1. ІНІЦІАЛІЗАЦІЯ (ЗАВАНТАЖЕННЯ З ПРИСТРОЮ) ===
  
  /// Асинхронно завантажує збережені резюме з файлу.
  /// Цей метод повинен викликатися один раз при запуску програми (див. main.dart).
  Future<void> initialize() async {
    _userProfiles = await _localStorageService.loadResumes();

    // Якщо список порожній (перший запуск або файл видалено), 
    // додаємо одне пусте резюме як стартовий елемент.
    if (_userProfiles.isEmpty) {
      final starterProfile = UserProfile.createEmpty().copyWith(
        id: _uuid.v4(),
      );
      _userProfiles.add(starterProfile);
      // Зберігаємо його, щоб файл створився
      _saveData(); 
    }
  }
  
  // === 2. РОБОТА З ДАНИМИ ===

  List<UserProfile> getAllProfiles() {
    // Повертаємо незмінну копію, щоб ViewModels не могли модифікувати список без репозиторію
    return List.unmodifiable(_userProfiles); 
  }

  UserProfile? getProfileById(String id) {
    return _userProfiles.firstWhereOrNull((profile) => profile.id == id);
  }

  /// Додає нове резюме з унікальним ID
  void addProfile(UserProfile profile) {
    // Гарантуємо унікальність ID при створенні нового профілю
    final newProfile = profile.copyWith(id: _uuid.v4()); 
    _userProfiles.add(newProfile);
    _saveData(); // Збереження змін у файл
  }

  /// Оновлює існуюче резюме за ID
  void updateProfile(UserProfile updatedProfile) {
    final index = _userProfiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index != -1) {
      _userProfiles[index] = updatedProfile;
      _saveData(); // Збереження змін у файл
    }
  }
  
  /// Видаляє резюме за ID
  void deleteProfile(String id) {
    _userProfiles.removeWhere((p) => p.id == id);
    _saveData(); // Збереження змін у файл
  }

  // === 3. ЗБЕРЕЖЕННЯ У ФАЙЛ ===

  /// Приватний метод для асинхронного збереження поточного списку у файл.
  /// Викликається після кожної модифікації даних.
  void _saveData() {
    // Викликаємо збереження, але не чекаємо його (await), 
    // щоб не блокувати UI-потік.
    _localStorageService.saveResumes(_userProfiles);
  }
}