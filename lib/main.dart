import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Переконайтеся, що всі ці імпорти існують у вашому проекті
import 'package:my_personal_app/app_router.dart';
import 'package:my_personal_app/viewmodels/home_viewmodel.dart';
import 'package:my_personal_app/viewmodels/detail_viewmodel.dart';
import 'package:my_personal_app/viewmodels/github_viewmodel.dart';
import 'package:my_personal_app/models/repositories/user_profile_repository.dart';
import 'package:my_personal_app/models/repositories/github_repository.dart';
import 'package:my_personal_app/services/local_storage_service.dart'; // <--- Новий імпорт

// main() тепер асинхронний, щоб ми могли викликати await для ініціалізації репозиторію
Future<void> main() async {
  // Обов'язково викликаємо це перед роботою з будь-якими плагінами (наприклад, path_provider)
  WidgetsFlutterBinding.ensureInitialized(); 

  // 1. Створення та ініціалізація сервісу локального зберігання
  final localStorageService = LocalStorageService();
  
  // 2. Створення UserProfileRepository та передача йому сервісу зберігання
  final userProfileRepository = UserProfileRepository(
    localStorageService: localStorageService,
  );
  
  // 3. Асинхронне завантаження збережених резюме з файлу.
  // Це гарантує, що дані будуть готові ДО запуску UI.
  await userProfileRepository.initialize(); 

  runApp(
    MultiProvider(
      providers: [
        // Надаємо вже ініціалізований репозиторій
        Provider<UserProfileRepository>(
          create: (_) => userProfileRepository, 
        ),
        
        // HomeViewModel отримує ініціалізований репозиторій
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            repository: userProfileRepository, 
          ),
        ),
        
        // DetailViewModel (залишається без змін)
        ChangeNotifierProvider(
          create: (context) => DetailViewModel(
            repository: Provider.of<UserProfileRepository>(context, listen: false),
          ),
        ),
        
        // --- GitHub залежності (без змін) ---
        Provider<GitHubRepository>(
          create: (_) => GitHubRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => GitHubViewModel(
            repository: Provider.of<GitHubRepository>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Мій Особистий Додаток',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // appRouter тут, ймовірно, знаходиться у вашому файлі app_router.dart
      routerConfig: appRouter, 
    );
  }
}