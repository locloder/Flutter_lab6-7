// lib/services/local_storage_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user_profile.dart'; // Переконайтеся, що шлях правильний

class LocalStorageService {
  static const String _fileName = 'resumes_data.json';

  // Отримуємо шлях до локального файлу для збереження
  Future<File> get _localFile async {
    // getApplicationDocumentsDirectory() повертає шлях, де програма може
    // зберігати файли, які не будуть видалені системою
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_fileName');
  }

  // Метод для збереження списку резюме у вигляді JSON
  Future<void> saveResumes(List<UserProfile> resumes) async {
    try {
      final file = await _localFile;

      // 1. Перетворюємо List<UserProfile> на List<Map<String, dynamic>>
      final List<Map<String, dynamic>> jsonList = 
          resumes.map((resume) => resume.toJson()).toList();
      
      // 2. Кодуємо List у рядок JSON
      final String jsonString = jsonEncode(jsonList);

      // 3. Записуємо рядок у файл
      await file.writeAsString(jsonString);
      print('✅ Резюме успішно збережено у файл: ${file.path}');
    } catch (e) {
      print('❌ Помилка при збереженні резюме: $e');
    }
  }

  // Метод для завантаження списку резюме з JSON файлу
  Future<List<UserProfile>> loadResumes() async {
    try {
      final file = await _localFile;

      // Перевіряємо, чи існує файл
      if (!await file.exists()) {
        print('Файл збережених резюме не знайдено, повертаємо порожній список.');
        return [];
      }

      // 1. Читаємо рядок JSON з файлу
      final String contents = await file.readAsString();
      
      // 2. Декодуємо рядок у List<dynamic>
      final List<dynamic> jsonList = jsonDecode(contents);

      // 3. Перетворюємо List<dynamic> на List<UserProfile>
      final List<UserProfile> resumes = 
          jsonList.map((json) => UserProfile.fromJson(json as Map<String, dynamic>)).toList();

      print('✅ Резюме успішно завантажено: ${resumes.length} шт.');
      return resumes;

    } catch (e) {
      // Обробка помилок (наприклад, пошкодження файлу або помилка декодування)
      print('❌ Помилка при завантаженні резюме: $e');
      return []; // Повертаємо порожній список, щоб програма не впала
    }
  }
}