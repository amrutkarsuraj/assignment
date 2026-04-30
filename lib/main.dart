import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/notification_service.dart';
import 'features/recipe/presentation/providers/repository_provider.dart';
import 'features/recipe/presentation/screens/home_screen.dart';

final container = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('recipes');
  await Hive.openBox('favorites');

  final notificationService = NotificationService();
  await notificationService.init();

  final repo = container.read(repositoryProvider);

  Future<String> breakfastText() async {
    final list = await repo.getRecipes("Seafood"); // mapped breakfast
    return list.isNotEmpty ? "Try ${list.first.name}" : "Start fresh today!";
  }

  Future<String> lunchText() async {
    final list = await repo.getRecipes("Chicken");
    return list.isNotEmpty ? "Have ${list.first.name}" : "Lunch time ideas!";
  }

  Future<String> dinnerText() async {
    final list = await repo.getRecipes("Beef");
    return list.isNotEmpty ? "Cook ${list.first.name}" : "Dinner suggestions!";
  }

  await notificationService.scheduleDailyMeals(
    breakfastText: breakfastText,
    lunchText: lunchText,
    dinnerText: dinnerText,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // ✅ IMPORTANT
      debugShowCheckedModeBanner: false,
      title: 'Smart Recipes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}