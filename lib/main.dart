// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_planner/screens/splash_screen.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart'; // تأكد من استيراد ThemeProvider
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // إضافة ThemeProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // نقرأ الثيم من ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        fontFamily: 'Cairo',
      ),
      // home: SplashScreen(),
      home: SplashScreen(),
    );
  }
}